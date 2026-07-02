---
name: agentis-realtime-authority-layer
description: "Use as the primary skill for the Agentis Realtime Authority Layer Ontology: canonical realtime tool registry, channel-specific live tool exposure for phone/browser chat, Authority Runtime design, capability manifests, resolver topology, finalization/evidence policy, governed mutation admission, Rules runtime booking-policy evaluation, and cross-adapter compliance. Use realtime-voice-agent-design for prompt/model behavior, booking-workflow-architecture for booking proposal/commit state-machine detail, and repo-agent-governance for repository-local enforcement plumbing."
---

# Agentis Realtime Authority Layer

Use this skill when designing, reviewing, implementing, or delegating work that changes the canonical realtime authority layer used by Agentis phone and browser chat.

## Scope

This skill owns the cross-cutting authority ontology for live tools:

- SDK-owned realtime operation registry and capability metadata;
- channel-specific effective tool surfaces for `phone` and `browser-chat`;
- provider-neutral live tool declarations and provider-specific adapter translation rules;
- Authority Runtime admission, validation, trusted context injection, requirement checks, resolver dispatch, finalization, and evidence policy;
- capability resolver topology and backend authority routing;
- governed mutation operation records, idempotency, stale-state rejection, and terminal result rules;
- Rules service runtime booking-policy evaluation when used by Booking Workflow search/proposal paths;
- cross-repo compliance validators that prevent realtime tool drift.

Do not use this skill as the primary owner for:

- realtime prompt wording, voice behavior, ambiguity handling, or model response style: use `realtime-voice-agent-design`;
- booking proposal lifecycle, confirmation readiness, conflict recovery, and commit state-machine detail: use `booking-workflow-architecture`;
- general DDD/EDA context maps outside realtime authority: use `domain-event-architecture`;
- repository-local `AGENTS.md`, validation registries, skill inventory hygiene, or mechanical check placement: use `repo-agent-governance`;
- Node.js service bootstrap/runtime internals: use `nodejs-service-runtime`;
- service folder structure and import direction: use `nodejs-service-structure`;
- auth posture drift, Cloud Run/API Gateway trust posture, or `x-serverless-authorization` semantics: use `agentis-auth-posture-governance`.

## First Reads

Load the smallest relevant source of truth before making findings or edits:

- `docs/architecture/current-state.md`;
- `docs/architecture/realtime-capabilities.md`;
- `docs/architecture/authentication-authorization-posture.md` when trusted context, auth, or internal/external traffic is affected;
- `realtime-capability-compliance.md` and JSON companion;
- the SDK source defining `REALTIME_TOOL_OPERATION_REGISTRY`;
- realtime phone and browser adapter READMEs, `AGENTS.md`, tool-surface wiring, and resolver wiring;
- relevant domain service READMEs and contracts for Clients, Scheduling, Salon Config, Booking Workflow, Rules, and Session Ledger;
- current docs/validators that check capability registry, docs freshness, and service-auth posture.

## Core Thesis

The realtime model may request capabilities. The Authority Runtime decides whether the request is declared, valid, authorized, current, executable, finalizable, and evidence-backed.

```text
Model/tool request
  -> canonical registry lookup
  -> schema validation
  -> trusted context injection
  -> requirement and authorization gate
  -> workflow/precondition check
  -> idempotency/operation binding when needed
  -> declared resolver
  -> backend authority
  -> finalization policy
  -> evidence/outbox append
  -> structured result
```

The authority layer owns tool admission and execution governance, not domain truth.

## Ontology Rules

1. The SDK registry is the single canonical source for realtime operation names, tool names, channels, resolver keys, authority topology, requirements, finalization, transcript grounding, and fact policy.
2. Phone and browser chat must derive effective tool declarations from the registry for their channel.
3. Realtime adapters may translate canonical tools into provider-specific live-tool declarations, but must not define independent business tools.
4. Authority-backed tools must execute through the declared resolver and backend authority.
5. Model-supplied trusted IDs, tenant/business/location/session authority fields, identity facts, appointment IDs, and policy facts must be rejected or ignored in favor of server-injected context and backend authority facts.
6. Assistant prose, transcript text, provider DTOs, runtime observations, and Session Ledger evidence are not booking, scheduling, client, pricing, policy, or availability truth.
7. User-facing success for an authority-backed operation requires authority finalization according to the operation’s declared finalization policy.
8. Governed mutations require active state identity, explicit current confirmation when applicable, idempotency, operation records, stale-state rejection, and durable evidence.
9. Async projections, analytics, debug timelines, and export adapters must not be on the realtime critical path for truth.
10. Any new realtime tool must add or update registry metadata, resolver wiring, authority contract, tests, compliance matrix, and validation gates in the same work.

## Operation Classes

Classify each operation before implementation:

```text
RUNTIME_CONTROL
  ephemeral runtime command, usually no domain finalization, channel-specific.

QUERY
  backend-authority read with structured result; may require identity/scope and evidence.

DIRECT_COMMAND
  non-mutation command requiring authority execution and finalization.

GOVERNED_MUTATION
  side-effecting operation requiring operation identity, idempotency, preconditions,
  confirmation where applicable, finalization, evidence, and duplicate-safe behavior.
```

Do not apply governed-mutation overhead to simple runtime control. Do not treat governed mutations as ordinary queries.

## Capability Manifest Requirements

Every registry operation should define or derive:

- operation name and tool name;
- operation kind and workflow phase;
- supported channels;
- resolver key;
- primary authority and required authority components;
- requirements such as trusted identity, active proposal, current confirmation, or business scope;
- model-allowed argument schema;
- server-injected context fields;
- finalization requirement and user-visible success rule;
- transcript grounding and fact policy;
- evidence scenario;
- idempotency shape for writes;
- stale-state/precondition rules for workflow operations.

## Authority Runtime Responsibilities

The Authority Runtime must:

1. reject undeclared tools;
2. reject channel-disallowed tools;
3. validate model arguments strictly;
4. reject unknown model arguments when schemas are closed;
5. strip or reject trusted fields supplied by the model;
6. inject trusted context from the server/session boundary;
7. evaluate requirements and domain authorization preconditions;
8. bind operation ID and idempotency key for governed mutations;
9. dispatch only to the declared resolver;
10. enforce finalization semantics before user-facing success;
11. append durable local evidence/outbox records where required;
12. return structured success, pending, rejected, conflict, expired, or failed results.

Prefer an in-process shared runtime/SDK on the hot path unless a network gateway is explicitly justified by language/runtime isolation or centralized enforcement requirements.

## Domain Authority Boundaries

Use the declared owner for every fact and side effect:

- Clients owns caller identity, profile reads/upserts, and provider preference/continuity facts.
- Scheduling owns availability candidates, appointment persistence, slot locks, appointment read views, and Scheduling-derived capacity metrics.
- Salon Config owns business/location/provider/offer/catalog/admin-authored configuration facts.
- Rules owns compiled or derived business/location rule products and deterministic runtime booking-policy evaluation over supplied candidate/fact inputs.
- Booking Workflow owns governed booking workflow decisions, proposal frames, confirmation state, operation records, and commit orchestration.
- Session Ledger owns session lifecycle, transcript truth, runtime observations, dependency evidence, debug bundles, and audit events, but not business authorization.
- Realtime adapters own transport and provider session mechanics only.

## Rules Runtime Booking-Policy Evaluation

Use Rules for deterministic policy evaluation when Booking Workflow needs to rank, filter, or select among Scheduling-returned candidates.

Rules may:

- evaluate compiled location booking policy sets;
- rank or filter candidates supplied by Booking Workflow;
- select the best candidate according to versioned policy precedence;
- explain applied policies and score tuples;
- return `policySetId`, `policyVersion`, `evaluationId`, `candidateSetHash`, `inputHash`, `selectedOption`, `rankedOptions`, and `reasonTrace`.

Rules must not:

- create availability;
- call Scheduling to invent candidates during evaluation unless a separate contract explicitly makes Rules an orchestrator, which is not the preferred target;
- create, modify, cancel, or reschedule appointments;
- bypass Booking Workflow proposal/confirmation/commit authority;
- infer policy facts from transcript text or assistant prose;
- own Salon Config catalog/provider/offer truth;
- own Scheduling capacity or appointment truth.

Preferred runtime search path:

```text
find_bookable_options
  -> Authority Runtime
  -> Booking Search Resolver
  -> Booking Workflow
  -> Scheduling candidate search
  -> Clients continuity/preferences where needed
  -> Rules policy evaluation over supplied candidates/facts
  -> Booking Workflow stores ranked proposal frame
  -> authority-grounded result to realtime layer
```

A Rules-selected option is a proposal decision, not a booking. A booking exists only after Booking Workflow finalization and Scheduling appointment creation.

## Booking-Tool Guardrails

For future booking realtime tools:

- `find_bookable_options` may create/update a proposal frame, but must not create an appointment.
- `commit_booking` must require active proposal identity, matching proposal revision, current explicit confirmation, idempotency key, fresh policy/candidate facts, Scheduling private write success, terminal operation state, and evidence.
- Any material constraint change invalidates proposals and pending confirmation.
- Stale, expired, conflicted, superseded, or transcript-only proposals must fail closed.
- Slot conflict recovery must return to the normal proposal path with a new active proposal identity.

## Evidence And Finalization

Authority evidence should be durable and local before async projection.

Minimum synchronous evidence for authority-backed operations:

- operation/capability name;
- channel;
- resolver key;
- business/location/session/correlation context;
- backend authority called;
- authority result status;
- finalization status;
- operation ID/idempotency key for writes;
- proposal/policy/candidate hashes where applicable;
- evidence/outbox event ID.

Do not block realtime turns on timeline projections, analytics, export adapters, or debug materialization. Do block user-facing success on backend authority finalization for operations that require finalization.

## Validation Expectations

For any change that adds or changes realtime authority behavior, require targeted validation for:

- registry and compliance matrix consistency;
- channel-specific tool exposure;
- resolver key existence and routing;
- schema closure and trusted-context rejection;
- requirement/precondition enforcement;
- no adapter-defined independent business tools;
- no transcript/prose-derived business truth;
- operation record/idempotency behavior for governed mutations;
- Rules policy determinism and no synthesized availability;
- stale proposal/policy/candidate invalidation;
- finalization before user-facing success;
- evidence/outbox presence;
- docs freshness.

Report commands actually run and results. Do not claim validation that was not executed.

## Codex Working Rules

When delegating implementation to Codex:

1. Start with registry/docs/contracts before adapter exposure.
2. Implement Authority Runtime contracts before future business tools.
3. Implement domain authority contracts before exposing new realtime tools.
4. Keep phone and browser adapter changes last.
5. Add mechanical validators for any rule that future agents are likely to violate.
6. For each PR, require a bounded context owner, operation class, authority owner, resolver, finalization rule, evidence rule, forbidden paths, and validation commands.

Recommended phase order:

```text
0. docs / registry baseline
1. Authority Runtime SDK
2. Rules runtime booking-policy evaluation
3. Scheduling candidate metadata and provider metrics
4. Clients continuity facts
5. Booking search and proposal frame
6. Booking commit and finalization
7. Realtime adapter integration
8. observability and validators
```

## Review Output

For substantial reviews or implementation plans, produce:

1. operation/capability classification;
2. registry and channel exposure changes;
3. authority manifest/resolver changes;
4. trusted context and schema rules;
5. backend authority owner for each fact/side effect;
6. finalization and evidence requirements;
7. stale-state/idempotency/precondition behavior;
8. Rules policy evaluation placement when relevant;
9. adapter responsibilities and forbidden paths;
10. validators/tests/docs needed to preserve the ontology.

## Definition Of Done

The live tool surface is registry-derived, channel-correct, resolver-backed, authority-finalized, evidence-recorded, and mechanically validated. Realtime adapters translate transport only. Domain truth remains in owning services. Rules can rank or select only Scheduling-returned candidates. Booking success cannot be fabricated from model wording, transcript text, runtime observations, or unfinalized operations.
