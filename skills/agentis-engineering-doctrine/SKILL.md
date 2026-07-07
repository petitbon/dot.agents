---
name: agentis-engineering-doctrine
description: "Apply Agentis engineering doctrine when a task directly needs code-planning, implementation, or review posture: green-field target state, fail-close safety, fail-hard errors, SOLID boundaries, simplicity, idempotency, statelessness, control-stack smell detection, delegated-production discipline, and no fallback success. Do not use for pure copywriting, non-code analysis, or as a broad automatic companion to a more specific primary skill."
---

# Agentis Engineering Doctrine

Use this skill when the task directly needs Agentis engineering posture for code planning, implementation, or review.

## Core Rule

Build the clean target state directly. Do not create apparent progress by adding stopgaps, fallback success, compatibility detours, guessed facts, or unowned side effects.

## Non-Negotiable Defaults

1. **Green-field target state**: implement the clean end-state design first.
2. **No stopgap patches**: do not bypass target-state ownership with local workarounds, temporary forks, or narrow fixes that leave the real invariant broken.
3. **Fail-close**: when authority, data, config, validation, ownership, auth, policy, dependency health, or invariant status is uncertain, deny, reject, stop, or throw.
4. **Fail hard**: do not hide defects behind fallback success, empty results, degraded best-effort, swallowed exceptions, guessed data, or fabricated business outcomes.
5. **No transitional machinery unless requested**: no migrations, rollback paths, feature flags, compatibility shims, dual-read/write, bridge paths, or failover architecture unless explicitly requested.
6. **SOLID and explicit boundaries**: isolate domain logic from frameworks, transport, persistence, provider SDKs, and UI plumbing.
7. **Simplicity first**: prefer deletion, direct control flow, narrow APIs, fewer moving parts, and readable ownership.
8. **Idempotent and stateless by default**: repeated effective requests must not duplicate side effects; do not use hidden process memory for correctness.

## Agentic Delegation Contract

Treat Codex work as delegated production, not advice.

For any non-trivial delegated task, establish:

- requested outcome;
- allowed files, services, commands, and side effects;
- owning authority for facts and writes;
- non-goals and forbidden changes;
- validation commands or evidence required before claiming completion;
- review handoff artifacts for the human or next agent.

For Agentis realtime authority implementation plans, defer capability
ownership, registry, resolver, and finalization rules to
`agentis-realtime-authority-layer`.

The human role shifts toward delegation, supervision, verification, and integration. Make agent work reviewable, bounded, and evidence-backed.

Do not optimize for apparent productivity by skipping verification, inventing success, hiding uncertainty, or making broad unreviewable changes.

## Explicit Recoverable Failure

Recoverable failure is allowed when it is domain-approved and represented truthfully.

Fail-hard forbids fabricated success, swallowed errors, permissive continuation, and hidden fallback outcomes. It does not forbid a recovery path when:

- the failure is explicit;
- no restricted side effect occurred before authorization;
- authority state is updated;
- stale state is invalidated;
- retries are idempotent or duplicate-safe;
- the next attempt re-enters a valid governed path.

Examples of valid recoverable failures include booking slot conflicts, missing required information, validation errors, dependency timeouts with explicit retry states, and user-corrected input.

## Failure Semantics

Throw, reject, or propagate precise errors when:

- required data, config, credentials, dependencies, or metadata are missing or invalid;
- a caller lacks authority;
- a domain invariant is violated;
- an owner boundary is unclear;
- an external dependency cannot produce a trustworthy answer;
- a write cannot complete exactly as authorized;
- a result would require guessing business truth.

Translate low-level failures into domain errors at boundaries when useful, but preserve explicit failure semantics.

## Design Bias

- Prefer composition over inheritance.
- Depend on abstractions at domain/application boundaries.
- Keep business rules near the owning domain concept.
- Avoid repeated hot-path work when an indexed design is clearer.
- Treat bugs as possible boundary, invariant, or state-model debt.
- Make unsafe states unrepresentable where practical.
- Prefer one normal path with explicit preconditions over many arrival-history-specific branches.
- Prefer deletion over abstraction when deletion preserves the invariant.

## Control-Stack Smell

Treat escalating containment logic as evidence that the feature may be wrong.

When a runtime, realtime, voice, text, or agentic feature requires repeated layers of suppression, sentinel state, timing windows, phrase matching, duplicate filtering, cleanup branches, or special-case state to keep it coherent, do not default to adding another control layer.

Before adding more containment, explicitly propose one of:

- delete the feature;
- replace it with simpler product behavior;
- move it into a first-class shared contract;
- redesign it around the owning authority, state machine, or hard boundary.

Do not confuse this smell with legitimate boundary controls such as authentication, schema validation, authorization, confirmation, policy checks, idempotency, durable domain state machines, or explicit recoverable failure states. Those controls enforce invariants directly; control-stack smell appears when code exists mainly to keep a feature from getting out of hand.

## No Fallback Success

Never fabricate successful business outcomes.

Forbidden examples:

- returning fake availability when Scheduling is unavailable;
- treating a failed write as a completed write;
- swallowing validation failures and continuing;
- guessing provider IDs, appointment IDs, prices, durations, or auth context;
- converting dependency failure into empty success without an explicit domain rule;
- writing through a non-owning service because the owner path is inconvenient.

Transport resilience is fine only when it does not mask failed domain operations or invent facts.

## Recurring Issues

When a defect or review comment reveals a missing invariant, boundary, evidence, or validation rule:

1. fix the code at the correct owner;
2. use `repo-agent-governance` to promote recurring guidance into repository-local docs, tests, lints, schemas, harnesses, CI gates, scorecards, or debt tracking.

Do not leave repeated correctness rules as chat-only advice.

## Merge Gate Posture

Fast PRs are acceptable only when the evidence surface is strong.

Low-risk refactors may rely on structural checks and targeted tests. Behavior-changing work must pass relevant domain, contract, integration, runtime, or harness checks.

High-risk paths require stronger evidence and human review:

- identity;
- authorization;
- booking mutation;
- billing or payments;
- data loss;
- protected information;
- policy enforcement;
- governed workflow side effects.

Do not import a minimal-gate merge philosophy as the default. The default posture remains fail-close and fail-hard.

## Service Structure Posture

For backend folder and file layout, defer to `nodejs-service-structure`.

Doctrine-level service rules:

- domain/application logic must not live in controllers, routes, handlers, middleware, provider adapters, or repositories;
- public HTTP, webhook, event, and SDK contracts must be explicit;
- repositories, clients, auth, logging, telemetry, queues, and storage stay at infrastructure boundaries;
- use top-level `tests/` unless repo convention requires co-location;
- do not force large-service structure onto small services.

## Code Output Expectations

When planning or writing code:

- present the direct end-state solution first;
- call out explicit failure points and errors;
- avoid stopgaps, local workarounds, migrations, rollback paths, feature flags, compatibility shims, dual paths, and fallback success unless explicitly requested;
- justify material choices using invariants, SOLID boundaries, simplicity, idempotency, statelessness, and fail-close behavior;
- discover repo commands and conventions before editing;
- report validation commands actually run and their results;
- report validation not run rather than implying it passed.

## Definition of Done

The change implements the target-state owner path, preserves explicit boundaries, rejects uncertain authority, avoids fabricated success, prevents duplicate side effects, remains reviewable, and is backed by the strongest practical evidence for its risk level.
