#!/usr/bin/env bash
#
# @description  Detects CLI config files and writes persona agent bindings.
#               Each persona gets a named agent with its model read
#               directly from frontmatter. Thinking budget is set
#               per-agent based on persona humor style.
#
# Multi-CLI agent configuration. Currently OpenCode only — add new CLIs
# by adding a resolve<Name>ConfigPath function and updating resolveSupportedCliConfigPath.
#
# @usage        maestro-boot-configure-cli.sh
# @output       Summary line with agent count, or nothing if no CLI config found.
# @requires     bash v4+, yq v4+, jq v1.6+, ps
# @version      0.6.13
# @updated      2026-06-25
#
# ── Thinking/Reasoning Configuration ─────────────────────────────────────────
#
# Agent bindings emit BOTH Anthropic and OpenAI thinking formats so either SDK
# respects the setting. The provider SDK determines which format is used:
#
#   Anthropic SDK (@ai-sdk/anthropic):
#     - Uses "thinking" field: {type: "enabled", budgetTokens: N}
#     - Config-level thinking is IGNORED by `opencode run` (only --thinking flag works)
#     - `--thinking` CLI flag forces thinking ON, overriding config
#
#   OpenAI-compatible SDK (@ai-sdk/openai-compatible):
#     - Uses "reasoning" field: {effort: "low"|"medium"|"high"|"xhigh"}
#     - Also emits "reasoningEffort" (flat) for opencode pass-through compatibility
#     - Config-level thinking IS respected by `opencode run`
#
# Humor → Thinking Budget → Effort Mapping:
#   robotic     → budget=4096  → thinking.type=enabled,  reasoning.effort=low,  reasoningEffort=low
#   introvert   → budget=8192  → thinking.type=enabled,  reasoning.effort=low,  reasoningEffort=low
#   pragmatic   → budget=12288 → thinking.type=enabled,  reasoning.effort=medium, reasoningEffort=medium
#   sympathetic → budget=14336 → thinking.type=enabled,  reasoning.effort=high, reasoningEffort=high
#   extrovert   → budget=16384 → thinking.type=enabled,  reasoning.effort=xhigh, reasoningEffort=xhigh
#
# ──────────────────────────────────────────────────────────────────────────────

set -euo pipefail

checkRequiredDependencies() {
  local toolName missingToolList
  missingToolList=""

  for toolName in "$@"; do
    if ! command -v "$toolName" >/dev/null 2>&1; then
      if [ -n "$missingToolList" ]; then
        missingToolList="${missingToolList}, ${toolName}"
        continue
      fi
      missingToolList="$toolName"
    fi
  done

  if [ -n "$missingToolList" ]; then
    echo "Skipping: $missingToolList not installed — CLI configuration requires these tools" >&2
    exit 0
  fi
}

# ── Environment Detection ───────────────────────────────────────

isRunningInsideSupportedCli() {
  if [ -n "${isRunningInsideSupportedCliEnvOverride:-}" ]; then
    echo "$isRunningInsideSupportedCliEnvOverride"
    return 0
  fi

  local currentPid="$PPID"
  local processName

  while [ "$currentPid" -gt 1 ] 2>/dev/null; do
    processName=$(ps -o comm= -p "$currentPid" 2>/dev/null || true)
    if [ -z "$processName" ]; then
      break
    fi
    processName="${processName#.}"
    if [ "$processName" = "opencode" ]; then
      echo "true"
      return 0
    fi
    currentPid=$(ps -o ppid= -p "$currentPid" 2>/dev/null || true)
    currentPid="${currentPid// /}"
  done

  echo "false"
  return 0
}

resolveScriptDir() {
  (cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
}

resolveSupportedCliConfigPath() {
  if [ -f "opencode.json" ]; then
    echo "opencode.json existed"
    return 0
  fi
  echo '{"$schema": "https://opencode.ai/config.json", "agent": {"plan": {"disable": true}}}' > opencode.json
  echo "opencode.json created"
  return 0
}

readPersonaFrontmatter() {
  local personaPath="$1"
  awk '/^---$/{n++; next} n==1{print} n==2{exit}' "$personaPath"
}

readProvidersYamlBlock() {
  local dispatchMdPath
  dispatchMdPath="$(resolveScriptDir)/../dispatch.md"
  awk '/^## Providers$/{inProviders=1; next} /^## /{inProviders=0} inProviders && /^```yaml$/{inBlock=1; next} inBlock && /^```$/{exit} inBlock{print}' "$dispatchMdPath"
}

resolveSupportedCliProviderName() {
  local hostModelId="${1:-}"
  local supportedCliProviderKey=""
  if [ -n "$hostModelId" ]; then
    supportedCliProviderKey=$(readProvidersYamlBlock | yq ".providers | to_entries[] | select(.value | has(\"tier-1\", \"tier-2\", \"tier-3\") and (.value.\"tier-1\" == \"$hostModelId\" or .value.\"tier-2\" == \"$hostModelId\" or .value.\"tier-3\" == \"$hostModelId\")) | .key // \"\"" 2>/dev/null | head -1 || true)
  fi
  if [ -z "$supportedCliProviderKey" ]; then
    supportedCliProviderKey=$(readProvidersYamlBlock | yq '.providers | to_entries[] | select(.value.cli == "opencode") | .key // ""' 2>/dev/null | head -1 || true)
  fi
  echo "$supportedCliProviderKey"
  return 0
}

isProviderOnSupportedCli() {
  local providerName="$1"
  local providerCli
  providerCli=$(readProvidersYamlBlock | yq ".providers[\"$providerName\"].cli // \"\"" 2>/dev/null || true)
  if [ "$providerCli" = "opencode" ]; then
    echo "true"
    return 0
  fi
  echo "false"
}

resolveHostProviderName() {
  local hostModelId="${1:-$hostModelId}"
  if [ "${resolveHostProviderNameEnvOverride+set}" = "set" ]; then
    echo "$resolveHostProviderNameEnvOverride"
    return 0
  fi

  resolveSupportedCliProviderName "$hostModelId"
}

resolveProviderModelId() {
  local providerName="$1"
  local modelTier="$2"

  local resolvedModelString
  resolvedModelString=$(readProvidersYamlBlock | yq ".providers[\"$providerName\"][\"$modelTier\"] // \"\"")

  if [ "$resolvedModelString" = "null" ]; then
    echo ""
    return 0
  fi

  echo "$resolvedModelString"
  return 0
}

resolvePersonaModelId() {
  local personaPath="$1"

  local frontmatterYaml preferredModelValue modelTierValue providerName resolvedModelString
  frontmatterYaml=$(readPersonaFrontmatter "$personaPath")
  preferredModelValue=$(echo "$frontmatterYaml" | yq '.preferredModel // ""')

  if [ -z "$preferredModelValue" ]; then
    echo ""
    return 0
  fi

  modelTierValue=$(echo "$frontmatterYaml" | yq '.modelTier // "tier-2"')

  if [ "$preferredModelValue" = "host" ]; then
    providerName=$(resolveHostProviderName)
    if [ -z "$providerName" ]; then
      echo ""
      return 0
    fi
    resolvedModelString=$(resolveProviderModelId "$providerName" "$modelTierValue")
    echo "$resolvedModelString"
    return 0
  fi

  if [ "$(isProviderOnSupportedCli "$preferredModelValue")" != "true" ]; then
    echo ""
    return 0
  fi

  resolvedModelString=$(resolveProviderModelId "$preferredModelValue" "$modelTierValue")
  echo "$resolvedModelString"
}

readPersonaShortDescription() {
  local personaPath="$1"
  readPersonaFrontmatter "$personaPath" | yq '.shortDescription // ""'
}

readPersonaHumor() {
  local personaPath="$1"
  readPersonaFrontmatter "$personaPath" | yq '.humor // "default"'
}

resolveHumorAttributes() {
  local humor="$1"
  local attribute="$2"
  case "$humor" in
    robotic)
      case "$attribute" in
        temperature)      echo "0.2" ;;
        topP)             echo "0.7" ;;
        thinkingBudget)   echo "4096" ;;
        reasoningEffort)  echo "low" ;;
      esac
      ;;
    introvert)
      case "$attribute" in
        temperature)      echo "0.2" ;;
        topP)             echo "0.75" ;;
        thinkingBudget)   echo "8192" ;;
        reasoningEffort)  echo "low" ;;
      esac
      ;;
    pragmatic)
      case "$attribute" in
        temperature)      echo "0.25" ;;
        topP)             echo "0.8" ;;
        thinkingBudget)   echo "12288" ;;
        reasoningEffort)  echo "medium" ;;
      esac
      ;;
    sympathetic)
      case "$attribute" in
        temperature)      echo "0.3" ;;
        topP)             echo "0.85" ;;
        thinkingBudget)   echo "14336" ;;
        reasoningEffort)  echo "high" ;;
      esac
      ;;
    extrovert)
      case "$attribute" in
        temperature)      echo "0.35" ;;
        topP)             echo "0.85" ;;
        thinkingBudget)   echo "16384" ;;
        reasoningEffort)  echo "xhigh" ;;
      esac
      ;;
    *)
      echo ""
      ;;
  esac
}

extractPersonaName() {
  local personaPath="$1"
  basename "$personaPath" .md
}

shouldSkipPersona() {
  local personaName="$1"
  if [ "$personaName" = "README" ]; then
    echo "true"
    return 0
  fi
  echo "false"
}

resolveAgentName() {
  local personaName="$1"
  if [ "$personaName" = "maestro" ]; then
    echo "build"
    return
  fi
  echo "$personaName"
}

applyPermissionProfile() {
  local personaName="$1"
  local agentBindings="$2"

  local profileJson

  case "$personaName" in
    maestro|build)
      profileJson='{
  "permission": {
    "bash": {
      "*": "ask",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
      "git clean *": "deny",
      "git reset *": "deny",
      "git rebase *": "deny",
      "git push --force *": "deny",
      "git push -f *": "deny",
      "bash skills/assets/*.sh *": "allow",
      "yq *": "allow",
      "jq *": "allow",
      "mktemp *": "allow",
      "echo *": "allow",
      "printf *": "allow",
      "which *": "allow",
      "command *": "allow",
      "basename *": "allow",
      "dirname *": "allow",
      "realpath *": "allow",
      "readlink *": "allow",
      "env *": "allow",
      "pwd *": "allow",
      "date *": "allow",
      "id *": "allow",
      "ps *": "allow",
      "test *": "allow",
      "ls *": "allow",
      "find *": "allow",
      "grep *": "allow",
      "rg *": "allow",
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "wc *": "allow",
      "sort *": "allow",
      "sed *": "allow",
      "awk *": "allow",
      "tr *": "allow",
      "cut *": "allow",
      "uniq *": "allow",
      "stat *": "allow",
      "diff *": "allow",
      "tree *": "allow",
      "read *": "allow",
      "git *": "allow",
      "mkdir *": "allow",
      "touch *": "allow",
      "cp *": "allow",
      "mv *": "allow",
      "tee *": "allow",
      "xargs *": "allow",
      "ln *": "allow"
    },
    "edit": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "ask"
    },
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny"
    },
    "external_directory": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "/tmp/*": "allow"
    }
  }
}'
      ;;
    architect)
      profileJson='{
  "permission": {
    "bash": {
      "*": "deny",
      "sed -i *": "deny",
      "cp *": "deny",
      "mv *": "deny",
      "touch *": "deny",
      "tee *": "deny",
      "xargs *": "deny",
      "ln *": "deny",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
      "git clean *": "deny",
      "git reset *": "deny",
      "git rebase *": "deny",
      "git push --force *": "deny",
      "git push -f *": "deny",
      "yq *": "allow",
      "jq *": "allow",
      "mktemp *": "allow",
      "echo *": "allow",
      "printf *": "allow",
      "which *": "allow",
      "command *": "allow",
      "basename *": "allow",
      "dirname *": "allow",
      "realpath *": "allow",
      "readlink *": "allow",
      "env *": "allow",
      "pwd *": "allow",
      "date *": "allow",
      "id *": "allow",
      "ps *": "allow",
      "test *": "allow",
      "ls *": "allow",
      "find *": "allow",
      "grep *": "allow",
      "rg *": "allow",
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "sort *": "allow",
      "sed *": "allow",
      "awk *": "allow",
      "tr *": "allow",
      "cut *": "allow",
      "uniq *": "allow",
      "wc *": "allow",
      "tree *": "allow",
      "read *": "allow",
      "git status *": "allow",
      "git diff *": "allow",
      "git log *": "allow",
      "git show *": "allow",
      "git branch *": "allow",
      "git rev-parse *": "allow",
      "git ls-files *": "allow",
      "git blame *": "allow",
      "git merge-base *": "allow",
      "git describe *": "allow",
      "diff *": "allow",
      "stat *": "allow",
      "mkdir *": "allow"
    },
    "edit": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "ask"
    },
    "read": {
      "*": "allow"
    },
    "external_directory": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "/tmp/*": "allow"
    }
  }
}';
      ;;
    coder)
      profileJson='{
  "permission": {
    "bash": {
      "*": "ask",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
      "git clean *": "deny",
      "git reset *": "deny",
      "git rebase *": "deny",
      "git push --force *": "deny",
      "git push -f *": "deny",
      "mkdir *": "allow",
      "yq *": "allow",
      "jq *": "allow",
      "mktemp *": "allow",
      "echo *": "allow",
      "printf *": "allow",
      "which *": "allow",
      "command *": "allow",
      "basename *": "allow",
      "dirname *": "allow",
      "realpath *": "allow",
      "readlink *": "allow",
      "env *": "allow",
      "pwd *": "allow",
      "date *": "allow",
      "id *": "allow",
      "ps *": "allow",
      "test *": "allow",
      "ls *": "allow",
      "find *": "allow",
      "grep *": "allow",
      "rg *": "allow",
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "wc *": "allow",
      "sort *": "allow",
      "sed *": "allow",
      "awk *": "allow",
      "tr *": "allow",
      "cut *": "allow",
      "uniq *": "allow",
      "stat *": "allow",
      "tree *": "allow",
      "read *": "allow",
      "diff *": "allow",
      "git status *": "allow",
      "git diff *": "allow",
      "git log *": "allow",
      "git show *": "allow",
      "git branch *": "allow",
      "git rev-parse *": "allow",
      "git ls-files *": "allow",
      "git blame *": "allow",
      "git merge-base *": "allow",
      "git describe *": "allow",
      "touch *": "allow",
      "cp *": "allow",
      "mv *": "allow",
      "tee *": "allow",
      "xargs *": "allow",
      "ln *": "allow"
    },
    "edit": {
      "*": "allow"
    },
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny"
    },
    "external_directory": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "/tmp/*": "allow"
    }
  }
}'
      ;;
    reviewer)
      profileJson='{
  "permission": {
    "bash": {
      "*": "ask",
      "sed -i *": "deny",
      "cp *": "deny",
      "mv *": "deny",
      "touch *": "deny",
      "tee *": "deny",
      "xargs *": "deny",
      "ln *": "deny",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
      "git clean *": "deny",
      "git reset *": "deny",
      "git rebase *": "deny",
      "git push --force *": "deny",
      "git push -f *": "deny",
      "yq *": "allow",
      "jq *": "allow",
      "mktemp *": "allow",
      "echo *": "allow",
      "printf *": "allow",
      "which *": "allow",
      "command *": "allow",
      "basename *": "allow",
      "dirname *": "allow",
      "realpath *": "allow",
      "readlink *": "allow",
      "env *": "allow",
      "pwd *": "allow",
      "date *": "allow",
      "id *": "allow",
      "ps *": "allow",
      "test *": "allow",
      "ls *": "allow",
      "find *": "allow",
      "grep *": "allow",
      "rg *": "allow",
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "sort *": "allow",
      "sed *": "allow",
      "awk *": "allow",
      "tr *": "allow",
      "cut *": "allow",
      "uniq *": "allow",
      "wc *": "allow",
      "tree *": "allow",
      "read *": "allow",
      "git status *": "allow",
      "git diff *": "allow",
      "git log *": "allow",
      "git show *": "allow",
      "git branch *": "allow",
      "git rev-parse *": "allow",
      "git ls-files *": "allow",
      "git blame *": "allow",
      "git merge-base *": "allow",
      "git describe *": "allow",
      "diff *": "allow",
      "stat *": "allow",
      "mkdir *": "allow"
    },
    "edit": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "ask"
    },
    "read": {
      "*": "allow"
    },
    "external_directory": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "/tmp/*": "allow"
    }
  }
}';
      ;;
    contextualizer)
      profileJson='{
  "permission": {
    "bash": {
      "*": "ask",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
      "git clean *": "deny",
      "git reset *": "deny",
      "git rebase *": "deny",
      "git push --force *": "deny",
      "git push -f *": "deny",
      "yq *": "allow",
      "jq *": "allow",
      "mktemp *": "allow",
      "echo *": "allow",
      "printf *": "allow",
      "which *": "allow",
      "command *": "allow",
      "basename *": "allow",
      "dirname *": "allow",
      "realpath *": "allow",
      "readlink *": "allow",
      "env *": "allow",
      "pwd *": "allow",
      "date *": "allow",
      "id *": "allow",
      "ps *": "allow",
      "test *": "allow",
      "find *": "allow",
      "grep *": "allow",
      "rg *": "allow",
      "ls *": "allow",
      "cat *": "allow",
      "read *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "wc *": "allow",
      "sort *": "allow",
      "sed *": "allow",
      "awk *": "allow",
      "tr *": "allow",
      "cut *": "allow",
      "uniq *": "allow",
      "tree *": "allow",
      "stat *": "allow",
      "file *": "allow",
      "mkdir *": "allow",
      "touch *": "allow",
      "cp *": "allow",
      "mv *": "allow",
      "tee *": "allow",
      "xargs *": "allow",
      "ln *": "allow"
    },
    "edit": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "ask"
    },
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny"
    },
    "external_directory": {
      ".memory/*": "allow",
      ".memory/**": "allow",
      ".memory/plan/*": "allow",
      ".memory/todo/*": "allow",
      ".memory/reviews/*": "allow",
      ".memory/session/*": "allow",
      "/tmp/*": "allow"
    }
  }
}';
      ;;
    *)
      echo "$agentBindings"
      return
      ;;
  esac

  echo "$agentBindings" | jq --arg name "$personaName" --argjson profile "$profileJson" \
    '.[$name] = .[$name] * $profile'
}

writeAgentsToConfigFile() {
  local configPath="$1"
  local agentBindings="$2"
  local tmpFile
  tmpFile=$(mktemp)

  jq --argjson bindings "$agentBindings" \
    '.agent = (.agent // {} | . + $bindings)' "$configPath" > "$tmpFile"
  mv "$tmpFile" "$configPath"
}

disablePlanAgentBuilder() {
  local agentBindings="$1"
  echo "$agentBindings" | jq '. + {"plan": {"disable": true}}'
}

agentBindingBuilder() {
  local agentName="$1"
  local modelId="$2"
  local description="$3"
  local temperature="$4"
  local topP="$5"
  local thinkingBudget="$6"
  local agentBindings="$7"
  local reasoningEffort="$8"

  local thinkingJson=""
  if [ -n "$thinkingBudget" ]; then
    thinkingJson=$(jq -n \
      --argjson budget "$thinkingBudget" \
      --arg effort "$reasoningEffort" \
      '{"thinking":{"type":"enabled","budgetTokens":$budget},"reasoning":{"effort":$effort},"reasoningEffort":$effort}')
  fi

  local agentJson
  agentJson=$(jq -n \
    --arg model "$modelId" \
    --arg description "$description" \
    '{model: $model, description: $description}')

  if [ -n "$temperature" ]; then
    agentJson=$(echo "$agentJson" | jq --argjson temp "$temperature" '. + {temperature: $temp}')
  fi

  if [ -n "$topP" ]; then
    agentJson=$(echo "$agentJson" | jq --argjson topP "$topP" '. + {top_p: $topP}')
  fi

  if [ -n "$thinkingJson" ]; then
    agentJson=$(echo "$agentJson" | jq --argjson thinking "$thinkingJson" '. + $thinking')
  fi

  jq -n --arg name "$agentName" --argjson agent "$agentJson" --argjson bindings "$agentBindings" \
    '$bindings | .[$name] = $agent'
}

personaAgentJsonBuilder() {
  local personasDir="$1"
  local personaPath agentName modelId humor temperature topP thinkingBudget agentBindings shortDescription
  agentBindings="{}"

  for personaPath in "$personasDir"/*.md; do
    agentName=$(extractPersonaName "$personaPath")
    if [ "$(shouldSkipPersona "$agentName")" = "true" ]; then
      continue
    fi

    agentName=$(resolveAgentName "$agentName")

    modelId=$(resolvePersonaModelId "$personaPath")

    if [ -z "$modelId" ]; then
      continue
    fi

    humor=$(readPersonaHumor "$personaPath")
    shortDescription=$(readPersonaShortDescription "$personaPath")
    temperature=$(resolveHumorAttributes "$humor" "temperature")
    topP=$(resolveHumorAttributes "$humor" "topP")
    thinkingBudget=$(resolveHumorAttributes "$humor" "thinkingBudget")
    reasoningEffort=$(resolveHumorAttributes "$humor" "reasoningEffort")

    agentBindings=$(agentBindingBuilder "$agentName" "$modelId" "$shortDescription" "$temperature" "$topP" "$thinkingBudget" "$agentBindings" "$reasoningEffort")

    agentBindings=$(applyPermissionProfile "$agentName" "$agentBindings")
  done

  echo "$agentBindings"
}

addGeneralAgent() {
  local agentBindings="$1"
  local coderConfig
  coderConfig=$(echo "$agentBindings" | jq '.coder // empty')
  if [ -z "$coderConfig" ]; then
    echo "$agentBindings"
    return
  fi
  echo "$agentBindings" | jq '. + {"general": .coder}'
}

ensureHiddenDirectoriesAreSearchable() {
  local ignorePath=".ignore"
  if [ ! -f "$ignorePath" ]; then
    cat <<'EOF' > "$ignorePath"
!.agents/
!.memory/
EOF
    return
  fi
  if ! grep -q '^!\.agents/$' "$ignorePath"; then
    echo '!.agents/' >> "$ignorePath"
  fi
  if ! grep -q '^!\.memory/$' "$ignorePath"; then
    echo '!.memory/' >> "$ignorePath"
  fi
}

isInsideSupportedCli=$(isRunningInsideSupportedCli)
if [ "$isInsideSupportedCli" != "true" ]; then
  exit 0
fi

configLine=$(resolveSupportedCliConfigPath)
if [ -z "$configLine" ]; then
  exit 0
fi

ensureHiddenDirectoriesAreSearchable || true

configPath="${configLine%% *}"
configStatus="${configLine##* }"

checkRequiredDependencies yq jq

hostModelId="${1:-}"

personasDir=".agents/personas"
if [ ! -d "$personasDir" ]; then
  echo "PersonasDirectoryNotFound" >&2
  exit 0
fi

agentBindings=$(personaAgentJsonBuilder "$personasDir")
agentBindings=$(addGeneralAgent "$agentBindings")
agentBindings=$(disablePlanAgentBuilder "$agentBindings")
writeAgentsToConfigFile "$configPath" "$agentBindings"

agentCount=$(echo "$agentBindings" | jq 'keys | length')
echo "${configPath}: configured ${agentCount} persona agent bindings"
echo "configStatus=${configStatus}"
