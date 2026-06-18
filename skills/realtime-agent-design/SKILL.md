---
name: realtime-agent-design
description: "Use for designing, implementing, and prompting realtime voice agents using gpt-realtime-2 or gpt-realtime-1.5. Use when creating or updating tool schemas, conversational state models, confirmation logic, and realtime system prompts."
---

# Realtime Agent Design Principles & Prompting Guide

This skill synthesizes the **Agent Architecture Principles** with the **Realtime Prompting Guide** (`gpt-realtime-2` / `gpt-realtime-1.5`) to ensure Codex designs safe, composable, and model-native conversational agents.

## Scope

This skill owns realtime agent design. Use `pagoda-framework` only when realtime
behavior must be proven through Pagoda contracts, traces, scenario oracles, or
EDD harness execution. Do not embed Pagoda-specific harness concepts into
runtime platform code.

## Core Principle

**The model decides what capability is needed.**
**The application decides whether that capability is safe, valid, authorized, confirmed, and executable.**

The application must not duplicate the model’s semantic reasoning with hardcoded keyword routing, giant intent switches, or exhaustive booking-path trees.

---

## Part 1: Agent Architecture Principles

### 1. Model-native orchestration over deterministic semantic routing
The realtime model should choose tools based on the current conversation, user request, available tool definitions, booking state, policies, and prior tool results. Avoid keyword-based routers, large `if/else` trees for intent, and tools that represent dialogue steps instead of business capabilities. Deterministic logic is limited to hard boundaries: validation, authorization, policy enforcement, and confirmation.

### 2. Tools should represent business capabilities
Tools should be stable domain capabilities, not dialogue states. Clearly define what a tool does, when to use it, required arguments, server-injected arguments, side effects, confirmation requirements, and expected results.

### 3. Tool schemas should make bad calls hard
Tool schemas should be strict, explicit, and narrow. Use clear required fields, narrow enums, precise field descriptions, structured formats, and explicit nullable fields. Do not ask the model to provide `tenant_id`, `session_id`, or `customer_id` when the server can inject them.

### 4. State is a safety layer, not a dialogue script
Conversation state supports safety and continuity, not rigid dialogue branching. State tracks current goals, collected fields, pending confirmations, and prior tool results. Use it to filter tools, enforce preconditions, and prevent invalid writes.

### 5. Policies should be centralized and versioned
Booking policies must not be scattered across prompts and controllers. Use structured, versioned policies (with IDs, applicability, effective dates, and conflict resolution) that the model can reason over and the server can enforce.

### 6. Prompts should be composed, not monolithic
Do not maintain one giant realtime prompt. Build prompts from reusable components (role, tools, booking policy, entity capture rules, escalation).

### 7. Confirmation must be enforced server-side
The server must enforce confirmation before any write actions (creating, modifying, or canceling bookings, committing inventory, charging money). Read-only tools may be called proactively. Write tools require explicit confirmation, validated state, and policy checks.

### 8. Voice requires conservative handling
Voice flows must be robust to ambiguity. The agent should not guess unclear audio, should ask one clarification question at a time, confirm exact entities (names, dates, emails), and never claim an action succeeded until the tool result confirms it.

### 9. Tool execution must be guarded
Every tool call passes through a guarded execution path that validates schema, injects server-known values, checks permissions, checks state preconditions, enforces policies, and applies idempotency.

### 10. Failures should be structured and recoverable
Tool failures should return structured outputs so the model can recover safely without exposing raw internal errors to the caller. Repeated failures should lead to safe fallback or human escalation.

### 11. Idempotency and concurrency are required for writes
Booking writes must be safe under retries, repeated confirmations, race conditions, and stale state. Use idempotency keys, duplicate-submit protection, and verify consistency between conversation state and backend state.

### 12. Tests and evals should protect behavior
Prioritize coverage for happy paths, ambiguous requests, unclear audio, tool failures, missing fields, and policy violations. Use deterministic fixtures that simulate model tool calls.

### 13. Realtime Evidence and Replay

For behavior-changing realtime agent work, define or update:

- normalized intent shape;
- tool-call evidence;
- guarded execution evidence;
- confirmation evidence for writes;
- policy decision evidence;
- session ledger evidence;
- transcript as supporting evidence only unless presentation is the outcome;
- replay fixture or eval scenario for the changed behavior.

Do not validate realtime behavior only by assistant wording. Use replayable traces, tool-call ledgers, policy decisions, state transitions, and outcome contracts where domain correctness is affected.

---

## Prompting Details

For gpt-realtime-2 / gpt-realtime-1.5 prompt structure, reasoning effort,
preambles, verbosity, tool behavior, unclear audio, exact entity capture,
language/accent control, and long-context state, read
`references/prompting-guide.md`.

---

## Required Validation for Realtime Changes

For tool, prompt, confirmation, policy, or state changes:

- run deterministic tool-call fixtures where available;
- run relevant eval scenarios where available;
- run relevant Pagoda Outcome Contracts when the task explicitly affects Pagoda evidence or EDD harness behavior;
- inspect session ledger, tool-call trace, or policy decision evidence where available;
- verify forbidden write actions cannot occur before server-side confirmation;
- update fixtures for ambiguity, unclear audio, tool failure, missing fields, and policy violations.

Report commands actually run and evidence actually inspected.

## Codex Working Rules

When reviewing or changing this repository:
1. Preserve model-native tool selection.
2. Do not add brittle semantic routing.
3. Prefer composable tool, prompt, policy, and state components.
4. Keep deterministic logic focused on safety, validation, and invariants.
5. Centralize tool metadata and booking policy logic.
6. Make write actions impossible without server-enforced confirmation.
7. Keep schemas strict and tool descriptions clear.
8. Treat state as context and guardrails, not a scripted dialogue tree.
9. Add observability for tool calls and state transitions.
10. Add or update tests/evals for any architectural change.
11. Use replayable traces, ledgers, or eval fixtures for behavior-changing prompt/tool/state updates.
12. Keep Pagoda-specific harness logic outside platform runtime code; expose ordinary product evidence that Pagoda can observe externally.
