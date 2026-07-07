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

MAX_SKILL_LINES=320
MIN_DESCRIPTION_CHARS=120
MAX_DESCRIPTION_CHARS=700

require_contains() {
  file=$1
  pattern=$2
  label=$3
  if [ -f "$file" ] && ! grep -Eq "$pattern" "$file"; then
    error "$file missing required reference: $label"
  fi
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

    description=$(awk '/^description: / { sub(/^description: /, ""); print; exit }' "$skill_file")
    description_chars=$(printf '%s' "$description" | wc -c | tr -d ' ')
    [ "$description_chars" -ge "$MIN_DESCRIPTION_CHARS" ] || error "$skill_file description is too short for reliable routing"
    [ "$description_chars" -le "$MAX_DESCRIPTION_CHARS" ] || error "$skill_file description exceeds $MAX_DESCRIPTION_CHARS chars"

    skill_lines=$(wc -l < "$skill_file" | tr -d ' ')
    [ "$skill_lines" -le "$MAX_SKILL_LINES" ] || error "$skill_file exceeds $MAX_SKILL_LINES lines; move detail to references/"

    if grep -Eq 'TODO|TBD|FIXME' "$skill_file"; then
      error "$skill_file contains unresolved TODO/TBD/FIXME guidance"
    fi

    refs=$(grep -Eo 'references/[A-Za-z0-9._/-]+' "$skill_file" | sort -u || true)
    for ref in $refs; do
      [ -e "$dir/$ref" ] || error "$skill_file references missing path: $ref"
    done

    if [ -f README.md ] && ! grep -Fq "| \`$skill\`" README.md; then
      error "README.md inventory missing skill: $skill"
    fi
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
    booking-workflow-architecture|microservice-component-event-flow|pagoda|realtime-voice-agent-design|sdk-release-consumer-bump)
      expected=true
      ;;
  esac
  [ "$actual" = "$expected" ] || error "$yaml has allow_implicit_invocation: $actual; expected $expected"
done

if grep -R --exclude='validate-skills.sh' "pagoda-framework" AGENTS.md README.md docs skills >/dev/null 2>&1; then
  error "repository references stale skill name pagoda-framework; use pagoda"
fi

require_file docs/validation.md
require_file docs/rule-evidence-registry.md
require_file docs/task-checkpoint-template.md
require_contains docs/validation.md '\./scripts/validate-skills\.sh' "skill validation command"
require_contains docs/rule-evidence-registry.md '\./scripts/validate-skills\.sh' "skill validation evidence"

if [ -f ../ANTIGRAVITY.md ]; then
  require_contains ../ANTIGRAVITY.md '`AGENTS\.md` is the canonical agent instruction source' "canonical AGENTS.md deferral"
  if grep -Eq 'ThePetitbonDoctrine|the-petitbon-doctrine|ddd-eda-architecture|nodejs-microservice-best-practices|nodejs-microservice-structure|sdk-release-and-consumer-bump' ../ANTIGRAVITY.md; then
    error "../ANTIGRAVITY.md contains stale skill mapping names"
  fi
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf 'Skill validation passed.\n'
