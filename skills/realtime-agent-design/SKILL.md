---
name: realtime-agent-design
description: "Use for designing, implementing, and prompting realtime voice agents using gpt-realtime-2 or gpt-realtime-1.5. Use when creating or updating tool schemas, conversational state models, confirmation logic, and realtime system prompts."
---

# Realtime Agent Design Principles & Prompting Guide

This skill synthesizes the **Agent Architecture Principles** with the **Realtime Prompting Guide** (`gpt-realtime-2` / `gpt-realtime-1.5`) to ensure Codex designs safe, composable, and model-native conversational agents.

## Pairing and Scope

Pair with:

- `ThePetitbonDoctrine` for fail-close/fail-hard posture;
- `agent-harness-engineering` for repository-level validation loops, observability access, quality/debt docs, and cleanup;
- `pagoda-framework` only when realtime behavior must be proven through Pagoda Outcome Contracts, Evidence Contracts, Trace Contracts, Scenario Oracles, or EDD harness execution.

This skill owns realtime agent design. Pagoda owns independent E2E outcome proof. Do not embed Pagoda-specific harness concepts into runtime platform code.

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

## Part 2: Realtime Prompting Guide (gpt-realtime-2 / 1.5)

### Recommended Prompt Structure
Use short, labeled sections. The model should be able to find relevant instructions quickly:
`# Role and Objective`, `# Personality and Tone`, `# Language`, `# Reasoning`, `# Message Channels`, `# Preambles`, `# Verbosity`, `# Tools`, `# Unclear Audio`, `# Entity Capture`, `# Long Context Behavior`, `# Escalation`

### Set Reasoning Effort
Start with `low` reasoning effort for most production voice agents. Tune up or down based on task complexity. Steer reasoning via the prompt:
- Direct answers: do not reason.
- Multi-step tasks or tool decisions: reason before acting.
- Unclear audio: do not reason, ask for clarification.

### Use Preambles Intentionally
Preambles are short spoken updates (e.g., "I'll check that order now.") that keep the agent feeling responsive while reasoning or calling tools.
- **Use when:** Calling a slow tool, checking records, or preparing an escalation.
- **Do not use when:** The answer is direct, the user is just confirming, or audio is unclear.
- **Style:** Keep it natural, short (one sentence), and describe the action, not the internal thought process. Avoid filler ("Let me think...").

### Control Verbosity
Define what "concise" means in context:
- Direct answers: 1-2 short sentences.
- Clarifying questions: Ask one question at a time.
- Tool results: Summarize the result first, then give the next useful action.

### Design Tool Behavior
Set tool-call eagerness based on risk:
- Read-only lookup: Call when intent is clear.
- Write actions: Confirm amount, target, and consequence before calling.
- **Tool Failures:** Explain the failure briefly, don't expose raw errors. Ask for correction if due to a bad identifier. Offer a retry or escalation path. Do not repeatedly call a failing tool with the same arguments.
- **Tool Availability:** Do not invent or simulate tools. If a tool isn't in the list, state it's unavailable.

### Handle Silence and Background Audio
Provide a `wait_for_user` tool for when the audio is silence, background noise, or a side conversation. Instruct the model to call this tool to end the turn without speaking (e.g., do not say "I didn't catch that").

### Message Channels
- `commentary` channel: Used for preambles and intermediate updates.
- `final_answer` channel: Used for the final user-facing response.
Specify behavior by channel if needed.

### Handle Unclear Audio
Only act on audio understood with confidence. If unclear, ask a brief clarification (e.g., "Sorry, could you repeat that clearly?"). Do not guess, do not reason, and do not call tools when audio is cut off or noisy.

### Capture Exact Entities
For high-precision fields (order IDs, tracking numbers, emails):
1. **Collect one at a time.**
2. **Handle spelled-out characters:** Treat dictated sequences as compact values (e.g., "A B C one two" -> "ABC12").
3. **Normalize numbers:** Convert spoken number phrases to digits.
4. **Confirm before tools:** Read back numeric identifiers digit by digit. Confirm emails character by character. Do not use guessed or unconfirmed values.

### Avoid Literal Instruction Traps
`gpt-realtime-2` follows instructions literally. Avoid broad constraint words like `always`, `never`, or `only` unless truly required. Use precise scope (e.g., instead of "Always ask for confirmation," use "For write actions that modify user data, ask for confirmation before calling the tool").

### Control Language and Accent Separately
- **Language:** Default to English. Switch languages only if the user explicitly asks or uses a substantive utterance in another language. Do not switch based on accent, filler words, or names.
- **Accent:** Provide specific prosody instructions (e.g., "Speak English with a light Australian accent. Keep speech easy to understand. Do not exaggerate.").

### Maintain State in Long Sessions
For dense, long sessions (up to 128k context), use a structured pattern to define current state vs. historical background. Explicitly declare what is the "Latest known state" vs. "Older background facts" so the model knows which sources to prioritize.

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
