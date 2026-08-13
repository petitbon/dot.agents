#!/bin/sh
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
AGGREGATOR_ROOT=$(cd "$ROOT/.." && pwd)

fail=0

error() {
  printf 'FAIL: %s\n' "$1" >&2
  fail=1
}

note() {
  printf 'NOTE: %s\n' "$1"
}

require_file() {
  [ -f "$1" ] || error "missing required file: $1"
}

MIN_DESCRIPTION_CHARS=120
MAX_DESCRIPTION_CHARS=350
MAX_TOTAL_DESCRIPTION_CHARS=4000
MAX_SKILL_BYTES=8000
MAX_ROUTER_SKILL_BYTES=6144
MAX_ROOT_AGENTS_BYTES=3072
MAX_ACTIVE_AGENTS_CHAIN_BYTES=7168
MAX_PHASE_CONTEXT_BYTES=16384

description_total=0

require_contains() {
  file=$1
  pattern=$2
  label=$3
  if [ -f "$file" ] && ! grep -Eq "$pattern" "$file"; then
    error "$file missing required reference: $label"
  fi
}

require_nonempty_yaml_field() {
  file=$1
  key=$2
  value=$(awk -v key="$key" '$1 == key ":" { sub(/^[^:]+:[[:space:]]*/, ""); print; exit }' "$file")
  case "$value" in
    '""'|"''") value= ;;
  esac
  [ -n "$value" ] || error "$file missing non-empty field: $key"
}

check_context_bundle() {
  label=$1
  shift
  total=0
  for file in "$@"; do
    [ -f "$file" ] || {
      error "$label missing context file: $file"
      return
    }
    bytes=$(wc -c < "$file" | tr -d ' ')
    total=$((total + bytes))
  done
  [ "$total" -le "$MAX_PHASE_CONTEXT_BYTES" ] ||
    error "$label context bundle is $total bytes; exceeds $MAX_PHASE_CONTEXT_BYTES"
}

yaml_field_value() {
  file=$1
  key=$2
  awk -v key="$key" '$1 == key ":" { sub(/^[^:]+:[[:space:]]*/, ""); print; exit }' "$file"
}

require_section_contains() {
  file=$1
  start_heading=$2
  end_heading=$3
  token=$4
  label=$5
  if ! awk -v start="$start_heading" -v end="$end_heading" '
    $0 == start { active = 1; next }
    $0 == end { active = 0 }
    active { print }
  ' "$file" | grep -Fq "$token"; then
    error "$file $label missing $token"
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
    first_line=$(sed -n '1p' "$skill_file")
    [ "$first_line" = "---" ] || error "$skill_file must start with YAML frontmatter"
    delimiter_count=$(awk '$0 == "---" { count += 1 } END { print count + 0 }' "$skill_file")
    [ "$delimiter_count" -ge 2 ] || error "$skill_file is missing a closing frontmatter delimiter"

    name=$(awk '/^name: / { print $2; exit }' "$skill_file")
    [ "$name" = "$skill" ] || error "$skill_file frontmatter name '$name' does not match '$skill'"

    description=$(awk '/^description: / { sub(/^description: /, ""); print; exit }' "$skill_file")
    description_chars=$(printf '%s' "$description" | wc -c | tr -d ' ')
    description_total=$((description_total + description_chars))
    [ "$description_chars" -ge "$MIN_DESCRIPTION_CHARS" ] || error "$skill_file description is too short for reliable routing"
    [ "$description_chars" -le "$MAX_DESCRIPTION_CHARS" ] || error "$skill_file description exceeds $MAX_DESCRIPTION_CHARS chars"

    skill_bytes=$(wc -c < "$skill_file" | tr -d ' ')
    skill_budget=$MAX_SKILL_BYTES
    case "$skill" in
      agentis-engineering-doctrine|domain-event-architecture|nodejs-service-runtime|run-realtime-scenarios)
        skill_budget=$MAX_ROUTER_SKILL_BYTES
        ;;
    esac
    [ "$skill_bytes" -le "$skill_budget" ] ||
      error "$skill_file is $skill_bytes bytes; exceeds $skill_budget byte entrypoint budget"

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

  if [ -f "$yaml_file" ]; then
    require_nonempty_yaml_field "$yaml_file" display_name
    require_nonempty_yaml_field "$yaml_file" short_description
    require_nonempty_yaml_field "$yaml_file" default_prompt
    default_prompt=$(yaml_field_value "$yaml_file" default_prompt)
    case "$default_prompt" in
      *"\$$skill"*) ;;
      *) error "$yaml_file default_prompt must reference \$$skill" ;;
    esac
  fi
done

[ "$description_total" -le "$MAX_TOTAL_DESCRIPTION_CHARS" ] ||
  error "skill descriptions total $description_total chars; exceeds $MAX_TOTAL_DESCRIPTION_CHARS"

check_context_bundle "engineering doctrine delegation phase" \
  skills/agentis-engineering-doctrine/SKILL.md \
  skills/agentis-engineering-doctrine/references/delegation-and-failure-semantics.md
check_context_bundle "engineering doctrine design phase" \
  skills/agentis-engineering-doctrine/SKILL.md \
  skills/agentis-engineering-doctrine/references/proportional-design-and-control-smells.md
check_context_bundle "domain architecture source phase" \
  skills/domain-event-architecture/SKILL.md \
  skills/domain-event-architecture/references/architecture-source-and-workflow.md
check_context_bundle "domain architecture modeling phase" \
  skills/domain-event-architecture/SKILL.md \
  skills/domain-event-architecture/references/modeling-and-coupling-review.md
check_context_bundle "Node runtime implementation phase" \
  skills/nodejs-service-runtime/SKILL.md \
  skills/nodejs-service-runtime/references/implementation-runtime-rules.md
check_context_bundle "Node runtime observability phase" \
  skills/nodejs-service-runtime/SKILL.md \
  skills/nodejs-service-runtime/references/observability-and-cloud-run.md
check_context_bundle "realtime scenario preflight phase" \
  skills/run-realtime-scenarios/SKILL.md \
  skills/run-realtime-scenarios/references/execution-gates.md
check_context_bundle "realtime scenario phone execution phase" \
  skills/run-realtime-scenarios/SKILL.md \
  skills/run-realtime-scenarios/references/runner-invocation.md \
  skills/run-realtime-scenarios/references/synthetic-phone.md
check_context_bundle "realtime scenario browser execution phase" \
  skills/run-realtime-scenarios/SKILL.md \
  skills/run-realtime-scenarios/references/runner-invocation.md \
  skills/run-realtime-scenarios/references/browser-chat.md
check_context_bundle "realtime scenario verdict phase" \
  skills/run-realtime-scenarios/SKILL.md \
  skills/run-realtime-scenarios/references/evidence-and-cleanup.md

tracked_noise=$(git ls-files | grep -E '(^|/)\.DS_Store$|^\.codesight/|^\.codegraph/' || true)
if [ -n "$tracked_noise" ]; then
  printf '%s\n' "$tracked_noise" >&2
  error "generated or noisy files are tracked"
fi

if grep -Eq 'unless the user explicitly requests local publishing|Do not use the local publish command unless|local SDK publishing work' skills/sdk-release-consumer-bump/SKILL.md; then
  error "SDK skill still contains local-publishing exception wording"
fi

if grep -Eq 'Do not publish failing SDKs unless|publishing with missing[^.]*unless explicitly|push(ing)? the current branch' skills/sdk-release-consumer-bump/SKILL.md; then
  error "SDK skill contains a release-integrity or publish-trigger exception"
fi

require_contains skills/booking-workflow-architecture/SKILL.md 'Do not use for standalone Scheduling work' "standalone Scheduling routing exclusion"
require_contains skills/agentis-engineering-doctrine/references/proportional-design-and-control-smells.md '^## Proportional Design And Optimization$' "proportional-design doctrine section"
require_contains skills/agentis-engineering-doctrine/references/proportional-design-and-control-smells.md 'speculative scale' "premature-optimization guard"
require_contains skills/agentis-engineering-doctrine/references/proportional-design-and-control-smells.md 'Do not split reads and writes into separate microservices' "read/write microservice split guard"
require_contains skills/agentis-engineering-doctrine/SKILL.md 'Do not trigger for ordinary implementation, planning, or' "doctrine implicit-routing exclusion"
require_contains skills/agentis-realtime-authority-layer/SKILL.md 'docs/architecture/realtime-capability-compliance\.md' "canonical realtime compliance Markdown path"
require_contains skills/agentis-realtime-authority-layer/SKILL.md 'docs/architecture/realtime-capability-compliance\.json' "canonical realtime compliance JSON path"
if grep -Eq 'For future booking realtime tools|Recommended phase order' skills/agentis-realtime-authority-layer/SKILL.md; then
  error "realtime authority skill contains stale future-tool or fixed-phase guidance"
fi

for architecture_skill in skills/domain-event-architecture/references/architecture-source-and-workflow.md skills/nodejs-service-structure/SKILL.md; do
  require_contains "$architecture_skill" 'untrusted until' "untrusted plan/design-note guard"
  if grep -Eq 'Treat documented target(-state)? architecture as canonical' "$architecture_skill"; then
    error "$architecture_skill gives unverified architecture documents canonical precedence"
  fi
done

require_contains skills/domain-event-architecture/SKILL.md 'Use agentis-realtime-authority-layer when the primary concern' "domain/realtime primary routing boundary"
require_contains skills/repo-agent-governance/SKILL.md 'Do not use as the primary skill for domain rules' "governance/domain primary routing boundary"
require_contains skills/realtime-voice-agent-design/SKILL.md 'safe termination, a declared supported' "explicit realtime repeated-failure behavior"
if grep -Fq 'safe fallback' skills/realtime-voice-agent-design/SKILL.md; then
  error "skills/realtime-voice-agent-design/SKILL.md contains ambiguous safe-fallback wording"
fi

require_contains skills/realtime-voice-agent-design/references/prompting-guide.md 'https://developers\.openai\.com/api/docs/guides/realtime-models-prompting' "official Realtime prompting guide"
require_contains skills/realtime-voice-agent-design/references/prompting-guide.md '^- `final`: final user-facing response\.$' "final prompt channel"
if grep -Eq '^- `final_answer`:' skills/realtime-voice-agent-design/references/prompting-guide.md; then
  error "Realtime prompting guide treats final_answer as a prompt channel"
fi

require_contains skills/microservice-component-event-flow/references/mermaid-authoring-and-validation.md 'mmdc -i' "Mermaid render validation command"

for yaml in skills/*/agents/openai.yaml; do
  skill=${yaml#skills/}
  skill=${skill%%/*}
  actual=$(awk '/allow_implicit_invocation:/ { print $2; exit }' "$yaml")
  [ "$actual" = true ] || error "$yaml has allow_implicit_invocation: $actual; expected true so every Agentis skill is exposed"
done

if [ -f "$AGGREGATOR_ROOT/WORKSPACE_CONTEXT.md" ]; then
  require_file "$AGGREGATOR_ROOT/AGENTS.md"
  require_file "$AGGREGATOR_ROOT/skills-routing.md"
  if [ -f "$AGGREGATOR_ROOT/AGENTS.md" ] && [ -f "$AGGREGATOR_ROOT/skills-routing.md" ]; then
    require_contains "$AGGREGATOR_ROOT/AGENTS.md" '`skills-routing\.md`' "canonical skills-routing link"
    root_agents_bytes=$(wc -c < "$AGGREGATOR_ROOT/AGENTS.md" | tr -d ' ')
    [ "$root_agents_bytes" -le "$MAX_ROOT_AGENTS_BYTES" ] ||
      error "$AGGREGATOR_ROOT/AGENTS.md is $root_agents_bytes bytes; exceeds $MAX_ROOT_AGENTS_BYTES"

    for guidance in \
      "$AGGREGATOR_ROOT"/.agents/AGENTS.md \
      "$AGGREGATOR_ROOT"/agentis-*/AGENTS.md \
      "$AGGREGATOR_ROOT"/docs/AGENTS.md \
      "$AGGREGATOR_ROOT"/sdks/*/AGENTS.md \
      "$AGGREGATOR_ROOT"/services/*/AGENTS.md \
      "$AGGREGATOR_ROOT"/web/*/AGENTS.md; do
      [ -f "$guidance" ] || continue
      child_agents_bytes=$(wc -c < "$guidance" | tr -d ' ')
      active_chain_bytes=$((root_agents_bytes + child_agents_bytes))
      [ "$active_chain_bytes" -le "$MAX_ACTIVE_AGENTS_CHAIN_BYTES" ] ||
        error "$guidance produces a $active_chain_bytes byte Agentis instruction chain; exceeds $MAX_ACTIVE_AGENTS_CHAIN_BYTES"
    done

    for dir in skills/*; do
      [ -d "$dir" ] || continue
      skill=${dir##*/}
      token="\`$skill\`"
      require_section_contains "$AGGREGATOR_ROOT/skills-routing.md" "## Primary Skill Map" "## Realtime Authority Handoffs" "$token" "primary skill map"
    done
  fi

  for guidance in "$AGGREGATOR_ROOT"/sdks/*/AGENTS.md "$AGGREGATOR_ROOT"/sdks/*/README.md; do
    [ -f "$guidance" ] || continue
    if grep -Eiq 'unless (the )?user explicitly requests local|if (the )?user explicitly requests local|local publish(ing)? (is )?(allowed|permitted)' "$guidance"; then
      error "$guidance permits local SDK publishing; use the declared GitHub Actions workflow"
    fi
    if grep -Eq '^[[:space:]]*-[[:space:]]+`?(yarn( npm)?|npm)[[:space:]]+publish(`|[[:space:]]|$)' "$guidance"; then
      error "$guidance presents a local SDK publish command; use the declared GitHub Actions workflow"
    fi
  done
else
  note "aggregator routing files unavailable; skipped root skill-inventory parity"
fi

require_file docs/validation.md
require_file docs/rule-evidence-registry.md
require_file docs/task-checkpoint-template.md
require_contains docs/validation.md '\./scripts/validate-skills\.sh' "skill validation command"
require_contains docs/rule-evidence-registry.md '\./scripts/validate-skills\.sh' "skill validation evidence"

if [ -f ../ANTIGRAVITY.md ]; then
  require_contains ../ANTIGRAVITY.md '`AGENTS\.md` is canonical' "canonical AGENTS.md deferral"
  if grep -Eq 'ThePetitbonDoctrine|the-petitbon-doctrine|ddd-eda-architecture|nodejs-microservice-best-practices|nodejs-microservice-structure|sdk-release-and-consumer-bump' ../ANTIGRAVITY.md; then
    error "../ANTIGRAVITY.md contains stale skill mapping names"
  fi
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf 'Skill validation passed.\n'
