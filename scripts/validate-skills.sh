#!/bin/sh
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

fail=0

error() {
  printf 'FAIL: %s\n' "$1" >&2
  fail=1
}

require_file() {
  [ -f "$1" ] || error "missing required file: $1"
}

for dir in skills/*; do
  [ -d "$dir" ] || continue
  skill=${dir##*/}
  skill_file="$dir/SKILL.md"
  yaml_file="$dir/agents/openai.yaml"

  require_file "$skill_file"
  require_file "$yaml_file"

  if [ -f "$skill_file" ]; then
    name=$(awk '/^name: / { print $2; exit }' "$skill_file")
    [ "$name" = "$skill" ] || error "$skill_file frontmatter name '$name' does not match '$skill'"

    refs=$(grep -Eo 'references/[A-Za-z0-9._/-]+' "$skill_file" | sort -u || true)
    for ref in $refs; do
      [ -e "$dir/$ref" ] || error "$skill_file references missing path: $ref"
    done
  fi
done

tracked_noise=$(git ls-files | grep -E '(^|/)\.DS_Store$|^\.codesight/|^\.codegraph/' || true)
if [ -n "$tracked_noise" ]; then
  printf '%s\n' "$tracked_noise" >&2
  error "generated or noisy files are tracked"
fi

if grep -Eq 'unless the user explicitly requests local publishing|Do not use the local publish command unless|local SDK publishing work' skills/sdk-release-consumer-bump/SKILL.md; then
  error "SDK skill still contains local-publishing exception wording"
fi

for yaml in skills/*/agents/openai.yaml; do
  skill=${yaml#skills/}
  skill=${skill%%/*}
  actual=$(awk '/allow_implicit_invocation:/ { print $2; exit }' "$yaml")
  expected=false
  case "$skill" in
    booking-workflow-architecture|pagoda-framework|realtime-voice-agent-design|sdk-release-consumer-bump)
      expected=true
      ;;
  esac
  [ "$actual" = "$expected" ] || error "$yaml has allow_implicit_invocation: $actual; expected $expected"
done

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf 'Skill validation passed.\n'
