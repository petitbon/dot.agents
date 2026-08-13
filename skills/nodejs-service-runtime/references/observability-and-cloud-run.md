# Observability And Cloud Run

Load this reference for runtime logs, metrics, traces, readiness, replay
evidence, or Cloud Run posture.

## Logging, Metrics, And Tracing

- Emit structured logs with stable event names and relevant
  correlation/request/session/entity IDs.
- Keep messages factual and actionable; avoid logging the same failure at every
  layer.
- Make readiness prove real readiness rather than placeholder success.

This skill owns service implementation of logs, metrics, traces, readiness,
structured errors, correlation IDs, and service-owned replay fixtures.
`repo-agent-governance` owns repository-level access docs, validation
registries, scorecards, and cleanup tracking.

Prefer deterministic startup, queryable local/dev evidence, cross-boundary
correlation, replay fixtures for critical flows, and commands with explicit
pass/fail output. For substantial runtime work, report startup, validation,
observability inspected, failures, and remaining observability gaps.

## Cloud Run Posture

- Listen on configured `PORT` and remain stateless across requests.
- Treat in-memory state only as an opportunistic cache.
- Prefer direct `node ...` startup when the service owns its entrypoint.
- Minimize cold-start work; lazy-load heavy infrequent modules only when useful.
- Align application and Cloud Run timeouts.
- Avoid post-response background work under request-based billing; make another
  execution model explicit when required.
- Delete temporary files promptly.
- Choose CPU, memory, concurrency, and min/max instances deliberately, with max
  instances bounded by downstream capacity.
