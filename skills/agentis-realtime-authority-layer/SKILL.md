---
name: agentis-realtime-authority-layer
description: "Use for the Agentis realtime authority ontology: canonical live-tool registry, channel exposure, Authority Runtime admission, capability manifests, resolver routing, governed mutations, Rules booking policy, finalization, evidence, and adapter compliance. Use narrower voice, booking, or repository skills for their owned artifacts."
---

# Agentis Realtime Authority Layer

Use this skill when work changes the canonical realtime authority layer shared
by Agentis phone and browser chat.

## Routing

This skill owns registry semantics, channel exposure, Authority Runtime
admission, resolver routing, finalization, evidence, governed mutation
admission, Rules booking-policy placement, and cross-adapter compliance.

Use another primary skill for:

- prompt, voice, ambiguity, and model behavior: `realtime-voice-agent-design`;
- booking proposal and commit state: `booking-workflow-architecture`;
- general context maps and domain events: `domain-event-architecture`;
- repository-local check placement: `repo-agent-governance`;
- Node runtime implementation: `nodejs-service-runtime`;
- folder and dependency structure: `nodejs-service-structure`;
- auth provenance and trust posture: `agentis-auth-posture-governance`.

## Reference Loading

- Load `references/capability-runtime-rules.md` for operation classes,
  capability manifests, admission, trusted context, dispatch, and results.
- Load `references/booking-policy-and-finalization.md` for Rules evaluation,
  booking-tool guardrails, currentness, finalization, and evidence.

## First Reads

Load only the relevant current sources:

- `docs/architecture/current-state.md`;
- `docs/architecture/realtime-capabilities.md`;
- `docs/architecture/realtime-capability-compliance.md`;
- `docs/architecture/realtime-capability-compliance.json`;
- `docs/architecture/authentication-authorization-posture.md` when auth or
  trusted context changes;
- the SDK `REALTIME_TOOL_OPERATION_REGISTRY` source;
- affected adapter and domain-service `AGENTS.md`, READMEs, contracts, resolver
  wiring, and validators.

## Core Thesis

The model may request a capability. The Authority Runtime decides whether that
request is declared, channel-allowed, valid, authorized, current, executable,
finalizable, and evidence-backed.

```text
model request -> registry -> validation -> trusted context -> requirements
  -> resolver -> backend authority -> finalization -> evidence -> result
```

The authority layer governs admission and execution. It does not own domain
truth.

## Ontology Rules

1. The SDK registry is canonical for operation and tool names, channels,
   schemas, resolver keys, requirements, finalization, grounding, and fact
   policy.
2. Phone and browser chat derive effective tool surfaces from that registry.
3. Adapters translate provider shapes but define no independent business tools.
4. Authority-backed tools dispatch only through declared resolvers and owners.
5. Reject or ignore model-supplied trusted IDs and server-owned context.
6. Prose, transcripts, provider DTOs, observations, and Session Ledger evidence
   are not business truth.
7. User-visible success requires declared authority finalization.
8. Governed mutations require active state, current confirmation when
   applicable, idempotency, stale-state rejection, terminal state, and evidence.
9. Async projections and analytics stay off the realtime truth path.
10. Add registry, resolver, authority contract, tests, compliance, and validator
    updates together for every new tool.

## Domain Authorities

- Clients owns caller identity, profiles, and provider preference/continuity.
- Scheduling owns availability, appointments, slot locks, and capacity metrics.
- Salon Config owns location, catalog, provider, offer, and configured facts.
- Rules owns compiled rule products and deterministic policy evaluation.
- Booking Workflow owns proposals, confirmation, operations, commit
  orchestration, conflict recovery, and booking-local evidence.
- Session Ledger owns lifecycle, transcripts, observations, dependency
  evidence, debug bundles, and audit events—not business authorization.
- Realtime adapters own transport and provider session mechanics only.

## Validation

Validate registry/compliance consistency, channel exposure, resolver existence,
schema closure, trusted-context rejection, preconditions, adapter purity,
idempotency, stale-state handling, authority finalization, evidence, and docs
freshness. For Rules, prove deterministic evaluation over supplied Scheduling
candidates without synthesized availability.

Report commands actually run and results actually inspected.

## Review Output

For substantial work, report operation class, registry/channel changes,
manifest and resolver changes, trusted-context rules, backend owners,
finalization/evidence, stale-state/idempotency behavior, Rules placement,
adapter boundaries, and required validators/tests/docs.

## Definition Of Done

The surface is registry-derived, channel-correct, resolver-backed,
authority-finalized, evidence-recorded, and mechanically validated. Adapters
translate transport only, and no business success comes from prose,
transcripts, observations, or unfinalized operations.
