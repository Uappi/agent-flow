#!/usr/bin/env bash
#
# @description  Table-driven tests for maestro-boot-configure-cli.sh.
# @usage        maestro-boot-configure-cli_test.sh
# @output       PASS/FAIL per test case, summary at end.
# @requires     bash v4+, yq v4+, jq v1.6+
# @version      0.1.5
# @updated      2026-06-24
set -euo pipefail

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
configureScript="$scriptDir/maestro-boot-configure-cli.sh"

passCount=0
failCount=0

fixtureDir=$(mktemp -d)
trap 'rm -rf "$fixtureDir"' EXIT

assertConfigure() {
  local label="$1"
  local setupFixture="$2"
  local expectedOutput="$3"
  local expectedExit="$4"

  local testDir actualOutput actualExit
  testDir=$(mktemp -d -p "$fixtureDir")

  $setupFixture "$testDir"

  actualExit=0
  actualOutput=$(cd "$testDir" && bash "$configureScript" 2>&1) || actualExit=$?

  if [[ "$actualExit" != "$expectedExit" ]]; then
    cat <<EOF
FAIL $label
  expected exit=$expectedExit, got exit=$actualExit
  output: $actualOutput
EOF
    failCount=$((failCount + 1))
    return
  fi

  if [[ "$actualOutput" != "$expectedOutput" ]]; then
    cat <<EOF
FAIL $label
  expected:
$expectedOutput
  actual:
$actualOutput
EOF
    failCount=$((failCount + 1))
    return
  fi

  echo "PASS $label"
  passCount=$((passCount + 1))
}

setupNoCliConfig() {
  local testDir="$1"
  mkdir -p "$testDir/.agents/personas"
  cat > "$testDir/.agents/personas/coder.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: Software development.
---
You are a coder.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF
}

setupSkipsReadme() {
  local testDir="$1"
  mkdir -p "$testDir/.agents/personas"
  cat > "$testDir/.agents/personas/coder.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: Software development.
---
You are a coder.
EOF
  cat > "$testDir/.agents/personas/README.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
---
Documentation.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF
}

setupMergesWithExistingAgents() {
  local testDir="$1"
  mkdir -p "$testDir/.agents/personas"
  cat > "$testDir/.agents/personas/coder.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: Software development.
---
You are a coder.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{
  "agent": {
    "existing-agent": {
      "model": "some-provider/some-model"
    }
  }
}
EOF
}

setupReviewerPersona() {
  local testDir="$1"
  mkdir -p "$testDir/.agents/personas"
  cat > "$testDir/.agents/personas/coder.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: Software development.
---
You are a coder.
EOF
  cat > "$testDir/.agents/personas/reviewer.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: Reviews code.
---
You are a reviewer.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF
}

runStandardCases() {
  assertConfigure \
    "configures agents when config exists" \
    setupNoCliConfig \
    "opencode.json: configured 3 persona agent bindings
configStatus=existed" \
    "0"

  assertConfigure \
    "skips README persona" \
    setupSkipsReadme \
    "opencode.json: configured 3 persona agent bindings
configStatus=existed" \
    "0"

  assertConfigure \
    "merges with existing agents" \
    setupMergesWithExistingAgents \
    "opencode.json: configured 3 persona agent bindings
configStatus=existed" \
    "0"
}

runGeneralAgentVerificationCases() {
  local testDir coderModel generalModel
  testDir=$(mktemp -d -p "$fixtureDir")
  setupMergesWithExistingAgents "$testDir"

  cd "$testDir" && bash "$configureScript" 2>&1 || true

  coderModel=$(jq -r '.agent.coder.model' "$testDir/opencode.json")
  generalModel=$(jq -r '.agent.general.model' "$testDir/opencode.json")

  if [[ "$generalModel" != "$coderModel" ]]; then
    cat <<EOF
FAIL general agent mirrors coder model
  expected general model to match coder ($coderModel), got: $generalModel
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS general agent mirrors coder model"
  passCount=$((passCount + 1))
}

runThinkingBudgetVerificationCases() {
  local testDir introvertBudget pragmaticBudget sympatheticBudget extrovertBudget roboticType defaultBudget
  testDir=$(mktemp -d -p "$fixtureDir")
  mkdir -p "$testDir/.agents/personas"
  cat > "$testDir/.agents/personas/introvert.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
humor: introvert
---
Quiet persona.
EOF
  cat > "$testDir/.agents/personas/pragmatic.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
humor: pragmatic
---
Direct persona.
EOF
  cat > "$testDir/.agents/personas/sympathetic.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
humor: sympathetic
---
Warm persona.
EOF
  cat > "$testDir/.agents/personas/extrovert.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
humor: extrovert
---
Outgoing persona.
EOF
  cat > "$testDir/.agents/personas/robotic.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
humor: robotic
---
Mechanical persona.
EOF
  cat > "$testDir/.agents/personas/default.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
---
No humor field.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF

  cd "$testDir" && bash "$configureScript" 2>&1 || true

  introvertBudget=$(jq -r '.agent.introvert.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  introvertEffort=$(jq -r '.agent.introvert.reasoning.effort // "missing"' "$testDir/opencode.json")
  introvertReasoningEffort=$(jq -r '.agent.introvert.reasoningEffort // "missing"' "$testDir/opencode.json")
  if [[ "$introvertBudget" != "8192" || "$introvertEffort" != "low" || "$introvertReasoningEffort" != "low" ]]; then
    cat <<EOF
FAIL introvert thinking budget=8192 effort=low reasoningEffort=low
  expected budget=8192 effort=low reasoningEffort=low, got: budget=$introvertBudget effort=$introvertEffort reasoningEffort=$introvertReasoningEffort
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS introvert thinking budget=8192 effort=low reasoningEffort=low"
  passCount=$((passCount + 1))

  pragmaticBudget=$(jq -r '.agent.pragmatic.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  pragmaticEffort=$(jq -r '.agent.pragmatic.reasoning.effort // "missing"' "$testDir/opencode.json")
  pragmaticReasoningEffort=$(jq -r '.agent.pragmatic.reasoningEffort // "missing"' "$testDir/opencode.json")
  if [[ "$pragmaticBudget" != "12288" || "$pragmaticEffort" != "medium" || "$pragmaticReasoningEffort" != "medium" ]]; then
    cat <<EOF
FAIL pragmatic thinking budget=12288 effort=medium reasoningEffort=medium
  expected budget=12288 effort=medium reasoningEffort=medium, got: budget=$pragmaticBudget effort=$pragmaticEffort reasoningEffort=$pragmaticReasoningEffort
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS pragmatic thinking budget=12288 effort=medium reasoningEffort=medium"
  passCount=$((passCount + 1))

  sympatheticBudget=$(jq -r '.agent.sympathetic.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  sympatheticEffort=$(jq -r '.agent.sympathetic.reasoning.effort // "missing"' "$testDir/opencode.json")
  sympatheticReasoningEffort=$(jq -r '.agent.sympathetic.reasoningEffort // "missing"' "$testDir/opencode.json")
  if [[ "$sympatheticBudget" != "14336" || "$sympatheticEffort" != "high" || "$sympatheticReasoningEffort" != "high" ]]; then
    cat <<EOF
FAIL sympathetic thinking budget=14336 effort=high reasoningEffort=high
  expected budget=14336 effort=high reasoningEffort=high, got: budget=$sympatheticBudget effort=$sympatheticEffort reasoningEffort=$sympatheticReasoningEffort
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS sympathetic thinking budget=14336 effort=high reasoningEffort=high"
  passCount=$((passCount + 1))

  extrovertBudget=$(jq -r '.agent.extrovert.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  extrovertEffort=$(jq -r '.agent.extrovert.reasoning.effort // "missing"' "$testDir/opencode.json")
  extrovertReasoningEffort=$(jq -r '.agent.extrovert.reasoningEffort // "missing"' "$testDir/opencode.json")
  if [[ "$extrovertBudget" != "16384" || "$extrovertEffort" != "xhigh" || "$extrovertReasoningEffort" != "xhigh" ]]; then
    cat <<EOF
FAIL extrovert thinking budget=16384 effort=xhigh reasoningEffort=xhigh
  expected budget=16384 effort=xhigh reasoningEffort=xhigh, got: budget=$extrovertBudget effort=$extrovertEffort reasoningEffort=$extrovertReasoningEffort
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS extrovert thinking budget=16384 effort=xhigh reasoningEffort=xhigh"
  passCount=$((passCount + 1))

  roboticType=$(jq -r '.agent.robotic.thinking.type // "missing"' "$testDir/opencode.json")
  roboticBudget=$(jq '.agent.robotic.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  roboticEffort=$(jq -r '.agent.robotic.reasoning.effort // "missing"' "$testDir/opencode.json")
  roboticReasoningEffort=$(jq -r '.agent.robotic.reasoningEffort // "missing"' "$testDir/opencode.json")
  if [[ "$roboticType" != "enabled" || "$roboticBudget" != "4096" || "$roboticEffort" != "low" || "$roboticReasoningEffort" != "low" ]]; then
    cat <<EOF
 FAIL robotic thinking type=enabled budgetTokens=4096 effort=low reasoningEffort=low
   expected type=enabled budgetTokens=4096 effort=low reasoningEffort=low, got: type=$roboticType budget=$roboticBudget effort=$roboticEffort reasoningEffort=$roboticReasoningEffort
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS robotic thinking type=enabled budgetTokens=4096 effort=low reasoningEffort=low"
  passCount=$((passCount + 1))

  defaultBudget=$(jq -r '.agent.default.thinking.budgetTokens // "absent"' "$testDir/opencode.json")
  defaultReasoning=$(jq -r '.agent.default.reasoning.effort // "absent"' "$testDir/opencode.json")
  defaultReasoningEffort=$(jq -r '.agent.default.reasoningEffort // "absent"' "$testDir/opencode.json")
  if [[ "$defaultBudget" != "absent" || "$defaultReasoning" != "absent" || "$defaultReasoningEffort" != "absent" ]]; then
    cat <<EOF
FAIL default persona has no thinking/reasoning/reasoningEffort fields
  expected all absent, got: budget=$defaultBudget effort=$defaultReasoning reasoningEffort=$defaultReasoningEffort
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS default persona has no thinking/reasoning/reasoningEffort fields"
  passCount=$((passCount + 1))
}

runPermissionVerificationCases() {
  local testDir coderEditAll reviewerEditDeny coderBashAsk reviewerBashDeny

  testDir=$(mktemp -d -p "$fixtureDir")
  setupReviewerPersona "$testDir"

  cd "$testDir" && bash "$configureScript" 2>&1 || true

  coderEditAll=$(jq -r '.agent.coder.permission.edit["*"] // "missing"' "$testDir/opencode.json")
  if [[ "$coderEditAll" != "allow" ]]; then
    cat <<EOF
FAIL coder agent has permission.edit.* = allow
  expected allow, got: $coderEditAll
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS coder agent has permission.edit.* = allow"
  passCount=$((passCount + 1))

  reviewerEditDeny=$(jq -r '.agent.reviewer.permission.edit["*"] // "missing"' "$testDir/opencode.json")
  if [[ "$reviewerEditDeny" != "ask" ]]; then
    cat <<EOF
FAIL reviewer agent has permission.edit.* = ask
  expected ask, got: $reviewerEditDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS reviewer agent has permission.edit.* = ask"
  passCount=$((passCount + 1))

  coderBashAsk=$(jq -r '.agent.coder.permission.bash["*"] // "missing"' "$testDir/opencode.json")
  if [[ "$coderBashAsk" != "ask" ]]; then
    cat <<EOF
FAIL coder agent has permission.bash.* = ask
  expected ask, got: $coderBashAsk
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS coder agent has permission.bash.* = ask"
  passCount=$((passCount + 1))

  reviewerBashDeny=$(jq -r '.agent.reviewer.permission.bash["*"] // "missing"' "$testDir/opencode.json")
  if [[ "$reviewerBashDeny" != "ask" ]]; then
    cat <<EOF
FAIL reviewer agent has permission.bash.* = ask
  expected ask, got: $reviewerBashDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS reviewer agent has permission.bash.* = ask"
  passCount=$((passCount + 1))

  coderGitCleanDeny=$(jq -r '.agent.coder.permission.bash["git clean *"] // "missing"' "$testDir/opencode.json")
  if [[ "$coderGitCleanDeny" != "deny" ]]; then
    cat <<EOF
FAIL coder agent has permission.bash git clean * = deny
  expected deny, got: $coderGitCleanDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS coder agent has permission.bash git clean * = deny"
  passCount=$((passCount + 1))

  reviewerGitCleanDeny=$(jq -r '.agent.reviewer.permission.bash["git clean *"] // "missing"' "$testDir/opencode.json")
  if [[ "$reviewerGitCleanDeny" != "deny" ]]; then
    cat <<EOF
FAIL reviewer agent has permission.bash git clean * = deny
  expected deny, got: $reviewerGitCleanDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS reviewer agent has permission.bash git clean * = deny"
  passCount=$((passCount + 1))

  coderGitResetDeny=$(jq -r '.agent.coder.permission.bash["git reset *"] // "missing"' "$testDir/opencode.json")
  if [[ "$coderGitResetDeny" != "deny" ]]; then
    cat <<EOF
FAIL coder agent has permission.bash git reset * = deny
  expected deny, got: $coderGitResetDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS coder agent has permission.bash git reset * = deny"
  passCount=$((passCount + 1))

  coderGitRebaseDeny=$(jq -r '.agent.coder.permission.bash["git rebase *"] // "missing"' "$testDir/opencode.json")
  if [[ "$coderGitRebaseDeny" != "deny" ]]; then
    cat <<EOF
FAIL coder agent has permission.bash git rebase * = deny
  expected deny, got: $coderGitRebaseDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS coder agent has permission.bash git rebase * = deny"
  passCount=$((passCount + 1))
}

runExternalDirVerificationCases() {
  local testDir personaName externalDirValue
  testDir=$(mktemp -d -p "$fixtureDir")
  mkdir -p "$testDir/.agents/personas"

  for personaName in build architect coder reviewer contextualizer; do
    cat > "$testDir/.agents/personas/${personaName}.md" <<EOF
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: ${personaName} persona.
---
${personaName} body.
EOF
  done

  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF

  cd "$testDir" && bash "$configureScript" 2>&1 || true

  for personaName in build architect coder reviewer contextualizer; do
    externalDirValue=$(jq -r ".agent.${personaName}.permission.external_directory[\"/tmp/*\"] // \"missing\"" "$testDir/opencode.json")
    if [[ "$externalDirValue" != "allow" ]]; then
      cat <<EOF
FAIL ${personaName} has permission.external_directory /tmp/* = allow
  expected allow, got: $externalDirValue
EOF
      failCount=$((failCount + 1))
      return
    fi
    echo "PASS ${personaName} has permission.external_directory /tmp/* = allow"
    passCount=$((passCount + 1))
  done
}

runPlanDisableVerificationCases() {
  local testDir planDisabled

  testDir=$(mktemp -d -p "$fixtureDir")
  setupReviewerPersona "$testDir"

  cd "$testDir" && bash "$configureScript" 2>&1 || true

  planDisabled=$(jq '.agent.plan.disable' "$testDir/opencode.json")
  if [[ "$planDisabled" != "true" ]]; then
    cat <<EOF
FAIL plan agent disabled in merged config
  expected agent.plan.disable=true, got: $planDisabled
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS plan agent disabled in merged config"
  passCount=$((passCount + 1))
}

runDependencyCheckVerificationCases() {
  local missingOutput missingExitCode checkScript bashPath

  checkScript=$(mktemp)
  cat > "$checkScript" <<'SCRIPT'
#!/usr/bin/env bash
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

checkRequiredDependencies "$@"
SCRIPT
  chmod +x "$checkScript"

  bashPath=$(command -v bash)

  missingExitCode=0
  missingOutput=$(PATH="/nonexistent" "$bashPath" "$checkScript" fakeToolOne fakeToolTwo 2>&1) || missingExitCode=$?

  if [[ "$missingExitCode" != "0" ]]; then
    cat <<EOF
FAIL dependency check exits 0 for missing tools
  expected exit=0, got exit=$missingExitCode
EOF
    failCount=$((failCount + 1))
    return
  fi

  if ! echo "$missingOutput" | grep -q "Skipping:"; then
    cat <<EOF
FAIL dependency check reports missing tools message
  expected "Skipping:" in output, got: $missingOutput
EOF
    failCount=$((failCount + 1))
    return
  fi

  if ! echo "$missingOutput" | grep -q "fakeToolOne, fakeToolTwo"; then
    cat <<EOF
FAIL dependency check lists missing tools
  expected tool list in output, got: $missingOutput
EOF
    failCount=$((failCount + 1))
    return
  fi

  echo "PASS dependency check exits 0 with skip message and tool list"
  passCount=$((passCount + 1))
}

runHostProviderResolutionCases() {
  local testDir resolvedModel

  testDir=$(mktemp -d -p "$fixtureDir")
  mkdir -p "$testDir/.agents/personas"

  cat > "$testDir/.agents/personas/coder.md" <<'EOF'
---
preferredModel: host
modelTier: tier-2
shortDescription: Software development.
---
You are a coder.
EOF

  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF

  # resolveHostProviderName queries dispatch.md for the provider whose cli == "opencode".
  # The env override bypasses that lookup and forces the provider name directly.
  # Setting it to "deepseek" exercises the resolution path because dispatch.md maps
  # deepseek -> cli: opencode, tier-2 -> opencode-go/deepseek-v4-flash.
  cd "$testDir" && isRunningInsideSupportedCliEnvOverride=true resolveHostProviderNameEnvOverride=deepseek bash "$configureScript" 2>&1 || true

  resolvedModel=$(jq -r '.agent.coder.model' "$testDir/opencode.json")

  if [[ "$resolvedModel" != *"deepseek"* ]]; then
    cat <<EOF
FAIL host provider resolves to deepseek tier-2 model
  expected model to contain 'deepseek', got: $resolvedModel
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS host provider resolves to deepseek tier-2 model"
  passCount=$((passCount + 1))
}

runUnsupportedProviderSkippedCases() {
  local testDir unknownAgentEntry

  testDir=$(mktemp -d -p "$fixtureDir")
  mkdir -p "$testDir/.agents/personas"

  cat > "$testDir/.agents/personas/unknown.md" <<'EOF'
---
preferredModel: unknown-provider
modelTier: tier-2
shortDescription: Unknown provider persona.
---
Unknown provider body.
EOF

  cat > "$testDir/.agents/personas/coder.md" <<'EOF'
---
preferredModel: deepseek
modelTier: tier-2
shortDescription: Software development.
---
You are a coder.
EOF

  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF

  cd "$testDir" && isRunningInsideSupportedCliEnvOverride=true bash "$configureScript" 2>&1 || true

  unknownAgentEntry=$(jq -r '.agent.unknown // empty' "$testDir/opencode.json")

  if [[ -n "$unknownAgentEntry" ]]; then
    cat <<EOF
FAIL unsupported preferredModel is skipped
  expected no agent binding for unknown, got: $unknownAgentEntry
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS unsupported preferredModel is skipped"
  passCount=$((passCount + 1))
}

printResults() {
  echo ""
  echo "Results: $passCount passed, $failCount failed"
  [[ $failCount -eq 0 ]]
}

runStandardCases
runGeneralAgentVerificationCases
runThinkingBudgetVerificationCases
runPermissionVerificationCases
runExternalDirVerificationCases
runPlanDisableVerificationCases
runDependencyCheckVerificationCases
runHostProviderResolutionCases
runUnsupportedProviderSkippedCases
printResults
