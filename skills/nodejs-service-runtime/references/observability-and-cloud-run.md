# Observability And Cloud Run

Load this reference for runtime logs, metrics, traces, readiness, supplied real
evidence, or Cloud Run posture.

## Logging, Metrics, And Tracing

- Emit structured logs with stable event names and relevant
  correlation/request/session/entity IDs.
- Keep messages factual and actionable; avoid logging the same failure at every
  layer.
- Make readiness prove real readiness rather than placeholder success.

This skill owns service implementation of logs, metrics, traces, readiness,
structured errors and correlation IDs.
`repo-agent-governance` owns repository-level access docs, validation
registries, scorecards, and cleanup tracking.

Prefer deterministic startup, queryable local/dev evidence, cross-boundary
correlation, unit-test coverage for critical logic and commands with explicit
pass/fail output. Never create synthetic debugging fixtures or invoke provider
evals or session replays. The user performs end-to-end voice/browser testing.
For substantial runtime work, report permitted validation, real observability
inspected, failures and material evidence limits.

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
