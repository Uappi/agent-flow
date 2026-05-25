#!/usr/bin/env bash
#
# @description  Resolves caveman skill for the current host runtime only.
#               Never treats another IDE's install path as available.
# @usage        maestro-boot-caveman-resolve.sh
# @output       caveman: active host=<id> path=<file> | caveman: skip host=<id> ...
# @requires     bash v4+
# @version      0.1.0
# @updated      2026-05-22
set -euo pipefail

detectHostId() {
  local currentPid processName

  currentPid="${PPID:-}"
  while [[ -n "$currentPid" && "$currentPid" -gt 1 ]]; do
    processName=$(ps -o comm= -p "$currentPid" 2>/dev/null || true)
    processName="${processName#.}"

    case "$processName" in
      opencode) echo "opencode"; return 0 ;;
      cursor-agent | cursor) echo "cursor"; return 0 ;;
      claude) echo "claude"; return 0 ;;
      codex) echo "codex"; return 0 ;;
      gemini) echo "gemini"; return 0 ;;
    esac

    currentPid=$(ps -o ppid= -p "$currentPid" 2>/dev/null | tr -d ' ' || true)
  done

  echo "unknown"
}

firstExistingFile() {
  local candidate
  for candidate in "$@"; do
    if [[ -f "$candidate" ]]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

main() {
  local hostId resolvedPath

  hostId="$(detectHostId)"

  resolvedPath=$(firstExistingFile \
    ".agents/skills/caveman/SKILL.md" \
    ".agents/skills/caveman.md" \
    || true)

  if [[ -n "$resolvedPath" ]]; then
    echo "caveman: active host=${hostId} path=${resolvedPath} scope=project"
    return 0
  fi

  case "$hostId" in
    cursor)
      resolvedPath=$(firstExistingFile "${HOME}/.cursor/skills/caveman/SKILL.md" || true)
      ;;
    claude)
      resolvedPath=$(firstExistingFile "${HOME}/.claude/skills/caveman/SKILL.md" || true)
      ;;
    codex)
      resolvedPath=$(firstExistingFile "${HOME}/.codex/skills/caveman/SKILL.md" || true)
      ;;
    opencode)
      resolvedPath=$(firstExistingFile \
        "${HOME}/.config/opencode/skills/caveman/SKILL.md" \
        ".opencode/skills/caveman/SKILL.md" \
        || true)
      ;;
    *)
      resolvedPath=""
      ;;
  esac

  if [[ -n "$resolvedPath" ]]; then
    echo "caveman: active host=${hostId} path=${resolvedPath} scope=host"
    return 0
  fi

  echo "caveman: skip host=${hostId} reason=not_installed_for_host"
}

main "$@"
