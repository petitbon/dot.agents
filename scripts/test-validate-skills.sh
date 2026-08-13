#!/bin/sh
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
AGGREGATOR_ROOT=$(cd "$ROOT/.." && pwd)
TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/agentis-skill-validation.XXXXXX")
trap 'rm -rf "$TMP_ROOT"' EXIT HUP INT TERM

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

replace_file() {
  file=$1
  expression=$2
  sed "$expression" "$file" > "$file.next"
  mv "$file.next" "$file"
}

make_fixture() {
  name=$1
  fixture="$TMP_ROOT/$name/agentis"
  mkdir -p "$fixture"
  cp "$AGGREGATOR_ROOT/AGENTS.md" "$fixture/AGENTS.md"
  cp "$AGGREGATOR_ROOT/WORKSPACE_CONTEXT.md" "$fixture/WORKSPACE_CONTEXT.md"
  cp "$AGGREGATOR_ROOT/skills-routing.md" "$fixture/skills-routing.md"
  mkdir -p "$fixture/sdks"
  for sdk_dir in "$AGGREGATOR_ROOT"/sdks/*; do
    [ -d "$sdk_dir" ] || continue
    target_dir="$fixture/sdks/${sdk_dir##*/}"
    mkdir -p "$target_dir"
    [ ! -f "$sdk_dir/AGENTS.md" ] || cp "$sdk_dir/AGENTS.md" "$target_dir/AGENTS.md"
    [ ! -f "$sdk_dir/README.md" ] || cp "$sdk_dir/README.md" "$target_dir/README.md"
  done
  cp -R "$ROOT" "$fixture/.agents"
  rm -rf "$fixture/.agents/.git"
  git -C "$fixture/.agents" init -q
  git -C "$fixture/.agents" add .
  printf '%s\n' "$fixture"
}

run_validator() {
  fixture=$1
  (cd "$fixture/.agents" && ./scripts/validate-skills.sh)
}

expect_failure() {
  name=$1
  fixture=$2
  expected=$3
  if output=$(run_validator "$fixture" 2>&1); then
    fail "$name unexpectedly passed"
  fi
  if ! printf '%s\n' "$output" | grep -Eq "$expected"; then
    printf '%s\n' "$output" >&2
    fail "$name failed without expected diagnostic: $expected"
  fi
  printf 'PASS: %s\n' "$name"
}

baseline=$(make_fixture baseline)
run_validator "$baseline" >/dev/null
printf 'PASS: baseline fixture\n'

standalone=$(make_fixture standalone)
rm "$standalone/WORKSPACE_CONTEXT.md" "$standalone/AGENTS.md" "$standalone/skills-routing.md"
standalone_output=$(run_validator "$standalone")
printf '%s\n' "$standalone_output" | grep -Fq 'skipped root skill-inventory parity' ||
  fail "standalone fixture did not report skipped root routing parity"
printf 'PASS: standalone fixture\n'

missing_metadata=$(make_fixture missing-metadata)
replace_file "$missing_metadata/.agents/skills/repo-agent-governance/agents/openai.yaml" '/short_description:/d'
expect_failure "missing interface metadata" "$missing_metadata" 'missing non-empty field: short_description'

oversized_skill=$(make_fixture oversized-skill)
i=0
while [ "$i" -lt 150 ]; do
  printf 'Additional manual detail that belongs in a reference.\n' >> "$oversized_skill/.agents/skills/repo-agent-governance/SKILL.md"
  i=$((i + 1))
done
expect_failure "oversized skill entrypoint" "$oversized_skill" 'exceeds 8000 byte entrypoint budget'

oversized_router=$(make_fixture oversized-router)
i=0
while [ "$i" -lt 80 ]; do
  printf 'Detailed doctrine guidance belongs in a phase reference.\n' >> "$oversized_router/.agents/skills/agentis-engineering-doctrine/SKILL.md"
  i=$((i + 1))
done
expect_failure "oversized router entrypoint" "$oversized_router" 'exceeds 6144 byte entrypoint budget'

oversized_description=$(make_fixture oversized-description)
replace_file "$oversized_description/.agents/skills/repo-agent-governance/SKILL.md" 's/^description: .*/description: "Use this routing description for repository governance work while repeating enough unnecessary metadata to exceed the compact implicit-context budget. Use it for maps, docs, validation, observability, quality, cleanup, worktrees, checks, skills, plans, and every other repository concern even when a narrower owner applies, because this deliberately oversized fixture must fail the per-skill description budget guard."/'
expect_failure "oversized skill description" "$oversized_description" 'description exceeds 350 chars'

oversized_description_catalog=$(make_fixture oversized-description-catalog)
for skill_file in "$oversized_description_catalog"/.agents/skills/*/SKILL.md; do
  replacement='Use this skill for its declared Agentis artifact and preserve precise primary routing boundaries. This fixture intentionally fills the safe per-skill description allowance with repeated routing detail while remaining under the individual maximum so the aggregate implicit-context catalog budget must reject the combined descriptions rather than one entry.'
  replace_file "$skill_file" "s|^description: .*|description: $replacement|"
done
expect_failure "oversized description catalog" "$oversized_description_catalog" 'skill descriptions total [0-9]+ chars; exceeds 4000'

wrong_prompt=$(make_fixture wrong-prompt)
replace_file "$wrong_prompt/.agents/skills/repo-agent-governance/agents/openai.yaml" 's/\$repo-agent-governance/\$wrong-skill/'
expect_failure "wrong default prompt token" "$wrong_prompt" 'default_prompt must reference \$repo-agent-governance'

implicit_skill_hidden=$(make_fixture implicit-skill-hidden)
replace_file "$implicit_skill_hidden/.agents/skills/repo-agent-governance/agents/openai.yaml" 's/allow_implicit_invocation: true/allow_implicit_invocation: false/'
expect_failure "implicit skill hidden" "$implicit_skill_hidden" 'expected true so every Agentis skill is exposed'

doctrine_overtrigger=$(make_fixture doctrine-overtrigger)
replace_file "$doctrine_overtrigger/.agents/skills/agentis-engineering-doctrine/SKILL.md" 's/Do not trigger for ordinary implementation, planning, or/Apply automatically to ordinary implementation, planning, and/'
expect_failure "doctrine implicit overtrigger" "$doctrine_overtrigger" 'doctrine implicit-routing exclusion'

domain_realtime_collision=$(make_fixture domain-realtime-collision)
replace_file "$domain_realtime_collision/.agents/skills/domain-event-architecture/SKILL.md" 's/Use agentis-realtime-authority-layer when the primary concern/Use domain-event-architecture when the primary concern/'
expect_failure "domain realtime routing collision" "$domain_realtime_collision" 'domain/realtime primary routing boundary'

governance_domain_collision=$(make_fixture governance-domain-collision)
replace_file "$governance_domain_collision/.agents/skills/repo-agent-governance/SKILL.md" 's/Do not use as the primary skill for domain rules/Use as the primary skill for domain rules/'
expect_failure "governance domain routing collision" "$governance_domain_collision" 'governance/domain primary routing boundary'

missing_proportional_design=$(make_fixture missing-proportional-design)
replace_file "$missing_proportional_design/.agents/skills/agentis-engineering-doctrine/references/proportional-design-and-control-smells.md" '/Do not split reads and writes into separate microservices/d'
expect_failure "missing proportional-design guard" "$missing_proportional_design" 'read/write microservice split guard'

missing_root_routing_link=$(make_fixture missing-root-routing-link)
replace_file "$missing_root_routing_link/AGENTS.md" '/`skills-routing.md`/d'
expect_failure "root routing link drift" "$missing_root_routing_link" 'canonical skills-routing link'

missing_primary_skill=$(make_fixture missing-primary-skill)
replace_file "$missing_primary_skill/skills-routing.md" '/| `repo-agent-governance` |/d'
expect_failure "root primary map drift" "$missing_primary_skill" 'primary skill map missing `repo-agent-governance`'

unsafe_release=$(make_fixture unsafe-release)
printf '\nDo not publish failing SDKs unless the user explicitly requests it.\n' >> "$unsafe_release/.agents/skills/sdk-release-consumer-bump/SKILL.md"
expect_failure "release validation override" "$unsafe_release" 'release-integrity or publish-trigger exception'

sdk_local_publish_exception=$(make_fixture sdk-local-publish-exception)
printf '\nSDK publishing is owned by GitHub Actions unless the user explicitly requests local publishing.\n' >> "$sdk_local_publish_exception/sdks/agentis-realtime-sdk/AGENTS.md"
expect_failure "SDK local-publishing exception" "$sdk_local_publish_exception" 'permits local SDK publishing'

sdk_local_publish_command=$(make_fixture sdk-local-publish-command)
printf '\n- `yarn publish`\n' >> "$sdk_local_publish_command/sdks/agentis-data-types-sdk/README.md"
expect_failure "SDK local publish command" "$sdk_local_publish_command" 'presents a local SDK publish command'

wrong_channel=$(make_fixture wrong-channel)
printf '\n- `final_answer`: final user-facing response.\n' >> "$wrong_channel/.agents/skills/realtime-voice-agent-design/references/prompting-guide.md"
expect_failure "Realtime prompt channel drift" "$wrong_channel" 'treats final_answer as a prompt channel'

ambiguous_realtime_fallback=$(make_fixture ambiguous-realtime-fallback)
replace_file "$ambiguous_realtime_fallback/.agents/skills/realtime-voice-agent-design/SKILL.md" 's/safe termination, a declared supported/safe fallback, a declared supported/'
expect_failure "ambiguous realtime fallback" "$ambiguous_realtime_fallback" 'ambiguous safe-fallback wording'

stale_realtime=$(make_fixture stale-realtime)
printf '\nFor future booking realtime tools:\n' >> "$stale_realtime/.agents/skills/agentis-realtime-authority-layer/SKILL.md"
expect_failure "stale realtime rollout guidance" "$stale_realtime" 'stale future-tool or fixed-phase guidance'

unsafe_source_precedence=$(make_fixture unsafe-source-precedence)
replace_file "$unsafe_source_precedence/.agents/skills/domain-event-architecture/references/architecture-source-and-workflow.md" '/untrusted until/d'
expect_failure "unsafe architecture source precedence" "$unsafe_source_precedence" 'untrusted plan/design-note guard'

oversized_root_agents=$(make_fixture oversized-root-agents)
i=0
while [ "$i" -lt 80 ]; do
  printf 'Root manuals belong in owned references instead of automatic context.\n' >> "$oversized_root_agents/AGENTS.md"
  i=$((i + 1))
done
expect_failure "oversized root instructions" "$oversized_root_agents" 'AGENTS.md is [0-9]+ bytes; exceeds 3072'

oversized_active_chain=$(make_fixture oversized-active-chain)
mkdir -p "$oversized_active_chain/services/context-heavy"
i=0
while [ "$i" -lt 100 ]; do
  printf 'Child guidance must remain a compact owner map with local exceptions.\n' >> "$oversized_active_chain/services/context-heavy/AGENTS.md"
  i=$((i + 1))
done
expect_failure "oversized active instruction chain" "$oversized_active_chain" 'instruction chain; exceeds 7168'

oversized_phase_bundle=$(make_fixture oversized-phase-bundle)
i=0
while [ "$i" -lt 180 ]; do
  printf 'Verdict detail belongs in a narrower evidence artifact.\n' >> "$oversized_phase_bundle/.agents/skills/run-realtime-scenarios/references/evidence-and-cleanup.md"
  i=$((i + 1))
done
expect_failure "oversized phase context" "$oversized_phase_bundle" 'realtime scenario verdict phase context bundle is [0-9]+ bytes; exceeds 16384'

missing_mermaid_validation=$(make_fixture missing-mermaid-validation)
replace_file "$missing_mermaid_validation/.agents/skills/microservice-component-event-flow/references/mermaid-authoring-and-validation.md" '/mmdc -i/d'
expect_failure "missing Mermaid render validation" "$missing_mermaid_validation" 'Mermaid render validation command'

printf 'Skill validator regression tests passed.\n'
