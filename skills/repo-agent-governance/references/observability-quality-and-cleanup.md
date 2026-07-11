# Observability, Quality, And Cleanup

Use this reference when work changes repository-level observability access,
execution plans, quality/debt visibility, or cleanup loops.

## Observability Access

Document deterministic startup, health/readiness commands, log/trace access,
correlation IDs, replay fixtures, and UI artifact expectations. Service
implementation of logs, metrics, traces, and readiness belongs to
`nodejs-service-runtime`.

Do not claim runtime validation unless commands ran or evidence was inspected.

## Plans

For substantial work, record goal, non-goals, touched areas, acceptance,
validation, decisions, progress, blockers, and cleanup/debt entries. Keep small
work lightweight; make large or interruptible work resumable without chat
history.

## Quality And Debt

Track relevant docs freshness, boundary enforcement, validation coverage, local
bootability, observability legibility, test reliability, known debt, repeated
agent mistakes, cleanup backlog, and high-risk gaps without mechanical gates.

## Cleanup

Use small recurring cleanup tasks to find duplicated rules, stale docs, missing
validation, boundary/naming drift, untested critical behavior, score regressions,
actionable debt, and prompt-only rules that should become checks.

Keep cleanup targeted and behavior-preserving unless behavior change is
explicitly scoped.
