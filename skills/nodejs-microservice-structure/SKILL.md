---
name: nodejs-microservice-structure
description: Use when creating, reviewing, or refactoring Node.js/TypeScript microservice folder structure, file naming, capability slicing, dependency direction, and Codex-friendly organization. Pair with ThePetitbonDoctrine, ddd-eda-architecture, and nodejs-microservice-best-practices as needed.
---

# Node.js Microservice Structure

Govern folder layout, naming, layering, and dependency direction for Node.js/TypeScript microservices.

## Precedence

- Doctrine/fail-close posture: `ThePetitbonDoctrine`.
- Bounded contexts/events: `ddd-eda-architecture`.
- Runtime/config/logging/testing/Cloud Run/packages: `nodejs-microservice-best-practices`.
- This skill owns structure and naming.

## Core rule

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

## First read

Inspect only what is needed:

- `AGENTS.md`, README/docs/ADRs/PRDs/runbooks
- `package.json`, lockfile, `tsconfig*`
- entrypoints/bootstrap/app wiring
- routes/controllers/handlers/consumers
- config/context/logging/errors
- contracts/DTOs/events/schemas
- repositories/clients/adapters
- tests

Treat documented target architecture as canonical. If code differs, state the delta and move directly toward the target state.

## Classification

Classify before restructuring:

1. small single-capability service
2. growing single-capability service
3. multi-capability service
4. mixed-boundary/confused service
5. thin adapter/worker/webhook/shared library

Rules:

- multi-capability => `src/modules/<capability>/...`
- pure adapter/proxy => keep thin; do not invent fake domain layers
- meaningful business rules => add `domain/`
- module-owned code stays inside that module
- truly cross-cutting primitives only go in `shared/`

## Folder responsibilities

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

## Dependency direction

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

## Naming

Use PascalCase for primary named concepts.

Required suffixes when applicable:

```text
Controller Routes Middleware ApplicationService Command Query Ports Contract Dto Mapper Repository Client Publisher Consumer Policy DomainService Event Error Type
```

Examples:

```text
BookingController.ts
BookingRoutes.ts
CreateBookingApplicationService.ts
CreateBookingCommand.ts
FindAvailabilityQuery.ts
BookingPorts.ts
CreateBookingRequestContract.ts
BookingContractMapper.ts
FirestoreBookingRepository.ts
SchedulingHttpClient.ts
BookingPolicy.ts
BookingConflictError.ts
```

Avoid vague names:

```text
utils.ts helpers.ts common.ts types.ts interfaces.ts service.ts manager.ts processor.ts handler.ts misc.ts shared.ts
```

Use `Handler` only when qualified, such as `InboundCallWebhookHandler.ts`. Use `index.ts` only for intentional module entrypoints; avoid broad barrels.

## Technical-layer smells

These global folders are smells unless the service is tiny:

```text
src/controllers src/services src/repositories src/dtos src/types src/interfaces src/exceptions src/enums src/mappers src/middlewares
```

Prefer:

- `exceptions/` -> `errors/`
- `interfaces/` -> `contracts/` or `application/*Ports.ts`
- `services/` -> `application/` or `domain/`
- `types/` -> named files near owner
- `enums/` -> domain value objects/literal unions near owner
- `repositories/` -> `infrastructure/`
- `middlewares/` -> `app/` or module `presentation/`

## Tests

Prefer:

```text
tests/unit
tests/contract
tests/integration
tests/fixtures
```

Mapping:

- `domain/` -> unit
- `application/` -> unit or integration
- `presentation/` -> contract
- `infrastructure/` -> integration or focused mocks

Test behavior and boundaries, not trivia.

## Refactor sequence

1. identify capabilities
2. classify service type
3. map technical-layer files to business owners
4. move files into modules/layers
5. rename vague files
6. fix imports and dependency direction
7. preserve behavior unless intentionally changing it
8. delete obsolete duplicates
9. update tests/docs
10. run repo-defined validation

No compatibility paths, old/new duplicate structures, empty folders, or fallback behavior unless explicitly requested.

## Review output

For reviews, provide:

1. current structure assessment
2. smells
3. target tree
4. file move map
5. naming changes
6. dependency-direction fixes
7. test layout changes
8. implementation plan

## Definition of done

Capabilities are obvious from paths; names reveal role; entrypoint/composition/config/context are isolated; controllers are thin; application orchestrates; domain owns invariants; infrastructure owns concrete dependencies; contracts/mappers are explicit; generic folders are eliminated or justified; tests are discoverable; imports compile.
