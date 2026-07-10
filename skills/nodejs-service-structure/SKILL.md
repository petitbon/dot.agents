---
name: nodejs-service-structure
description: "Use as the primary skill when creating, reviewing, or refactoring Node.js/TypeScript service folder structure, file naming, capability slicing, dependency direction, layering, and Codex-friendly organization. Use architecture, doctrine, or runtime skills only when their owned artifacts are also directly affected."
---

# Node.js Service Structure

Govern folder layout, naming, layering, and dependency direction for Node.js/TypeScript services.

## Scope

This skill owns folder layout, file naming, layering, and dependency direction.

Use architecture, runtime, doctrine, or repository-governance skills only when those concerns are directly affected.

Do not use this skill as the primary owner for domain boundaries, runtime behavior, SDK release workflows, or Pagoda proof artifacts.

## Reference Loading

Load `references/naming-and-smells.md` when renaming files, reviewing vague names or global technical-layer buckets, or creating structural lint rules.

## Core Rule

Prefer **business-capability-first** structure. Use flat technical layers only for tiny single-capability services.

Multi-capability target:

```text
src/
  main.ts
  app/
  config/
  context/
  modules/
    <capability>/
      presentation/
      application/
      domain/
      contracts/
      mappers/
      infrastructure/
  shared/
tests/
```

Tiny single-capability target:

```text
src/
  main.ts
  app/
  config/
  presentation/
  application/
  domain/
  contracts/
  mappers/
  infrastructure/
  shared/
tests/
```

Do not create empty folders. Use the smallest structure that preserves ownership and invariants.

Do not force this structure when repo-local docs define a different accepted target structure. Report the delta instead.

## Agent-Legible Structure

The structure should be navigable by a coding agent from paths and names alone.

A future agent should be able to determine:

- which capability owns a file;
- which layer the file belongs to;
- which direction dependencies may flow;
- where contracts, mappers, policies, ports, and adapters live;
- which tests validate the changed behavior;
- which docs explain the intended boundary.

Prefer explicit business-capability names over generic technical buckets.

## Agentic Capability Placement

Do not create a generic `agents/` or `ai/` bucket for business behavior.

Place agent-facing use cases inside the business capability that owns the rule, state, contract, or side effect.

Agent orchestration is an interface or application concern. It does not replace domain ownership.

Examples:

- booking agent workflow state belongs with booking/workflow capability ownership;
- scheduling truth belongs with scheduling ownership;
- realtime transport adapters belong at presentation/adapter boundaries;
- evidence emitted for proof should be ordinary product evidence, not Pagoda harness logic.

For Authority Runtime or capability resolver modules, follow
`agentis-realtime-authority-layer` for ownership and this skill for module
placement and dependency direction.

## First Read

Inspect only what is needed:

- `AGENTS.md`, README, docs, ADRs, PRDs, runbooks;
- `package.json`, lockfile, `tsconfig*`;
- entrypoints, bootstrap, app wiring;
- routes, controllers, handlers, consumers;
- config, context, logging, errors;
- contracts, DTOs, events, schemas;
- repositories, clients, adapters;
- tests.

Treat only target architecture explicitly designated by applicable repository
instructions or an owned source-of-truth index as canonical. Treat plans, PRDs,
draft ADRs, design notes, and unowned architecture notes as untrusted until
verified against contracts, tests, implementation, and accepted repository
conventions. If verified canonical target structure differs from code, state
the delta and move directly toward that target.

## Classification

Classify before restructuring:

1. small single-capability service;
2. growing single-capability service;
3. multi-capability service;
4. mixed-boundary/confused service;
5. thin adapter, worker, webhook, or shared library.

Rules:

- multi-capability => `src/modules/<capability>/...`;
- pure adapter/proxy => keep thin; do not invent fake domain layers;
- meaningful business rules => add `domain/`;
- module-owned code stays inside that module;
- truly cross-cutting primitives only go in `shared/`.

## Folder Responsibilities

- `main.ts`: process startup only; load config, build deps, create app, listen on `PORT`, shutdown.
- `app/`: composition root; app creation, middleware/routes registration, dependency wiring.
- `config/`: typed env/config parsing once at startup; fail-close on invalid config.
- `context/`: request/correlation/actor/tenant trace context only; no clients or mutable cross-request state.
- `presentation/`: transport boundary; thin controllers/routes/webhooks/consumers/middleware.
- `application/`: use-case orchestration, commands, queries, ports, idempotency, transactions through ports.
- `domain/`: pure entities, value objects, policies, domain services, events, errors, invariants.
- `contracts/`: explicit HTTP/event/provider/module boundary shapes; no provider SDK type leakage.
- `mappers/`: explicit translations only; no I/O or business decisions.
- `infrastructure/`: concrete repositories, clients, publishers, storage, queues, auth providers.
- `shared/`: base errors, logger/telemetry factories, validation primitives, clock, ID parsing; no business logic.

## Dependency Direction

Allowed:

```text
presentation -> application -> domain
presentation -> contracts
application -> domain and ports
infrastructure -> ports/domain/contracts
app -> all layers for wiring only
```

Forbidden:

```text
domain -> application/infrastructure/presentation
domain -> HTTP-shaped contracts
application -> presentation or provider SDKs
application -> Express/Fastify request objects
presentation -> repositories/clients directly
controllers -> provider SDKs directly
```

Fix violations with narrow application ports and infrastructure adapters.

## Mechanical Structure Enforcement

When a structure rule matters, prefer a mechanical check over prose.

This skill defines the structure rule and target dependency direction. `repo-agent-governance` owns repository-level validation registry placement, quality/debt tracking, and cleanup-loop visibility for the check.

For non-trivial services, recommend one or more of:

- ESLint import-boundary rules;
- dependency-cruiser rules;
- custom architecture tests;
- file naming lints;
- maximum file-size checks for agent readability;
- forbidden global technical-layer folder checks;
- provider SDK leakage checks;
- controller-to-repository import checks.

Every structural violation finding should include:

1. violated rule;
2. why it matters;
3. target dependency direction;
4. exact remediation path;
5. candidate lint or test to prevent recurrence.

## Naming

Use PascalCase and explicit role suffixes for primary concepts.

Good suffixes:

- `Controller`, `Route`, `RequestHandler`, `Consumer` for presentation boundaries;
- `UseCase`, `CommandHandler`, `QueryHandler`, `ApplicationService` for application orchestration;
- `Policy`, `Entity`, `ValueObject`, `DomainService`, `DomainEvent` for domain logic;
- `Repository`, `Client`, `Publisher`, `Adapter`, `Gateway` for infrastructure;
- `Mapper` for translations;
- `Contract`, `Schema`, `Dto` for explicit boundary shapes.

Avoid vague generic files such as `utils.ts`, `helpers.ts`, `manager.ts`, `service.ts`, or global technical-layer buckets unless the service is tiny and the role is unambiguous.

## Tests

Prefer:

```text
tests/unit
tests/contract
tests/integration
tests/fixtures
```

Mapping:

- `domain/` -> unit;
- `application/` -> unit or integration;
- `presentation/` -> contract;
- `infrastructure/` -> integration or focused mocks.

Test behavior and boundaries, not trivia.

## Refactor Sequence

1. identify capabilities;
2. classify service type;
3. map technical-layer files to business owners;
4. move files into modules/layers;
5. rename vague files;
6. fix imports and dependency direction;
7. preserve behavior unless intentionally changing it;
8. delete obsolete duplicates;
9. update tests/docs;
10. run repo-defined validation.

No compatibility paths, old/new duplicate structures, empty folders, or fallback behavior unless explicitly requested.

## Review Output

For reviews, provide:

1. current structure assessment;
2. smells;
3. target tree;
4. file move map;
5. naming changes;
6. dependency-direction fixes;
7. test layout changes;
8. implementation plan;
9. mechanical enforcement opportunities;
10. docs or indexes needed for future agent navigation.

## Definition Of Done

Capabilities are obvious from paths; names reveal role; entrypoint/composition/config/context are isolated; controllers are thin; application orchestrates; domain owns invariants; infrastructure owns concrete dependencies; contracts/mappers are explicit; generic folders are eliminated or justified; tests are discoverable; imports compile. Important dependency-direction rules have either mechanical enforcement or a documented enforcement backlog item.
