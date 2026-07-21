---
name: nodejs-service-runtime
description: "Use as the primary skill for Node.js/TypeScript service-internal runtime quality when those artifacts are directly affected: service bootstrap, handlers, adapters, configuration, dependency handling, validation, errors, logging, metrics, tracing, Cloud Run posture, package hygiene, agentic workload readiness, and tests. Do not use as the primary skill for architecture boundaries, folder structure, SDK release publishing, or cross-service outcome ownership."
---

# Node.js Service Runtime

Use this for Node.js/TypeScript service-internal correctness and operability.

## Scope

This skill owns service-internal runtime quality, not broad architecture, folder taxonomy, repository governance, SDK release workflow, booking workflow architecture, or cross-service outcome ownership.

Pair with the relevant specialized skill only when those concerns are directly affected.

Use `agentis-realtime-authority-layer` for semantic authority-runtime rules.
This skill owns how a Node service implements those rules safely at runtime.

## First Read

Inspect the smallest relevant set:

- `AGENTS.md`;
- service manifest and lockfile;
- entrypoints;
- README, runbooks, deploy workflows;
- route, controller, handler, worker, consumer entry files;
- config, bootstrap, error, logging, auth, telemetry helpers;
- tests at the service boundary.

Discover actual repo commands. Do not assume framework, package manager, or validation scripts.

## Service Posture

Optimize for:

- stateless request handling;
- deterministic startup;
- explicit dependency wiring;
- thin transport adapters;
- isolated application/domain logic;
- explicit contracts for I/O;
- fail-close validation and authorization;
- structured observable failures.

Prefer deleting accidental complexity over adding abstractions.

## Package And Repo Hygiene

- keep generated output and dependencies out of VCS unless repo requires them;
- start from the current official Node `.gitignore`; add only necessary repo-specific paths;
- untrack ignored files already committed;
- keep runtime deps in `dependencies`; tooling in `devDependencies`;
- remove unused deps;
- use repo package manager and lockfile conventions;
- for Agentis repos, prefer `yarn` unless repo-local docs say otherwise;
- use `npm view <package> version` or package-manager equivalent only for registry metadata checks, not installs;
- verify latest stable package versions from registry when upgrading;
- avoid prerelease/deprecated versions unless requested;
- inspect changelogs when crossing majors.

Use `sdk-release-consumer-bump` for SDK publishing, semver release decisions, and downstream consumer propagation.

Repo-standard defaults when no deeper doc overrides:

- `vitest` for tests;
- `pino` for structured logging;
- `pino-http` for HTTP/webhook request logging;
- `@google-cloud/pino-logging-gcp-config` when Cloud Run/GCP structured logging is required.

## Bootstrap And Config

- keep `main`/entry files to startup, wiring, listen, shutdown;
- parse env once into immutable typed config;
- fail startup on missing/invalid config, URLs, ports, credentials, policy settings, or required dependency metadata;
- build dependencies once and inject them;
- avoid global mutable clients imported deep in application/domain logic;
- handle `SIGTERM`/`SIGINT` for owned long-lived resources.

## Boundaries

For HTTP, webhook, worker, and event boundaries:

- parse and validate input at the boundary;
- reject invalid, unauthorized, or ambiguous requests fail-close;
- keep controllers, handlers, routes, and consumers thin;
- move orchestration into application services;
- keep provider request/response details inside adapters;
- do not leak provider SDK models into application/domain layers.

## Errors

Use explicit error types or normalized error shapes.

Distinguish:

- validation errors;
- authorization/policy errors;
- domain errors;
- dependency failures;
- programmer bugs.

Log unexpected failures once at the boundary with correlation context. Map internal errors to transport-safe responses without hiding failure.

## Async And Concurrency

- await deliberately; no untracked hot-path promises;
- parallelize only independent calls;
- bound fan-out, retries, polling, and backoff;
- make retryable handlers idempotent;
- avoid in-memory coordination for correctness;
- use timeouts/cancellation for outbound calls when supported.

## Agentic Workload Readiness

When a service supports delegated agent work, model long-running work as first-class operations.

Prefer explicit:

- operation IDs;
- status/progress states;
- correlation and causation IDs;
- cancel/timeout behavior;
- retry and idempotency rules;
- durable artifacts or evidence;
- review handoff output;
- terminal success/failure states.

Do not hide long-running delegated work behind synchronous request handlers, unbounded background promises, in-memory coordination, or vague success logs.

## Data And I/O

- keep request DTOs separate from persistence/provider models;
- normalize outbound calls in dedicated clients;
- keep serialization/mapping explicit;
- do not leak provider payloads into domain logic;
- avoid direct writes that bypass the owning application/domain boundary.

## Logging, Metrics, Tracing

- emit structured logs with stable event names;
- include correlation/request/session/entity IDs where relevant;
- log factual, actionable messages;
- avoid duplicate logs at every layer;
- readiness checks must reflect real readiness, not placeholder success.

## Agent-Readable Runtime Feedback

When changing runtime behavior, make validation observable to coding agents.

This skill owns service implementation of runtime evidence:

- logging;
- metrics;
- traces;
- readiness;
- structured errors;
- correlation IDs;
- replay fixtures when service-owned.

`repo-agent-governance` owns repository-level observability access docs, checklists, validation registries, and quality/debt tracking.

Prefer:

- deterministic local startup command;
- health/readiness checks that reflect real readiness;
- stable structured log event names;
- correlation IDs across request, session, workflow, dependency call, and trace boundaries;
- queryable logs, metrics, and traces in local/dev environments where available;
- replay fixtures for critical flows;
- validation commands that produce clear pass/fail output.

For substantial runtime changes, report:

- startup command used;
- validation commands run;
- relevant log, metric, or trace evidence inspected;
- failures or missing observability;
- observability gaps that should become follow-up tasks.

## Cloud Run Posture

When deployed on Cloud Run:

- listen on configured `PORT`;
- remain stateless across requests;
- treat in-memory state only as opportunistic cache;
- prefer direct `node ...` container startup when service owns entrypoint;
- minimize cold-start work and dependencies;
- lazy-load heavy/infrequent modules when materially helpful;
- align app timeouts with Cloud Run timeout behavior;
- avoid background work after response under request-based billing;
- make background execution explicit if instance-based billing or another model is required;
- delete temp files promptly;
- choose CPU/memory/concurrency/min/max instances deliberately;
- set max instances with downstream capacity in mind.

## Tests

For changed behavior, add or update:

- unit tests for pure logic;
- contract/app tests for transport boundaries;
- focused mocks or integration tests for external-client seams;
- at least one happy path and one explicit failure path.

Prefer observable behavior over internal implementation details.

## Review Output

Organize findings by:

1. correctness and invariants;
2. fail-close/failure semantics/dependencies;
3. module and boundary clarity;
4. observability and operability;
5. tests.

For implementation summaries, report commands actually run and their results. Do not claim validation not performed.

When runtime behavior was validated through logs, metrics, traces, replay fixtures, or local startup, report the exact evidence inspected. Do not claim observability validation that was not performed.

## Definition Of Done

The service starts deterministically, validates inputs fail-close, wires dependencies explicitly, exposes structured errors and observability, avoids hidden process-memory correctness, handles retries/idempotency safely, and has focused tests for changed behavior and failure paths.
