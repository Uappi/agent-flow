#!/usr/bin/env bash
#
# @description  Table-driven tests for maestro-boot-configure-cli.sh.
# @usage        maestro-boot-configure-cli_test.sh
# @output       PASS/FAIL per test case, summary at end.
# @requires     bash v4+, yq v4+, jq v1.6+
# @version      0.0.21
# @updated      2026-04-24
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
  mkdir -p "$testDir/personas"
  cat > "$testDir/personas/coder.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
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
  mkdir -p "$testDir/personas"
  cat > "$testDir/personas/coder.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
shortDescription: Software development.
---
You are a coder.
EOF
  cat > "$testDir/personas/README.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
---
Documentation.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF
}

setupMergesWithExistingAgents() {
  local testDir="$1"
  mkdir -p "$testDir/personas"
  cat > "$testDir/personas/coder.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
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
  mkdir -p "$testDir/personas"
  cat > "$testDir/personas/coder.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
shortDescription: Software development.
---
You are a coder.
EOF
  cat > "$testDir/personas/reviewer.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
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
  local testDir introvertBudget pragmaticBudget sympatheticBudget extrovertBudget defaultBudget
  testDir=$(mktemp -d -p "$fixtureDir")
  mkdir -p "$testDir/personas"
  cat > "$testDir/personas/introvert.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
humor: introvert
---
Quiet persona.
EOF
  cat > "$testDir/personas/pragmatic.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
humor: pragmatic
---
Direct persona.
EOF
  cat > "$testDir/personas/sympathetic.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
humor: sympathetic
---
Warm persona.
EOF
  cat > "$testDir/personas/extrovert.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
humor: extrovert
---
Outgoing persona.
EOF
  cat > "$testDir/personas/default.md" <<'EOF'
---
modelId: bailian-coding-plan/qwen3-coder-next
---
No humor field.
EOF
  cat > "$testDir/opencode.json" <<'EOF'
{}
EOF

  cd "$testDir" && bash "$configureScript" 2>&1 || true

  introvertBudget=$(jq -r '.agent.introvert.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  if [[ "$introvertBudget" != "10240" ]]; then
    cat <<EOF
FAIL introvert thinking budget is 10240
  expected 10240, got: $introvertBudget
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS introvert thinking budget is 10240"
  passCount=$((passCount + 1))

  pragmaticBudget=$(jq -r '.agent.pragmatic.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  if [[ "$pragmaticBudget" != "12288" ]]; then
    cat <<EOF
FAIL pragmatic thinking budget is 12288
  expected 12288, got: $pragmaticBudget
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS pragmatic thinking budget is 12288"
  passCount=$((passCount + 1))

  sympatheticBudget=$(jq -r '.agent.sympathetic.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  if [[ "$sympatheticBudget" != "14336" ]]; then
    cat <<EOF
FAIL sympathetic thinking budget is 14336
  expected 14336, got: $sympatheticBudget
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS sympathetic thinking budget is 14336"
  passCount=$((passCount + 1))

  extrovertBudget=$(jq -r '.agent.extrovert.thinking.budgetTokens // "missing"' "$testDir/opencode.json")
  if [[ "$extrovertBudget" != "16384" ]]; then
    cat <<EOF
FAIL extrovert thinking budget is 16384
  expected 16384, got: $extrovertBudget
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS extrovert thinking budget is 16384"
  passCount=$((passCount + 1))

  defaultBudget=$(jq -r '.agent.default.thinking.budgetTokens // "absent"' "$testDir/opencode.json")
  if [[ "$defaultBudget" != "absent" ]]; then
    cat <<EOF
FAIL default persona has no thinking budget
  expected thinking field to be absent, got: $defaultBudget
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS default persona has no thinking budget"
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
  if [[ "$reviewerEditDeny" != "deny" ]]; then
    cat <<EOF
FAIL reviewer agent has permission.edit.* = deny
  expected deny, got: $reviewerEditDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS reviewer agent has permission.edit.* = deny"
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
  if [[ "$reviewerBashDeny" != "deny" ]]; then
    cat <<EOF
FAIL reviewer agent has permission.bash.* = deny
  expected deny, got: $reviewerBashDeny
EOF
    failCount=$((failCount + 1))
    return
  fi
  echo "PASS reviewer agent has permission.bash.* = deny"
  passCount=$((passCount + 1))
}

runExternalDirVerificationCases() {
  local testDir personaName externalDirValue
  testDir=$(mktemp -d -p "$fixtureDir")
  mkdir -p "$testDir/personas"

  for personaName in build architect coder reviewer contextualizer; do
    cat > "$testDir/personas/${personaName}.md" <<EOF
---
modelId: bailian-coding-plan/qwen3-coder-next
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
printResults
