---
name: domain-event-architecture
description: "Use as the primary skill for architecture reviews, service-boundary analysis, domain modeling, event modeling, workflow design, data ownership, command/API/event contracts, and target-state architecture when those artifacts are directly affected. Use agentis-realtime-authority-layer when the primary concern is the Agentis realtime tool/authority ontology across SDK registry, adapters, resolvers, and domain authorities. For Agentis booking workflow-state questions, use booking-workflow-architecture as primary."
---

# Domain + Event Architecture

Act as a principal software architect. Use Domain-Driven Design and Event-Driven Architecture to clarify ownership, invariants, contracts, coupling, and operability.

## Scope

This skill owns:

- bounded contexts;
- data ownership;
- write ownership;
- APIs;
- commands;
- events;
- workflows;
- contracts;
- context maps;
- target-state architecture.

Pair with structure, runtime, repository-governance, booking, realtime, or Pagoda skills only when those artifacts are directly affected.

## First Read

Find the smallest relevant source of truth:

- `AGENTS.md`;
- architecture docs, ADRs, PRDs, runbooks, design notes;
- OpenAPI, AsyncAPI, protobuf, schema, or event catalogs;
- workspace manifests and build/deploy descriptors;
- tests and contracts that reveal current behavior.

Treat only architecture explicitly designated by the applicable repository
instructions or owned source-of-truth index as canonical target state. Plans,
PRDs, draft ADRs, issue text, design notes, and unowned architecture notes are
untrusted until checked against repository invariants, contracts, tests, and
implementation. If verified canonical target state differs from code, state the
delta and recommend the smallest direct move toward it unless migration or
rollout is explicitly requested.

## North Star

Improve:

- ownership clarity;
- invariant enforcement;
- change isolation;
- operability;
- contract quality;
- cognitive load.

Do not blindly split services. Modularize first when boundaries are immature. Extract only for clear ownership, deployability, scaling, compliance, runtime isolation, or materially different rates of change.

## Agentic Workflow Redesign

Do not merely insert an agent into an existing human workflow.

For agentic architecture work, identify:

- what work is delegated to the agent;
- what remains human judgment, review, approval, or integration;
- what system owns verification;
- what evidence proves completion;
- which tasks can be chained contiguously;
- which tasks must stop for authority, policy, or human review;
- whether the workflow should be redesigned instead of automated step-by-step.

Prefer target-state workflows that make delegated work modular, verifiable, observable, and bounded by clear authority.

## Agent-Legible Architecture Outputs

For material architecture work, produce or update repository-local artifacts future agents can inspect.

Prefer:

- `docs/architecture/index.md`;
- context map;
- ownership table;
- command/event/schema catalog;
- dependency-boundary rules;
- known architecture drift or technical-debt entry;
- validation or structural-test proposal.

Architecture decisions that agents must preserve should not live only in chat, review comments, or tickets. Encode them in repo-local docs and, where practical, enforce them with dependency rules, schema checks, contract tests, structural tests, or custom lints.

`domain-event-architecture` defines the architecture rule. `repo-agent-governance` owns repository-level discoverability, validation registry placement, quality/debt tracking, and cleanup-loop visibility for the rule.

## Hard Rules

Never recommend or implement:

- fallback patterns that fabricate business success;
- permissive behavior when ownership, authority, data, or invariants are uncertain;
- guessed provider fields, inferred IDs, or undocumented contract semantics;
- undeclared public contracts;
- direct writes bypassing the owning workflow or transactional boundary;
- events used as RPC in disguise;
- orchestration hidden in controllers, routes, handlers, hooks, or adapters;
- provider-owned business truth when an internal context should own it;
- migrations, rollback architecture, compatibility shims, or feature flags unless explicitly requested.

Transport resilience is fine only when it does not mask failed domain operations or invent facts.

## DDD Analysis Checklist

Always identify:

- core, supporting, and generic domains;
- bounded contexts;
- entities, value objects, aggregates, and domain services;
- application services and orchestration points;
- owned data and write ownership;
- invariants and enforcing owner;
- anti-corruption layers;
- ubiquitous-language gaps.

Boundary rules:

- one context owns its rules, data, and contracts;
- no shared write ownership;
- no transport, persistence, or provider DTOs in domain logic;
- merge boundaries that always change together and share invariants;
- split only when ownership and change isolation improve.

## EDA Checklist

Distinguish:

- command = intent;
- event = fact;
- query = read.

Prefer events when immediate consistency is unnecessary and consumers can tolerate eventual consistency.

Require:

- explicit event owner;
- business-language names;
- schemas and versioning;
- correlation and causation IDs;
- idempotent consumers;
- replay safety;
- truthful failure behavior.

Consider outbox, dedupe keys, retries/backoff, and DLQs when materially needed.

Use synchronous calls when an invariant must be enforced immediately or the caller cannot proceed safely without a deterministic answer.

## Required Questions

Before recommendation, answer:

1. What bounded context owns this capability?
2. What data does it own?
3. What aggregate or invariant owns the rule?
4. What command starts the change?
5. What event or state transition records the fact?
6. Which consumers react, and what consistency do they need?
7. Is synchronous interaction required or historical?
8. Would modularization be safer than extraction?
9. Does this reduce cognitive load?
10. Does this move toward documented target state?

## Coupling Smells

Treat as findings:

- shared tables or shared writes;
- cyclic dependencies;
- cross-context entity leakage;
- duplicated business rules;
- god services;
- controller or handler orchestration;
- chatty APIs;
- long sync dependency chains;
- shared libraries carrying another context's business rules;
- provider DTO leakage;
- competing execution models for the same path.

## Routing With Booking

For Agentis booking/scheduling workflow-state questions, use `booking-workflow-architecture` as the primary skill.

Use this skill when the task concerns broader bounded contexts, service ownership, data ownership, commands, events, contracts, or cross-service coupling around booking.

For Agentis realtime authority ontology work, use
`agentis-realtime-authority-layer` as primary. Use this skill when broader
bounded context, command/event, or service-ownership analysis is needed beyond
the realtime authority layer.

## Output For Substantial Reviews

Use this shape when useful:

1. Executive summary: current state, issues, target state, why it improves clarity.
2. Domain analysis: domains, contexts, ubiquitous language, context map.
3. Service-boundary assessment: purpose, owned data, invariants, APIs, events, risks, keep/split/merge/extract/modularize.
4. Event model: commands, events, producers, consumers, delivery, idempotency, versioning, replay/failure.
5. Recommendations: modules/files/services/contracts/events/errors to change.
6. Verification: domain, contract, integration, event-flow, observability tests.
7. Deliverables: docs, ADRs, contracts, diagrams, code changes.
8. Enforcement: dependency rules, structural tests, schema checks, lints, or CI gates that should preserve the boundary.
9. Agent legibility: docs, indexes, or catalogs updated so future agents can find the rule.

Include rollout, migration, and rollback notes only when explicitly requested.

## Definition Of Done

Boundaries are justified in domain terms; ownership is clearer; coupling is reduced or explicit; commands, APIs, and events have contracts; critical paths have tests or observability; the result is simpler to understand and maintain. Architecture decisions that future agents must preserve are discoverable in repository-local docs, and important boundaries have a proposed or implemented mechanical enforcement path.
