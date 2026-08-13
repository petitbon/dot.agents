# Implementation Runtime Rules

Load this reference for package hygiene, bootstrap/config, boundaries, errors,
concurrency, delegated operations, or data I/O.

## Package And Repository Hygiene

- Keep generated output and dependencies out of VCS unless required.
- Start from the current official Node `.gitignore`; add only necessary local
  paths and untrack ignored files already committed.
- Keep runtime packages in `dependencies`, tooling in `devDependencies`, and
  remove unused packages.
- Follow the repository package manager and lockfile; Agentis defaults to Yarn.
- Use registry metadata checks without installing when verifying versions;
  avoid prerelease/deprecated versions unless requested and inspect changelogs
  across major upgrades.

Use `sdk-release-consumer-bump` for SDK release work. When no deeper local rule
overrides, Agentis defaults to `vitest`, `pino`, `pino-http`, and
`@google-cloud/pino-logging-gcp-config` for GCP structured logging.

## Bootstrap And Config

- Keep entry files to startup, wiring, listen, and shutdown.
- Parse environment once into immutable typed configuration.
- Fail startup on invalid config, URLs, ports, credentials, policy, or required
  dependency metadata.
- Build dependencies once and inject them; avoid deep global mutable clients.
- Handle `SIGTERM`/`SIGINT` for owned long-lived resources.

## Boundaries And Errors

Validate input at HTTP, webhook, worker, and event boundaries; reject invalid,
unauthorized, or ambiguous requests. Keep transports thin, orchestration in
application services, and provider payloads inside adapters.

Use explicit or normalized validation, authorization/policy, domain,
dependency, and programmer errors. Log unexpected failures once at the boundary
with correlation context and map them to transport-safe responses without
hiding failure.

## Async And Concurrency

- Await deliberately; do not leave untracked hot-path promises.
- Parallelize only independent calls.
- Bound fan-out, retries, polling, backoff, and outbound timeouts/cancellation.
- Make retryable handlers idempotent.
- Avoid in-memory coordination for correctness.

## Agentic Workload Readiness

Model delegated long-running work as explicit operations with IDs, progress,
correlation/causation, cancellation/timeouts, retry/idempotency rules, durable
evidence, review handoff, and terminal states. Do not hide it behind synchronous
handlers, unbounded promises, in-memory coordination, or vague success logs.

## Data And I/O

Keep request DTOs separate from persistence/provider models, outbound calls in
dedicated clients, and mapping explicit. Do not leak provider payloads into
domain logic or bypass the owning application/domain write boundary.
