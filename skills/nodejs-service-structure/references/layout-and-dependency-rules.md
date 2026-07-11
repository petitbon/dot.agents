# Layout And Dependency Rules

Use this reference when classifying a Node.js service, choosing folder
responsibilities, or repairing dependency direction.

## Classification

Classify the repository as a small/growing single capability, multi-capability
service, mixed-boundary service, thin adapter/worker/webhook, or shared library.

- Multi-capability services use `src/modules/<capability>/...`.
- Pure adapters and proxies stay thin; do not invent fake domain layers.
- Meaningful business rules justify `domain/`.
- Module-owned code stays in its module.
- Only cross-cutting primitives belong in `shared/`.

## Folder Responsibilities

- `main.ts`: startup, listen, and shutdown only.
- `app/`: composition root and dependency wiring.
- `config/`: typed startup parsing and fail-close validation.
- `context/`: request/correlation/actor/tenant context, never mutable global
  clients.
- `presentation/`: thin routes, controllers, webhooks, consumers, middleware.
- `application/`: use cases, commands, queries, ports, idempotency, transaction
  orchestration.
- `domain/`: pure entities, values, policies, services, events, and invariants.
- `contracts/`: explicit boundary shapes without provider SDK leakage.
- `mappers/`: translation only; no I/O or business decisions.
- `infrastructure/`: repositories, clients, publishers, storage, queues, auth.
- `shared/`: base errors, telemetry factories, clocks, IDs, and validation
  primitives without business logic.

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
application -> presentation/provider SDK/request objects
presentation -> repositories or clients directly
controllers -> provider SDKs directly
```

Repair violations with narrow application ports and infrastructure adapters.
