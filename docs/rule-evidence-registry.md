# Rule Evidence Registry

This registry maps durable Agentis agent-harness rules to the evidence that
proves or reviews them. Keep rows short and update this file when a repeated
agent instruction becomes a source-of-truth rule or a mechanical check.

| Rule | Owner | Source | Evidence | Enforcement |
| --- | --- | --- | --- | --- |
| Skills must have valid entrypoints, metadata, precise routing, existing references, and bounded `SKILL.md` size. | `repo-agent-governance` | `skills/*/SKILL.md`, `skills/*/agents/openai.yaml` | `./scripts/validate-skills.sh` | Hard |
| Broad governance skills must not opt into implicit invocation unless explicitly allowlisted. | `repo-agent-governance` | `scripts/validate-skills.sh` | `./scripts/validate-skills.sh` | Hard |
| Secondary harness docs must defer to root `AGENTS.md` and avoid stale skill inventories. | `repo-agent-governance` | `../ANTIGRAVITY.md` | `./scripts/validate-skills.sh` | Hard |
| Root Agentis docs and contract registries must validate through the scripts repository. | `repo-agent-governance` | `../docs/audit/codex-audit-brief.md` | `cd ../agentis-scripts-local && yarn cli run --env dev validate-docs` | Hard when root docs/contracts change |
| Large or interruptible work should leave a resumable checkpoint artifact. | `repo-agent-governance` | `docs/task-checkpoint-template.md` | Review artifact in PR or final evidence report | Soft |
| UI changes should provide screenshots or video; realtime scenario changes should provide traces, debug bundles, or Pagoda artifacts. | Owning domain skill plus `repo-agent-governance` | Owning child repo docs and task evidence | PR evidence report | Soft |
