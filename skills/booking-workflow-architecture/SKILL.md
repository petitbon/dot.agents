---
name: booking-workflow-architecture
description: "Use for booking proposal/confirmation state, stale recovery, duplicate-safe commit, and completion. Excludes standalone Scheduling and tool exposure."
---

# Booking Workflow Architecture

Use this skill for booking proposal state, commit safety, conflict recovery,
and appointment side effects. Do not use for standalone Scheduling work.

Use `realtime-voice-agent-design` for model prompting, tool selection, speech,
and conversational state. Use `agentis-realtime-authority-layer` for tool
exposure, admission, routing, finalization, and evidence across phone and
browser chat. This skill owns the booking proposal and commit lifecycle.

## Reference Loading

Load only the reference needed for the task:

- `references/governed-booking-loop.md` for proposal lifecycle, stale-state
  invalidation, conflict recovery, canonical re-entry, and terminal commit.
- `references/authority-confirmation-and-side-effects.md` for confirmation
  readiness, Scheduling truth, side-effect ownership, and idempotency.
- `references/repair-and-review.md` before repair work, for failure
  classification, forbidden fixes, review questions, and output.

## Core Rule

Conversation may interpret, clarify, and narrate. Authoritative state and
durable side-effect evidence govern proposal truth, active selection,
confirmation readiness, commit, conflict recovery, and terminal completion.
Assistant text, transcripts, trace labels, and UI copy cannot establish
booking truth.

## Required Workflow Shape

```text
wish capture -> scheduling truth -> proposal -> confirmation evidence -> commit or recovery
```

There is one booking commit path. After a conflict, invalidate the old option
and prepared confirmation, create a new active proposal, and require the next
acceptance to follow the normal path. Invalidated, expired, conflicted,
superseded, or transcript-only proposals cannot remain commit-eligible.

## Authority And Side Effects

Governed state, commit, durable side-effect, and causal ledger evidence outrank
presentation evidence. Scheduling owns availability and appointment truth.
Other layers may request, rank, transform, present, and narrate Scheduling-owned
facts; they must not invent or own availability, providers, prices, durations,
appointment IDs, or booking/cancellation/reschedule outcomes.

Governed booking writes happen only through the authority owner. Retryable
flows need stable operation and active-state identity, idempotency, conflict
and terminal-state checks, or authority-owned deduplication to prevent
duplicate or corrupt side effects.

## Output And Validation

Follow the `repo-agent-governance` Testing Boundary. Use unit or isolated
contract checks for changed booking behavior. Load `references/repair-and-review.md`
for the architecture or repair output checklist.
