---
name: nodejs-microservice-structure
description: Use when creating, reviewing, or refactoring Node.js/TypeScript microservice folder structure, file naming, capability slicing, dependency direction, and Codex-friendly organization. Pair with ThePetitbonDoctrine for posture, ddd-eda-architecture for bounded-context ownership, and nodejs-microservice-best-practices for runtime/config/logging/testing/Cloud Run quality.
---

# Node.js Microservice Structure

Act as a senior TypeScript/Node.js microservice architect. This skill governs service folder structure, file naming, dependency direction, and Codex-friendly organization.

## Scope

Use for:

- new microservice structure
- folder/file refactors
- capability/module slicing
- controller/service/repository/DTO/mapper placement
- naming cleanup
- dependency-direction cleanup
- removing vague folders such as `utils`, `types`, `interfaces`, `services`, `lib`, or `common`

Do not use as the primary lens for:

- broad service-boundary design: use `ddd-eda-architecture`
- runtime/config/logging/testing/package hardening: use `nodejs-microservice-best-practices`
- implementation posture/fail-fast/SOLID defaults: use `ThePetitbonDoctrine`

## Core Rule

Prefer business-capability-first structure over technical-layer-first structure.

Use capability-first when the service has more than one meaningful business capability:

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

A flat technical-layer structure is acceptable only for very small, single-capability services:

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

## First Read

Before changing structure, inspect the smallest relevant set of:

- `AGENTS.md` files
- README/docs/ADRs/PRDs/runbooks
- `package.json`, lockfile, `tsconfig*`
- entrypoints and app bootstrap
- routes/controllers/handlers/consumers
- config/context/logging/error helpers
- contracts/DTOs/events/schemas
- repositories/clients/provider adapters
- tests

If docs define a target architecture, treat them as canonical. If code differs, state the delta and move toward the target state.

## Structure Decision

Classify the service:

1. small single-capability service
2. growing single-capability service
3. multi-capability service
4. mixed-boundary/confused service
5. thin adapter/worker/webhook receiver/shared library

Rules:

- multi-capability => `src/modules/<capability>/...`
- single-capability => flat layered structure is acceptable
- meaningful business rules => add `domain/`
- pure adapter/proxy => keep thin; do not invent fake domain layers
- capability used by one module => keep inside that module
- cross-cutting primitive only => `shared/`

## Folder Responsibilities

### `main.ts`

Process entrypoint only: load config, build dependencies, create app, listen on `PORT`, register shutdown, log startup.

Never put routes, business logic, provider calls, request state, database calls, or inline env parsing here.

### `app/`

Composition root: create app, register middleware/routes, wire dependencies, register shutdown.

No business rules, persistence mapping, provider logic, or domain decisions.

Preferred files:

```text
createApp.ts
createDependencies.ts
registerShutdownHandlers.ts
```

### `config/`

Typed startup config only.

Parse env once, validate required values, fail startup on invalid config, expose immutable typed config.

Preferred files:

```text
Config.ts
ConfigSchema.ts
loadConfig.ts
```

### `context/`

Execution context only: correlation ID, request ID, causation ID, actor/principal, tenant/business/location IDs, trace IDs.

No mutable cross-request state or SDK clients.

### `modules/<capability>/`

Owns one business capability.

Good names: `booking`, `availability`, `call-session`, `transcript`, `voice-runtime`, `webhook-ingestion`, `salon-config`, `revenue-ops`.

Bad names: `controllers`, `services`, `repositories`, `types`, `utils`, `helpers`, `common`, `core`, `lib`.

Use only needed subfolders:

```text
presentation/
application/
domain/
contracts/
mappers/
infrastructure/
```

### `presentation/`

Transport boundary: controllers, routes, webhooks, event consumers, middleware, request parsing, response mapping, boundary validation, request context creation.

Must be thin. No business policy, direct repository access, provider SDK calls, or orchestration beyond calling application services.

### `application/`

Use-case orchestration: commands, queries, application services, ports, idempotency flow, event publishing through ports, repository/client calls through interfaces.

No Express/Fastify objects, provider SDK objects, raw env access, concrete database SDK details, or HTTP response construction.

### `domain/`

Pure business logic: entities, aggregates, value objects, policies, domain services, domain errors, domain events, invariants.

Must not import framework, transport, persistence, provider SDK, logging implementation, or config loader modules.

### `contracts/`

Boundary shapes: HTTP contracts, event contracts, provider payload contracts, command/query contracts that cross module or process boundaries.

Contracts must be explicit and must not import provider SDK types.

### `mappers/`

Explicit translations only: contract -> command, domain -> response, persistence -> domain, provider payload -> internal shape, domain event -> event contract.

No business decisions, I/O, hidden validation, persistence, or provider calls.

### `infrastructure/`

Concrete adapters: repositories, external HTTP clients, provider SDK wrappers, event publishers, storage, queues, auth providers.

Implements application/domain ports. Must not own domain decisions or leak SDK models into application/domain layers.

### `shared/`

Only true cross-cutting primitives: base errors, logger factory, telemetry factory, validation primitives, clock/time abstraction, ID parsing.

No business rules, provider logic, persistence models, module-owned events, vague utilities, or mutable state.

## Dependency Direction

Allowed:

```text
presentation -> application -> domain
presentation -> contracts
application -> domain
application -> ports
infrastructure -> ports/domain contracts
app -> all layers for wiring only
```

Forbidden:

```text
domain -> application
domain -> infrastructure
domain -> presentation
application -> presentation
application -> concrete provider SDKs
application -> Express/Fastify request objects
presentation -> repositories directly
controllers -> provider SDKs directly
domain -> HTTP-shaped contracts
```

Fix violations with narrow ports in `application/` and concrete adapters in `infrastructure/`.

## Naming

Use PascalCase for files exporting a primary named concept.

Required suffixes:

```text
Controller
Routes
Middleware
ApplicationService
Command
Query
Ports
Contract
Dto
Mapper
Repository
Client
Publisher
Consumer
Policy
DomainService
Event
Error
Type
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
BookingResponseDto.ts
BookingContractMapper.ts
FirestoreBookingRepository.ts
SchedulingHttpClient.ts
PubSubEventPublisher.ts
CallSessionEventConsumer.ts
BookingPolicy.ts
BookingConfirmedEvent.ts
BookingConflictError.ts
```

Avoid vague names:

```text
utils.ts
helpers.ts
common.ts
types.ts
interfaces.ts
service.ts
manager.ts
processor.ts
handler.ts
misc.ts
shared.ts
```

If using `Handler`, qualify it precisely: `InboundCallWebhookHandler.ts`, `BookingCommandHandler.ts`.

Use `index.ts` only for intentional module entrypoints. Avoid broad barrels that hide dependency direction.

## Technical-Layer Smells

Treat global folders like these as smells unless the service is tiny:

```text
src/controllers/
src/services/
src/repositories/
src/dtos/
src/types/
src/interfaces/
src/exceptions/
src/enums/
src/mappers/
src/middlewares/
```

Preferred replacements:

```text
exceptions/ -> errors/
interfaces/ -> contracts/ or application/*Ports.ts
services/ -> application/ or domain/
types/ -> contracts/ or named type files near owner
enums/ -> domain value objects or named constants near owner
middlewares/ -> app/ or module presentation/
repositories/ -> infrastructure/
```

## Classification Rules

### Service files

If `BookingService.ts` exists, classify it:

- use-case orchestration => `CreateBookingApplicationService.ts`
- pure business policy => `BookingPolicy.ts` or `BookingDomainService.ts`
- external dependency wrapper => `BookingClient.ts`, `FirestoreBookingRepository.ts`, or `EventPublisher.ts` in `infrastructure/`

### Interfaces

Avoid global `interfaces/`.

Use:

- `contracts/` for boundary shapes
- `application/<Capability>Ports.ts` for dependency inversion ports

Prefer precise names: `BookingRepositoryPort`, `SchedulingClientPort`, `EventPublisherPort`.

### DTOs, contracts, commands, queries, events

Use precise concepts:

- `Contract`: crosses process/module/HTTP/event/provider boundary
- `Dto`: internal transfer shape only when repo convention requires it
- `Command`: intent to change state
- `Query`: intent to read state
- `Event`: fact that occurred

Prefer:

```text
CreateBookingRequestContract.ts
CreateBookingCommand.ts
FindAvailabilityQuery.ts
BookingConfirmedEventContract.ts
```

Avoid:

```text
BookingDto.ts
BookingTypes.ts
IBooking.ts
BookingInterface.ts
```

### Errors

Prefer `errors/` over `exceptions/` unless repo convention requires otherwise.

Domain errors live near their owner:

```text
src/modules/booking/domain/BookingConflictError.ts
```

Shared base errors may live in:

```text
src/shared/errors/AppError.ts
```

### Enums

Avoid global `enums/`.

Keep value sets near their domain concept:

```text
src/modules/booking/domain/BookingStatus.ts
src/modules/call-session/domain/CallSessionState.ts
```

Prefer value objects or literal unions when they better express invariants.

### Repositories

Concrete repositories live in `infrastructure/`.

Repository ports live in `application/*Ports.ts` unless the domain truly owns the abstraction.

Application services depend on ports, not concrete repositories.

### Middleware

Global middleware: `app/` or `shared/`.

Capability-specific middleware: `modules/<capability>/presentation/`.

Do not mix unrelated middleware in a global dumping folder.

## Tests

Prefer tests outside `src/` unless repo convention requires co-location:

```text
tests/
  unit/
  contract/
  integration/
  fixtures/
```

Mapping:

```text
domain/         -> tests/unit/
application/    -> tests/unit/ or tests/integration/
presentation/   -> tests/contract/
infrastructure/ -> tests/integration/ or focused mocks
```

Test behavior and boundaries, not internal trivia.

## Codex-Friendliness Checklist

A good structure lets a future Codex task identify the right files from the prompt alone.

Require:

- one primary responsibility per file
- paths reveal ownership
- suffixes reveal role
- no generic dumping grounds
- no hidden side effects on import
- no ambient clients imported deep in domain/application
- no business logic in controllers
- no provider SDK types in domain/application
- no broad barrels hiding dependencies
- tests map clearly to capabilities/layers

## Refactor Sequence

When restructuring:

1. identify capabilities
2. classify current service size/type
3. map technical-layer files to business owners
4. move files under capability modules when needed
5. rename vague files
6. fix imports
7. preserve behavior unless explicitly changing it
8. delete obsolete duplicates
9. update tests
10. update README or service-local structure docs

No compatibility paths, duplicate old/new structures, or empty folders unless explicitly required.

## Review Output

For structure reviews, provide:

1. current structure assessment
2. structure smells
3. target tree
4. file move map
5. naming changes
6. dependency-direction changes
7. test layout changes
8. implementation plan

## Implementation Output

For implemented refactors, finish with:

1. moved/renamed files
2. deleted obsolete files
3. dependency-direction improvements
4. commands run
5. typecheck result
6. test result
7. lint result, if available
8. remaining follow-up only if necessary

Do not claim success for commands not run.

## Definition Of Done

Done means:

- capabilities are obvious from paths
- technical layers are inside capability modules when appropriate
- entrypoint and composition are separate
- config/context are isolated
- controllers/routes are thin
- application owns orchestration
- domain owns invariants
- infrastructure owns concrete dependencies
- contracts and mappers are explicit
- generic folders are eliminated or justified
- file names reveal responsibility
- tests are discoverable
- imports compile
- behavior is preserved unless intentionally changed
