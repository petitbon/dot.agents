# Agentis Skills

This repository stores Agentis-specific Codex skills. It is a governance and
instruction repository, not a runtime service.

## Inventory

| Skill | Primary ownership | Implicit invocation |
| --- | --- | --- |
| `agentis-auth-posture-governance` | Authentication/authz posture, flat internal trust, auth audit drift, and validation | Yes |
| `agentis-engineering-doctrine` | Proportional design, maintenance-window cutovers, no premature optimization, and fail-close engineering posture | Yes |
| `agentis-unversioned-contracts` | Current-only contracts, retired compatibility removal, and offline cutover boundaries | Yes |
| `booking-workflow-architecture` | Booking workflow state, proposal identity, confirmation, recovery, and authority | Yes |
| `domain-event-architecture` | Bounded contexts, ownership, contracts, commands, and events | Yes |
| `agentis-realtime-authority-layer` | Realtime tool registry, Authority Runtime admission, resolver routing, finalization, evidence, and compliance | Yes |
| `microservice-component-event-flow` | Mermaid component/event-flow diagrams for one microservice's internal logic and boundaries | Yes |
| `nodejs-service-runtime` | Node.js/TypeScript service runtime quality and operability | Yes |
| `nodejs-service-structure` | Node.js/TypeScript service folder layout, naming, and dependency direction | Yes |
| `realtime-voice-agent-design` | Realtime voice-agent tools, prompts, state, confirmation, and guarded execution | Yes |
| `run-realtime-scenarios` | Deployed dev phone/browser scenario execution, evidence, bounded retries, and cleanup | Yes |
| `repo-agent-governance` | Repository operating layer, skill hygiene, validation, docs, and cleanup loops | Yes |
| `sdk-release-consumer-bump` | SDK versioning, GitHub Actions publishing flow, registry verification, and consumer bumps | Yes |

## Maintenance Workflow

1. Update the smallest owning skill or reference file.
2. Keep routing text precise enough that agents can choose one primary skill.
3. Move detailed recurring guidance into references instead of expanding
   `SKILL.md`.
4. Update `agents/openai.yaml` only when display text or invocation policy
   changes.
5. Run `./scripts/validate-skills.sh`.
6. Run `./scripts/test-validate-skills.sh` when changing the validator or an
   encoded semantic guard.

## Source Of Truth

`AGENTS.md` defines local authoring and validation rules. `docs/validation.md`
describes the validation checks. Generated CodeSight and CodeGraph files are not
tracked in this repository.
