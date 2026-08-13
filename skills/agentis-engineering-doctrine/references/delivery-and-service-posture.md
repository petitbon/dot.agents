# Delivery And Service Posture

Load this reference for merge evidence, service-boundary doctrine, recurring
issues, or implementation-output expectations.

## Recurring Issues

When a defect or review comment reveals a missing invariant, boundary,
evidence, or validation rule, fix the correct owner and use
`repo-agent-governance` to promote the recurring guidance into a durable doc or
mechanical check. Do not leave repeated correctness rules as chat-only advice.

## Merge Gate Posture

Fast PRs are acceptable only with a strong evidence surface. Low-risk refactors
may use structural checks and targeted tests; behavior changes require relevant
domain, contract, integration, runtime, or harness evidence.

Identity, authorization, booking mutation, billing, data loss, protected
information, policy enforcement, and governed side effects require stronger
evidence and human review. The default remains fail-close and fail-hard.

## Service Structure Posture

For folder layout use `nodejs-service-structure`. Doctrine-level rules are:

- domain/application logic does not live in controllers, routes, handlers,
  middleware, provider adapters, or repositories;
- public HTTP, webhook, event, and SDK contracts are explicit;
- repositories, clients, auth, telemetry, queues, and storage remain at
  infrastructure boundaries;
- use top-level `tests/` unless local convention requires co-location;
- do not force large-service structure onto a small service.

## Code Output Expectations

- Present the direct end-state solution first.
- Identify the concrete driver for every optimization or distributed boundary.
- Call out explicit failure points and errors.
- Include maintenance-window steps for deployed changes.
- Avoid stopgaps, runtime repair, rollback paths, feature flags, compatibility
  shims, dual paths, and fallback success unless requested.
- Justify material choices through invariants, simplicity, idempotency,
  statelessness, boundaries, and fail-close behavior.
- Discover repository commands before editing and report actual results.
