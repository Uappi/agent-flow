#!/usr/bin/env bash
#
# @description  Detects CLI config files and writes persona agent bindings.
#               Each persona gets a named agent with its model read
#               directly from frontmatter. Thinking budget is set
#               per-agent based on persona humor style.
#
# Multi-CLI agent configuration. Currently OpenCode only — add new CLIs
# by adding a resolve<Name>ConfigPath function and updating detectCliConfigPath.
#
# @usage        maestro-boot-configure-cli.sh
# @output       Summary line with agent count, or nothing if no CLI config found.
# @requires     bash v4+, yq v4+, jq v1.6+, ps
# @version      0.3.0
# @updated      2026-04-24
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

detectCliConfigPath() {
  local configPath
  configPath=$(resolveSupportedCliConfigPath)
  if [ -n "$configPath" ]; then
    echo "$configPath"
    return 0
  fi
  echo ""
  return 0
}

readPersonaFrontmatter() {
  local personaPath="$1"
  sed -n '/^---$/,/^---$/{ //d; p }' "$personaPath"
}

readPersonaModelId() {
  local personaPath="$1"
  readPersonaFrontmatter "$personaPath" | yq '.modelId // ""'
}

readPersonaShortDescription() {
  local personaPath="$1"
  readPersonaFrontmatter "$personaPath" | yq '.shortDescription // ""'
}

readPersonaHumor() {
  local personaPath="$1"
  readPersonaFrontmatter "$personaPath" | yq '.humor // "default"'
}

resolveHumorTemperature() {
  local humor="$1"
  case "$humor" in
    introvert)    echo "0.2" ;;
    pragmatic)    echo "0.25" ;;
    sympathetic)  echo "0.3" ;;
    extrovert)    echo "0.35" ;;
    *)            echo "" ;;
  esac
}

resolveHumorTopP() {
  local humor="$1"
  case "$humor" in
    introvert)    echo "0.85" ;;
    pragmatic)    echo "0.85" ;;
    sympathetic)  echo "0.85" ;;
    extrovert)    echo "0.85" ;;
    *)            echo "" ;;
  esac
}

resolveHumorThinkingBudget() {
  local humor="$1"
  case "$humor" in
    introvert)    echo "10240" ;;
    pragmatic)    echo "12288" ;;
    sympathetic)  echo "14336" ;;
    extrovert)    echo "16384" ;;
    *)            echo "" ;;
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
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "wc *": "allow",
      "sort *": "allow",
      "stat *": "allow",
      "diff *": "allow",
      "tree *": "allow",
      "read *": "allow",
      "git *": "allow",
      "mkdir *": "allow"
    },
    "edit": {
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
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
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
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "sort *": "allow",
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
      "stat *": "allow"
    },
    "edit": {
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "deny"
    },
    "read": {
      "*": "allow"
    },
    "external_directory": {
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
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "wc *": "allow",
      "sort *": "allow",
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
      "git describe *": "allow"
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
      "/tmp/*": "allow"
    }
  }
}'
      ;;
    reviewer)
      profileJson='{
  "permission": {
    "bash": {
      "*": "deny",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
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
      "cat *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "sort *": "allow",
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
      "stat *": "allow"
    },
    "edit": {
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "deny"
    },
    "read": {
      "*": "allow"
    },
    "external_directory": {
      "/tmp/*": "allow"
    }
  }
}';
      ;;
    contextualizer)
      profileJson='{
  "permission": {
    "bash": {
      "*": "deny",
      "rm *": "deny",
      "mkfs *": "deny",
      "dd *": "deny",
      "chmod *": "deny",
      "chown *": "deny",
      "curl *": "deny",
      "wget *": "deny",
      "sudo *": "deny",
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
      "ls *": "allow",
      "cat *": "allow",
      "read *": "allow",
      "head *": "allow",
      "tail *": "allow",
      "wc *": "allow",
      "sort *": "allow",
      "tree *": "allow",
      "stat *": "allow",
      "file *": "allow",
      "mkdir *": "allow"
    },
    "edit": {
      "*.md": "allow",
      "/tmp/*": "allow",
      "*": "deny"
    },
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny"
    },
    "external_directory": {
      "/tmp/*": "allow"
    }
  }
}'
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
    '.agent = (.agent // {} | . * $bindings)' "$configPath" > "$tmpFile"
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

  if [ -n "$temperature" ] && [ -n "$topP" ] && [ -n "$thinkingBudget" ]; then
    jq \
      --arg name "$agentName" \
      --arg model "$modelId" \
      --arg description "$description" \
      --argjson temperature "$temperature" \
      --argjson topP "$topP" \
      --argjson thinkingBudget "$thinkingBudget" \
      '.[$name] = {"model": $model, "description": $description, "temperature": $temperature, "brainstorm": {"top_p": $topP}, "thinking": {"type": "enabled", "budgetTokens": $thinkingBudget}}' \
      <<< "$agentBindings"
    return
  fi

  if [ -n "$temperature" ] && [ -n "$topP" ]; then
    jq \
      --arg name "$agentName" \
      --arg model "$modelId" \
      --arg description "$description" \
      --argjson temperature "$temperature" \
      --argjson topP "$topP" \
      '.[$name] = {"model": $model, "description": $description, "temperature": $temperature, "brainstorm": {"top_p": $topP}}' \
      <<< "$agentBindings"
    return
  fi

  jq \
    --arg name "$agentName" \
    --arg model "$modelId" \
    --arg description "$description" \
    '.[$name] = {"model": $model, "description": $description}' \
    <<< "$agentBindings"
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

    modelId=$(readPersonaModelId "$personaPath")

    if [ -z "$modelId" ]; then
      continue
    fi

    humor=$(readPersonaHumor "$personaPath")
    shortDescription=$(readPersonaShortDescription "$personaPath")
    temperature=$(resolveHumorTemperature "$humor")
    topP=$(resolveHumorTopP "$humor")
    thinkingBudget=$(resolveHumorThinkingBudget "$humor")

    agentBindings=$(agentBindingBuilder "$agentName" "$modelId" "$shortDescription" "$temperature" "$topP" "$thinkingBudget" "$agentBindings")

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

configLine=$(detectCliConfigPath)
if [ -z "$configLine" ]; then
  exit 0
fi

configPath="${configLine%% *}"
configStatus="${configLine##* }"

isInsideSupportedCli=$(isRunningInsideSupportedCli)
if [ "$isInsideSupportedCli" != "true" ]; then
  exit 0
fi

checkRequiredDependencies yq jq

personasDir="personas"
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
