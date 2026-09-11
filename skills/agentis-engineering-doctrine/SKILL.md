---
name: agentis-engineering-doctrine
description: "Use for explicit Agentis doctrine work: target state, fail-close, idempotency, statelessness, or cutovers. Ordinary work uses the narrower owner."
---

# Agentis Engineering Doctrine

Use this skill only when engineering doctrine itself is the primary artifact or
explicit review lens. Do not trigger for ordinary implementation, planning, or
review work merely because the doctrine applies; use the narrower
artifact-owning skill instead.

## Routing

- Use `agentis-realtime-authority-layer` for realtime capability ownership,
  registry, resolver, admission, finalization, and evidence rules.
- Use `nodejs-service-structure` for backend folder and file layout.
- Use `repo-agent-governance` when promoting a recurring rule into repository
  docs, tests, lints, schemas, harnesses, CI, scorecards, or debt tracking.

## Reference Loading

- Load `references/delegation-and-failure-semantics.md` for delegated-production
  scope, recoverable failure, and error behavior.
- Load `references/proportional-design-and-control-smells.md` for optimization,
  service-split decisions, escalating containment, or fallback-success review.
- Load `references/delivery-and-service-posture.md` for merge gates, service
  boundaries, recurring issues, and code-output expectations.
- Load `references/maintenance-window-cutovers.md` only for deployed or
  persisted-data cutover planning.

## Core Rule

Build the clean target state directly. Do not create apparent progress through
stopgaps, fallback success, compatibility detours, guessed facts, or unowned
side effects.

## Non-Negotiable Defaults

1. Implement the clean current end state, not a transitional runtime design.
2. Reject local workarounds that leave the owning invariant broken.
3. Fail closed when authority, data, config, validation, ownership, auth,
   policy, dependencies, or invariants are uncertain.
4. Fail hard instead of returning degraded, guessed, swallowed, or fabricated
   success.
5. Use a bounded maintenance-window cutover; do not add runtime migrations,
   startup repair, rollback paths, feature flags, compatibility shims,
   dual-read/write, bridges, or failover architecture unless requested.
6. Isolate domain logic from frameworks, transport, persistence, providers, and
   UI plumbing.
7. Prefer deletion, direct control flow, narrow APIs, fewer moving parts, and
   readable ownership.
8. Make repeated effective requests duplicate-safe and avoid hidden process
   memory for correctness.
9. Add complexity or optimization only for a current requirement, measured
   bottleneck, SLO, or proven ownership/compliance/runtime boundary.

## Required Outcomes

- Never fabricate availability, writes, identifiers, pricing, auth context, or
  other business outcomes.
- A domain-approved recovery must expose the failure, preserve authority state,
  invalidate stale state, prevent unauthorized effects, and re-enter through an
  idempotent governed path.
- Make material work bounded, reviewable, and backed by evidence appropriate to
  its risk. Report validation actually run and validation skipped.

## Definition Of Done

The result is the simplest proportional owner path, preserves explicit
boundaries, rejects uncertain authority, avoids fallback success and speculative
optimization, prevents duplicate effects, and has reviewable evidence.
