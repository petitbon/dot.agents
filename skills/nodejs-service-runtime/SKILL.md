---
name: nodejs-service-runtime
description: "Use for Node.js/TS runtime, handlers, config, errors, telemetry, dependencies, and tests. Architecture, folders, and SDK releases have separate owners."
---

# Node.js Service Runtime

Use this skill for Node.js/TypeScript service-internal correctness and
operability.

## Routing

- Use `domain-event-architecture` for broad ownership and service boundaries.
- Use `nodejs-service-structure` for folder taxonomy and dependency direction.
- Use `sdk-release-consumer-bump` for release publishing and consumer bumps.
- Use `agentis-realtime-authority-layer` for semantic authority-runtime rules;
  this skill owns their safe Node runtime implementation.
- Pair another specialized skill only when its owned artifact also changes.

## Reference Loading

- Load `references/implementation-runtime-rules.md` for package hygiene,
  bootstrap/config, boundary handling, errors, concurrency, delegated
  operations, or data I/O.
- Load `references/observability-and-cloud-run.md` for logs, metrics, traces,
  readiness, replay evidence, or Cloud Run posture.
- Load `references/testing-and-review.md` when adding tests, reviewing runtime
  quality, or preparing validation evidence.

## First Read

Inspect the applicable `AGENTS.md` first. Then load only the manifest/lockfile,
entrypoints, README/runbook/deploy source, affected transport/application
modules, configuration/telemetry helpers, and boundary tests needed by the
task. Discover actual commands and do not assume framework or package manager.

## Service Posture

Optimize for stateless request handling, deterministic startup, explicit
dependency wiring, thin transports, isolated application/domain logic,
explicit I/O contracts, fail-close validation/authorization, and observable
failure. Prefer deleting accidental complexity over adding abstractions.

## Non-Negotiable Runtime Rules

- Parse and validate input at boundaries; reject invalid, unauthorized, or
  ambiguous requests.
- Keep transport handlers thin, orchestration in application services, and
  provider DTOs inside adapters.
- Parse configuration once, fail startup on invalid required values, construct
  dependencies once, and handle owned resource shutdown.
- Use explicit error categories and transport-safe mappings without swallowing
  failures; log unexpected failures once with correlation context.
- Bound concurrency, retries, polling, backoff, and outbound timeouts. Await
  deliberately and make retryable effects idempotent.
- Do not use process memory, background promises, provider payloads, or direct
  owner-bypassing writes as correctness mechanisms.
- Keep runtime behavior observable through stable structured events,
  correlation IDs, truthful readiness, and focused failure-path tests.

## Definition Of Done

The service starts deterministically, validates fail-close, wires dependencies
explicitly, exposes structured errors and observability, avoids hidden
process-memory correctness, handles retry/idempotency safely, and has focused
tests for changed behavior and failure paths.
