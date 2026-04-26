---
name: nodejs-microservice-best-practices
description: Use for Node.js/TypeScript microservice runtime quality: service bootstrap, handlers, adapters, configuration, dependency handling, validation, errors, logging, metrics, tracing, Cloud Run posture, package hygiene, and tests. Do not use as the primary skill for architecture boundaries or folder structure.
---

# Node.js Microservice Best Practices

Use this for service-internal correctness and operability.

## Pairing and scope

Pair with:

- `ThePetitbonDoctrine` for green-field, fail-close, fail-hard posture
- `nodejs-microservice-structure` for folders/naming/dependency direction
- `ddd-eda-architecture` for ownership, contracts, and event flows

This skill owns runtime quality, not broad architecture or folder taxonomy.

## First read

Inspect the smallest relevant set:

- `AGENTS.md`
- service manifest, lockfile, entrypoints
- README/runbooks/deploy workflows
- route/controller/handler/worker/consumer entry files
- config/bootstrap/error/logging/auth/telemetry helpers
- tests at the service boundary

Discover actual repo commands. Do not assume framework, package manager, or validation scripts.

## Service posture

Optimize for:

- stateless request handling
- deterministic startup
- explicit dependency wiring
- thin transport adapters
- isolated application/domain logic
- explicit contracts for I/O
- fail-close validation and authorization
- structured observable failures

Prefer deleting accidental complexity over adding abstractions.

## Package and repo hygiene

- keep generated output and dependencies out of VCS unless repo requires them
- start from the current official Node `.gitignore`; add only necessary repo-specific paths
- untrack ignored files already committed
- keep runtime deps in `dependencies`; tooling in `devDependencies`
- remove unused deps
- use repo package manager and lockfile conventions
- for John's Agentis repos, prefer `yarn` unless repo-local docs say otherwise
- use `npm view <package> version` only for registry metadata checks, not installs
- verify latest stable package versions from registry when upgrading
- avoid prerelease/deprecated versions unless requested
- inspect changelogs when crossing majors

Repo-standard defaults when no deeper doc overrides:

- `vitest` for tests
- `pino` for structured logging
- `pino-http` for HTTP/webhook request logging
- `@google-cloud/pino-logging-gcp-config` when Cloud Run/GCP structured logging is required

## Bootstrap and config

- keep `main`/entry files to startup, wiring, listen, shutdown
- parse env once into immutable typed config
- fail startup on missing/invalid config, URLs, ports, credentials, policy settings, or required dependency metadata
- build dependencies once and inject them
- avoid global mutable clients imported deep in application/domain logic
- handle `SIGTERM`/`SIGINT` for owned long-lived resources

## Boundaries

For HTTP/webhook/worker/event boundaries:

- parse and validate input at the boundary
- reject invalid/unauthorized/ambiguous requests fail-close
- keep controllers, handlers, routes, and consumers thin
- move orchestration into application services
- keep provider request/response details inside adapters
- do not leak provider SDK models into application/domain layers

## Errors

Use explicit error types or normalized error shapes.

Distinguish:

- validation errors
- authorization/policy errors
- domain errors
- dependency failures
- programmer bugs

Log unexpected failures once at the boundary with correlation context. Map internal errors to transport-safe responses without hiding failure.

## Async and concurrency

- await deliberately; no untracked hot-path promises
- parallelize only independent calls
- bound fan-out, retries, polling, and backoff
- make retryable handlers idempotent
- avoid in-memory coordination for correctness
- use timeouts/cancellation for outbound calls when supported

## Data and I/O

- keep request DTOs separate from persistence/provider models
- normalize outbound calls in dedicated clients
- keep serialization/mapping explicit
- do not leak provider payloads into domain logic
- avoid direct writes that bypass the owning application/domain boundary

## Logging, metrics, tracing

- emit structured logs with stable event names
- include correlation/request/session/entity IDs where relevant
- log factual, actionable messages
- avoid duplicate logs at every layer
- readiness checks must reflect real readiness, not placeholder success

## Cloud Run posture

When deployed on Cloud Run:

- listen on configured `PORT`
- remain stateless across requests
- treat in-memory state only as opportunistic cache
- prefer direct `node ...` container startup when service owns entrypoint
- minimize cold-start work and dependencies
- lazy-load heavy/infrequent modules when materially helpful
- align app timeouts with Cloud Run timeout behavior
- avoid background work after response under request-based billing
- make background execution explicit if instance-based billing or another model is required
- delete temp files promptly
- choose CPU/memory/concurrency/min/max instances deliberately
- set max instances with downstream capacity in mind

## Tests

For changed behavior, add or update:

- unit tests for pure logic
- contract/app tests for transport boundaries
- focused mocks or integration tests for external-client seams
- at least one happy path and one explicit failure path

Prefer observable behavior over internal implementation details.

## Review output

Organize findings by:

1. correctness and invariants
2. fail-close/failure semantics/dependencies
3. module and boundary clarity
4. observability and operability
5. tests

For implementation summaries, report commands actually run and their results. Do not claim validation not performed.
