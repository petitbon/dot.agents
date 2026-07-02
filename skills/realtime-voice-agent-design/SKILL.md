---
name: realtime-voice-agent-design
description: "Use for designing, implementing, and prompting realtime voice agents: model-native tool selection, realtime system prompts, tool schemas, conversational state exposure, confirmation behavior, voice ambiguity handling, guarded tool execution, and replay/eval validation. Use agentis-realtime-authority-layer for canonical realtime tool registry, Authority Runtime design, resolver topology, channel-specific live tool exposure, finalization/evidence policy, and cross-adapter compliance. Use booking-workflow-architecture for Agentis booking state-machine design. Use pagoda-framework for outcome-proof artifacts."
---

# Realtime Voice Agent Design

Use this skill for realtime voice agent design, prompting, tool schemas, conversational state exposure, confirmation behavior, and guarded execution.

## Scope

This skill owns realtime model/tool/prompt behavior, but not the canonical
Agentis Authority Runtime ontology.

Use `agentis-realtime-authority-layer` when the task changes SDK registry
semantics, channel tool exposure, resolver topology, authority finalization,
evidence policy, or cross-adapter runtime enforcement.

Use `booking-workflow-architecture` for Agentis booking state-machine design, active proposal lifecycle, confirmation readiness rules, conflict recovery, and terminal commit behavior.

Use `pagoda-framework` when realtime behavior must be proven through Pagoda contracts, traces, scenario oracles, or evidence-scenario harness execution.

Do not embed Pagoda-specific harness concepts into runtime platform code.

## Reference Loading

Load `references/prompting-guide.md` when creating or updating realtime system prompts, model-specific prompt instructions, spoken preambles, unclear-audio handling, entity capture rules, or channel behavior.

## Core Principle

```text
The model decides what capability is needed.
The application decides whether that capability is safe, valid, authorized, confirmed, and executable.
```

The application must not duplicate the model's semantic reasoning with hardcoded keyword routing, giant intent switches, or exhaustive dialogue-path trees.

Deterministic logic belongs at hard boundaries:

- schema validation;
- authorization;
- policy enforcement;
- state preconditions;
- confirmation;
- idempotency;
- side-effect execution.

## Realtime Agents Are Delegated-Action Interfaces

A realtime agent should not be designed as a transcript generator.

Design the conversation so the model can understand the caller's goal and delegate safe work to guarded tools, while the application enforces authority, state, policy, confirmation, idempotency, and side-effect rules.

The voice layer may be conversational. The execution layer must remain a governed workflow.

## Model-Native Orchestration

The realtime model should choose tools based on:

- current conversation;
- user request;
- available tool definitions;
- current workflow state;
- policies;
- prior tool results;
- safety constraints exposed by the application.

Avoid:

- keyword-based routers;
- large `if/else` trees for intent;
- tools that represent dialogue steps instead of business capabilities;
- English transcript matching as business logic;
- duplicated semantic routing in application code.

## Tools Represent Business Capabilities

Tools should be stable domain capabilities, not dialogue states.

For every tool, define:

- what it does;
- when to use it;
- required arguments;
- server-injected arguments;
- side effects;
- confirmation requirements;
- expected result shape;
- structured failure shape;
- idempotency behavior when it writes.

Do not ask the model to provide `tenant_id`, `session_id`, `customer_id`, or authority-owned IDs when the server can inject or resolve them.

## Schemas Should Make Bad Calls Hard

Tool schemas should be strict, explicit, and narrow.

Prefer:

- required fields for true preconditions;
- narrow enums;
- precise field descriptions;
- explicit nullable fields;
- structured date/time/location shapes;
- typed policy or state references;
- server-injected context for authority-owned facts.

Reject invalid, unauthorized, or ambiguous tool calls fail-close.

## State Is A Safety Layer, Not A Dialogue Script

Conversation state supports safety and continuity. It is not a rigid dialogue script.

State may track:

- current goals;
- collected fields;
- active proposal or pending operation references;
- pending confirmations;
- prior tool results;
- policy decisions;
- blocked or invalidated state.

Use state to filter tools, enforce preconditions, prevent invalid writes, and expose relevant context to the model.

Do not create a brittle scripted tree where state names become dialogue steps.

## Policies Are Centralized And Versioned

Booking and business policies must not be scattered across prompts and controllers.

Use structured, versioned policies with:

- policy IDs;
- applicability conditions;
- effective dates;
- conflict resolution;
- server-side enforcement;
- model-readable summaries when useful.

The model may reason over policy text, but the server enforces restricted actions.

## Prompts Should Be Composed

Do not maintain one giant realtime prompt.

Compose prompts from reusable components:

- role and tone;
- tool-use rules;
- workflow-specific state summary;
- booking or domain policy summary;
- entity capture rules;
- escalation rules;
- channel-specific behavior.

Prompt components should be small, named, testable, and replaceable.

## Confirmation Is Enforced Server-Side

The server must enforce confirmation before write actions:

- creating, modifying, or canceling bookings;
- committing inventory;
- charging money;
- changing protected records;
- sending externally visible irreversible messages when policy requires approval.

Read-only tools may be called proactively.

Write tools require explicit confirmation, validated state, policy checks, idempotency, and authority-owned execution.

The assistant must not claim an action succeeded until a trusted tool result confirms it.

## Voice Requires Conservative Handling

Voice flows must be robust to ambiguity.

The agent should:

- avoid guessing unclear audio;
- ask one clarification question at a time;
- confirm exact entities such as names, dates, times, emails, phone numbers, and services;
- spell or repeat critical details when necessary;
- handle interruptions and corrections gracefully;
- avoid over-talking the caller;
- never present invented availability, prices, providers, or outcomes.

## Tool Execution Is Guarded

Every tool call passes through a guarded execution path that:

1. validates schema;
2. injects server-known values;
3. checks permissions;
4. checks workflow state preconditions;
5. enforces policies;
6. applies idempotency;
7. executes through the owning authority;
8. returns structured success or failure;
9. emits correlation evidence.

Do not let the model directly execute governed writes.

## Failures Are Structured And Recoverable

Tool failures should return structured outputs so the model can recover safely without exposing raw internal errors to the caller.

Valid failure handling includes:

- clarification;
- retry through a governed retry state;
- conflict recovery;
- explicit rejection;
- escalation;
- safe termination.

Repeated failures should lead to safe fallback or human escalation, not fabricated success.

## Idempotency And Concurrency

Write paths must be safe under:

- retries;
- repeated confirmations;
- race conditions;
- stale state;
- interrupted calls;
- reconnects;
- duplicate tool submissions.

Use operation IDs, idempotency keys, active state identity, terminal-state checks, and authority-owned deduplication.

## Realtime Evidence And Replay

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

## Required Validation For Realtime Changes

For tool, prompt, confirmation, policy, or state changes:

- run deterministic tool-call fixtures where available;
- run relevant eval scenarios where available;
- run relevant Pagoda Outcome Contracts when the task explicitly affects Pagoda evidence or harness behavior;
- inspect session ledger, tool-call trace, or policy decision evidence where available;
- verify forbidden write actions cannot occur before server-side confirmation;
- update fixtures for ambiguity, unclear audio, tool failure, missing fields, and policy violations.

Report commands actually run and evidence actually inspected.

## Codex Working Rules

When reviewing or changing realtime voice-agent code:

1. Preserve model-native tool selection.
2. Do not add brittle semantic routing.
3. Prefer composable tool, prompt, policy, and state components.
4. Keep deterministic logic focused on safety, validation, and invariants.
5. Centralize tool metadata and policy logic.
6. Make write actions impossible without server-enforced confirmation.
7. Keep schemas strict and tool descriptions clear.
8. Treat state as context and guardrails, not a scripted dialogue tree.
9. Add observability for tool calls and state transitions.
10. Add or update tests/evals for architectural or behavior changes.
11. Use replayable traces, ledgers, or eval fixtures for behavior-changing prompt/tool/state updates.
12. Keep Pagoda-specific harness logic outside platform runtime code; expose ordinary product evidence that Pagoda can observe externally.

## Definition Of Done

The realtime layer lets the model choose business capabilities naturally while the application enforces authority, policy, confirmation, idempotency, and side-effect safety. Behavior-changing work has replayable evidence or eval coverage, and no governed write can occur from model wording alone.
