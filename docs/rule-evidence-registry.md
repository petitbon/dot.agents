# Rule Evidence Registry

This registry maps durable Agentis agent-harness rules to the evidence that
proves or reviews them. Keep rows short and update this file when a repeated
agent instruction becomes a source-of-truth rule or a mechanical check.

| Rule | Owner | Source | Evidence | Enforcement |
| --- | --- | --- | --- | --- |
| Skills must have entrypoints, delimited frontmatter, matching names, required interface metadata, valid bundled references, and bounded `SKILL.md` size. | `repo-agent-governance` | `skills/*/SKILL.md`, `skills/*/agents/openai.yaml` | `./scripts/validate-skills.sh` | Hard |
| Skill inventory must stay aligned with the local README and, in the Agentis aggregator, the owned root routing sections. | `repo-agent-governance` | `README.md`, `../AGENTS.md`, `../skills-routing.md` | `./scripts/validate-skills.sh` | Hard in aggregator context; local README remains hard standalone |
| Proportional design, release integrity, primary-skill routing boundaries, booking/Scheduling routing, source precedence, realtime current-state and failure behavior, prompt-channel, and Mermaid-render guidance must not regress. SDK publishing guidance must route exclusively through declared GitHub Actions workflows. | Owning skill plus `repo-agent-governance` | Affected skill and reference files; `../sdks/*/AGENTS.md`; `../sdks/*/README.md` | `./scripts/validate-skills.sh`, `./scripts/test-validate-skills.sh` | Hard for encoded guards; manual review for other semantics |
| Every Agentis skill must opt into implicit invocation so all skill routing metadata is exposed in the default model context. | `repo-agent-governance` | `skills/*/agents/openai.yaml`, `scripts/validate-skills.sh` | `./scripts/validate-skills.sh`, `./scripts/test-validate-skills.sh` | Hard |
| Secondary harness docs must defer to root `AGENTS.md` and avoid stale skill inventories. | `repo-agent-governance` | `../ANTIGRAVITY.md` | `./scripts/validate-skills.sh` | Hard |
| Root Agentis docs and contract registries must validate through the scripts repository. | `repo-agent-governance` | `../docs/audit/codex-audit-brief.md` | `cd ../agentis-scripts-local && yarn cli run --env dev validate-docs` | Hard when root docs/contracts change |
| Large or interruptible work should leave a resumable checkpoint artifact. | `repo-agent-governance` | `docs/task-checkpoint-template.md` | Review artifact in PR or final evidence report | Soft |
| UI changes should provide screenshots or video; realtime behavior changes should provide traces, debug bundles, or deterministic integration-test evidence. | Owning domain skill plus `repo-agent-governance` | Owning child repo docs and task evidence | PR evidence report | Soft |
| Realtime debug-bundle reviews must not flag combined multi-provider phrasing or non-monotonic timeline `seq` values without concrete missing, duplicated, contradictory, or causally invalid authority evidence. | `repo-agent-governance` | `../AGENTS.md` (`Realtime Debug Bundle Review Baselines`) | Review finding cites the contradictory bundle evidence; otherwise no finding | Manual review |
