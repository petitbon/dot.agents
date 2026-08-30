---
name: run-realtime-scenarios
description: "Use to execute and evidence deployed dev Agentis phone or browser-chat scenarios, including synthetic Telnyx calls, proposals, governed mutations, Session Ledger correlation, recordings, exact fixture teardown, and latest-run CSV updates. Standing authorization covers reasonably necessary dev phone runs. Excludes unit tests and design-only work."
---

# Run Realtime Scenarios

Execute deployed realtime scenarios without confusing transport success,
assistant prose, or mock tests with authority-backed product evidence.

## Routing

Use this skill for deployed dev phone/browser execution and evidence. Use the
owning architecture, prompt, registry, or runtime skill when changing the
behavior rather than operating its canonical scenario. Do not use this skill
for unit tests or architecture-only review.

## Phase-Specific Reference Loading

1. When classifying or preparing a run, load
   `references/execution-gates.md` and the exact canonical scenario docs.
2. Before invoking the maintained runner, load
   `references/runner-invocation.md` plus `references/synthetic-phone.md` or
   `references/browser-chat.md` for the selected channel.
3. After execution and before verdict, CSV persistence, or fixture teardown,
   load `references/evidence-and-cleanup.md`.

Do not front-load later-phase references.

## Source Of Truth

Use root `WORKSPACE_CONTEXT.md` only when ownership or location is unclear.
Read the nearest applicable `AGENTS.md`, the exact scenario under
`docs/capabilities/scenarios/`, its parent capability walkthrough, and only the
owner contracts/evidence needed for that scenario. Current owner APIs, runtime
contracts, Session Ledger evidence, and Booking/Scheduling evidence decide the
outcome. Recordings and transcripts are presentation evidence only.

## Standing Authorization And Scope

The repository owner authorizes Codex to execute development phone scenarios,
including charged recorded calls, whenever reasonably needed to implement,
debug, validate, or complete the active task. This persists across sessions and
includes dedicated dev fixtures, the declared test effect, evidence collection,
CSV recording, and exact-fixture terminalization.

Do not request renewed authorization, an exact call count, a spending limit, or
an approval flag/token/file. Keep execution in dev, within the active task and
selected capability, and use dedicated disposable fixtures. This authorization
does not permit production calls, broader product work, owner bypasses, or a
success claim without authority evidence.

## Workflow

1. Classify environment, channel, canonical scenario, expected effect, fixture,
   and caller type; default to dev.
2. Prove owner-backed preconditions and exact-fixture safety.
3. Run one channel through the maintained runner using only canonical natural
   customer language and current-turn confirmation rules.
4. Correlate transport, Session Ledger, finalization, and owner-domain evidence.
5. Decide `Pass`, `Fail`, or `Blocked`; persist the latest-run row, then
   terminalize and verify only the exact active fixture when applicable.

Run once by default. Another attempt requires evidence that it can validate a
fix or resolve a transient condition; never retry merely to seek a Pass.

## Non-Negotiable Rules

- Never expose credentials or full phone numbers.
- Use only current maintained tooling and configured credential sources.
- Never substitute Firestore, ad hoc shell, mocks, direct domain writes, or a
  fabricated transcript for the runner and owner/debug APIs.
- Never invent availability, providers, pricing, policy, identity,
  confirmation, correlation, tool success, or booking outcomes.
- Never bypass Booking or Workflow Engine for appointment writes.
- Never call a proposal booked before terminal Booking and Scheduling evidence.
- Never accept a static future acknowledgment of unknown options or warnings.
- Never infer domain success from transport completion, recording, assistant
  prose, or presentation alone.
- Never use broad cleanup, direct deletion, or an ambiguous fixture target.
- Never leave a material dev write without recorded exact-fixture teardown and
  retained evidence identities.
- Never finish an attempted scenario without upserting the canonical latest-run
  CSV row.

## Required Handoff

Lead with the verdict. Include scenario, environment, channel, timestamps,
opaque transport/session IDs, heard/rendered summary, authority evidence,
writes, exact-fixture teardown, preserved audit evidence, retries, and gaps.
Use the evidence format in `references/evidence-and-cleanup.md` and link the
updated latest-run CSV.
