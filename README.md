# Agentis Skills

This repository stores Agentis-specific Codex skills. It is a governance and
instruction repository, not a runtime service.

## Inventory

| Skill | Primary ownership | Implicit invocation |
| --- | --- | --- |
| `agentis-engineering-doctrine` | Default engineering posture and fail-close doctrine | No |
| `booking-workflow-architecture` | Booking workflow state, proposal identity, confirmation, recovery, and authority | Yes |
| `domain-event-architecture` | Bounded contexts, ownership, contracts, commands, and events | No |
| `nodejs-service-runtime` | Node.js/TypeScript service runtime quality and operability | No |
| `nodejs-service-structure` | Node.js/TypeScript service folder layout, naming, and dependency direction | No |
| `pagoda-framework` | Pagoda outcome proof, contracts, traces, scenario oracles, and Workbench isolation | Yes |
| `realtime-voice-agent-design` | Realtime voice-agent tools, prompts, state, confirmation, and guarded execution | Yes |
| `repo-agent-governance` | Repository operating layer, skill hygiene, validation, docs, and cleanup loops | No |
| `sdk-release-consumer-bump` | SDK versioning, GitHub Actions publishing flow, registry verification, and consumer bumps | Yes |

## Maintenance Workflow

1. Update the smallest owning skill or reference file.
2. Keep routing text precise enough that agents can choose one primary skill.
3. Move detailed recurring guidance into references instead of expanding
   `SKILL.md`.
4. Update `agents/openai.yaml` only when display text or invocation policy
   changes.
5. Run `./scripts/validate-skills.sh`.

## Source Of Truth

`AGENTS.md` defines local authoring and validation rules. `docs/validation.md`
describes the validation checks. Generated CodeSight and CodeGraph files are not
tracked in this repository.
