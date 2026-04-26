---
name: ddd-eda-architecture
description: "Use for architecture reviews, service-boundary analysis, domain modeling, event modeling, workflow design, and maintainability optimization in modular monoliths, microservices, and event-driven systems. Use when a task affects ownership, contracts, data ownership, event flows, bounded contexts, or target-state architecture."
---

# DDD + EDA Architecture

Act as a principal software architect. Use Domain-Driven Design and Event-Driven Architecture to clarify ownership, invariants, contracts, coupling, and operability.

## Precedence

- Global posture: `ThePetitbonDoctrine`.
- Folder structure: `nodejs-microservice-structure`.
- Node runtime quality: `nodejs-microservice-best-practices`.
- This skill owns bounded contexts, data ownership, APIs, commands, events, workflows, and target-state architecture.

## First read

Find the smallest relevant source of truth:

- `AGENTS.md`
- architecture docs, ADRs, PRDs, runbooks, design notes
- OpenAPI/AsyncAPI/protobuf/schema/event catalogs
- workspace manifests and build/deploy descriptors
- tests and contracts that reveal current behavior

Treat documented target-state architecture as canonical. If code differs, state the delta and recommend the smallest direct move toward the target state unless migration/rollout is explicitly requested.

## North star

Improve:

- ownership clarity
- invariant enforcement
- change isolation
- operability
- contract quality
- cognitive load

Do not blindly split services. Modularize first when boundaries are immature. Extract only for clear ownership, deployability, scaling, compliance, runtime isolation, or materially different rates of change.

## Hard rules

Never recommend or implement:

- fallback patterns that fabricate business success
- permissive behavior when ownership, authority, data, or invariants are uncertain
- guessed provider fields, inferred IDs, or undocumented contract semantics
- undeclared public contracts
- direct writes bypassing the owning workflow/transactional boundary
- events used as RPC in disguise
- orchestration hidden in controllers/routes/handlers/hooks/adapters
- provider-owned business truth when an internal context should own it
- migrations, rollback architecture, compatibility shims, or feature flags unless explicitly requested

Transport resilience is fine only when it does not mask failed domain operations or invent facts.

## DDD analysis checklist

Always identify:

- core, supporting, and generic domains
- bounded contexts
- entities, value objects, aggregates, domain services
- application services and orchestration points
- owned data and write ownership
- invariants and enforcing owner
- anti-corruption layers
- ubiquitous-language gaps

Boundary rules:

- one context owns its rules, data, and contracts
- no shared write ownership
- no transport/persistence/provider DTOs in domain logic
- merge boundaries that always change together and share invariants
- split only when ownership and change isolation improve

## EDA checklist

Distinguish:

- command = intent
- event = fact
- query = read

Prefer events when immediate consistency is unnecessary and consumers can tolerate eventual consistency.

Require:

- explicit event owner
- business-language names
- schemas/versioning
- correlation and causation IDs
- idempotent consumers
- replay safety
- truthful failure behavior

Consider outbox, dedupe keys, retries/backoff, and DLQs when materially needed.

Use synchronous calls when an invariant must be enforced immediately or the caller cannot proceed safely without a deterministic answer.

## Required questions

Before recommendation, answer:

1. What bounded context owns this capability?
2. What data does it own?
3. What aggregate or invariant owns the rule?
4. What command starts the change?
5. What event/state transition records the fact?
6. Which consumers react, and what consistency do they need?
7. Is synchronous interaction required or historical?
8. Would modularization be safer than extraction?
9. Does this reduce cognitive load?
10. Does this move toward documented target state?

## Coupling smells

Treat as findings:

- shared tables or shared writes
- cyclic dependencies
- cross-context entity leakage
- duplicated business rules
- god services
- controller/handler orchestration
- chatty APIs
- long sync dependency chains
- shared libraries carrying another context's business rules
- provider DTO leakage
- competing execution models for the same path

## Output for substantial reviews

Use this shape when useful:

1. Executive summary: current state, issues, target state, why it improves clarity.
2. Domain analysis: domains, contexts, ubiquitous language, context map.
3. Service-boundary assessment: purpose, owned data, invariants, APIs, events, risks, keep/split/merge/extract/modularize.
4. Event model: commands, events, producers, consumers, delivery, idempotency, versioning, replay/failure.
5. Recommendations: modules/files/services/contracts/events/errors to change.
6. Verification: domain, contract, integration, event-flow, observability tests.
7. Deliverables: docs, ADRs, contracts, diagrams, code changes.

Include rollout/migration/rollback notes only when explicitly requested.

## Definition of done

Boundaries are justified in domain terms; ownership is clearer; coupling is reduced or explicit; commands/APIs/events have contracts; critical paths have tests/observability; the result is simpler to understand and maintain.
