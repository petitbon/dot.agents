---
name: booking-workflow-architecture
description: "Use for Agentis booking and scheduling product architecture: governed booking workflow design, proposal state, active proposal identity, confirmation readiness, conflict recovery, stale-state invalidation, retries, idempotent side effects, duplicate-safe commits, terminal completion, and service authority ownership. Do not use as the primary skill for Pagoda Evidence Maps, scenario families, trace/oracle contracts, or Workbench harness execution; use pagoda-framework for proof artifacts."
---

# Booking Workflow Architecture

Use this skill when changing or reviewing Agentis booking/scheduling product
workflow architecture, state-machine behavior, service authority ownership, or
booking-specific invariants.

Use `pagoda-framework` when the changed artifact is an Evidence Map, scenario
family, contract, oracle, trace, harness, or Workbench proof asset. Use
`realtime-voice-agent-design` for realtime model prompting, tool schemas, voice
behavior, conversational state exposure to the model, and guarded tool
execution.

## Reference Loading

Load the narrow reference file when the task needs detail beyond this routing
file:

- `references/governed-booking-loop.md` for proposal lifecycle, stale-state
  invalidation, conflict recovery, canonical re-entry, and terminal commit
  behavior.
- `references/authority-confirmation-and-side-effects.md` for authority
  evidence, confirmation readiness, caller wishes, Scheduling truth,
  side-effect ownership, and idempotency.
- `references/repair-and-review.md` for scenario failure classification,
  forbidden repair shapes, review questions, and expected architecture or repair
  output.

## Core Thesis

Agentis booking should be designed as a governed workflow agent:

```text
search -> propose -> collect confirmation evidence -> commit -> recover from conflicts -> return to stable states
```

The assistant can speak naturally, but booking correctness must be governed by
state, authority, evidence, and durable side-effect rules.

A booking is proven by authoritative state and side-effect evidence, not by
generated language.

## Core Principle

Keep the conversational layer tolerant and semantic.

Keep the authority layer strict.

The conversational layer may interpret, clarify, summarize, narrate, and recover
naturally.

The authority layer owns proposal truth, active selection, confirmation
readiness, booking commit, conflict recovery, terminal completion, and durable
side effects.

Do not make assistant text, transcript wording, exact confirmation phrases,
scenario labels, trace names, tool-attempt shape, or UI copy the source of
booking truth.

## Required Workflow Shape

Optimize for contiguous authorized task chains:

```text
wish capture -> scheduling truth -> proposal -> confirmation evidence -> commit or recovery
```

There should be one booking commit path. Conflict recovery returns the system to
proposal with a new active proposal identity, and the next caller acceptance
must follow the normal booking path.

Caller acceptance must bind to the currently active proposal only. Invalidated,
expired, conflicted, superseded, or transcript-only proposals must not remain
commit-eligible.

## Authority And Side Effects

Use the strongest available authority for each fact. Active proposal,
selection, confirmation readiness, governed commit evidence, durable side-effect
evidence, and causal ledger evidence all outrank presentation evidence.

Scheduling owns availability and appointment truth. The model, realtime adapter,
workflow layer, SDK, UI, and scenario layers may request, rank, transform,
present, and narrate Scheduling-owned facts, but they must not invent or own
availability, providers, prices, durations, appointment IDs, booking outcomes,
or cancellation/reschedule outcomes.

Governed booking writes must happen only through the authority owner. Retryable
flows must use stable operation identity, active state identity, idempotency
keys, conflict detection, terminal-state checks, or authority-owned
deduplication to avoid duplicate or corrupt side effects.

## Forbidden Fix Shapes

Stop and redesign if a proposed change:

- treats assistant text or transcript wording as booking truth;
- accepts stale proposal selections;
- retries an old conflicted slot after recovery;
- keeps stale prepared confirmation after conflict;
- creates a special booking path only because a conflict happened;
- allows booking commit before required confirmation, identity, or material
  details are collected;
- reopens availability after completed commit without explicit caller intent;
- fixes a scenario by hardcoding exact language;
- weakens authority evidence to make conversation output cleaner;
- lets a non-owner layer create, confirm, cancel, reschedule, or otherwise
  commit governed booking changes.

## Output

For architecture work, produce the target workflow state model, authority for
each fact/decision/command/side effect/state, active proposal lifecycle,
confirmation readiness rules, recovery-to-stable-state rules, idempotency and
duplicate-safety design, terminal-state handling, service-boundary implications,
and evidence needed for Pagoda proof when relevant.

For repair work, produce failure classification, causal chain, weakest correct
layer to fix, forbidden fix shapes to avoid, normal-path loopback design,
implementation steps by owner, and tests or evidence scenarios needed to prevent
regression.

## Summary

Booking architecture should be forgiving in conversation and strict in
authority. A conflicted option dies. A recovered proposal becomes the active
proposal. The next acceptance follows the same normal path. Side effects must be
idempotent or duplicate-safe. A successful commit is terminal. Truth comes from
authority evidence, not from the words used to describe it.
