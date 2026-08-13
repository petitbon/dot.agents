---
name: realtime-voice-agent-design
description: "Use for realtime voice-agent model behavior: prompts, model-native tool selection, schemas, state exposure, confirmation, ambiguity, guarded execution, and replay/evals. Use realtime authority for tool registry, admission, and finalization; use booking workflow architecture for booking state."
---

# Realtime Voice Agent Design

Use this skill for realtime model, tool, prompt, state-exposure, confirmation,
ambiguity, and guarded-execution behavior.

## Routing

This skill owns how the realtime model reasons, speaks, requests declared
capabilities, and recovers conversationally. It does not own the canonical
Agentis authority ontology.

Use another primary skill for:

- registry, channel exposure, resolver, finalization, evidence, and runtime
  admission: `agentis-realtime-authority-layer`;
- booking proposal/confirmation/commit state: `booking-workflow-architecture`.

Keep test-harness concepts out of platform runtime code.

## Reference Loading

- Load `references/prompting-guide.md` for system prompts, model-specific
  guidance, preambles, unclear audio, entity capture, channels, and long
  context.
- Load `references/tool-state-and-execution.md` for tool schemas, state,
  confirmation, guarded execution, idempotency, failures, and evidence.

## Core Principle

```text
The model decides what capability is needed.
The application decides whether it is safe, valid, authorized, confirmed,
current, and executable.
```

Do not duplicate semantic reasoning with keyword routers, giant intent switches,
transcript matching, or exhaustive dialogue trees. Keep deterministic logic at
schema, authorization, policy, state, confirmation, idempotency, and side-effect
boundaries.

## Delegated-Action Interface

Design the agent to understand the caller's goal and request stable business
capabilities through guarded tools. The voice layer may be conversational; the
execution layer remains a governed workflow.

The model should select tools from the current conversation, declared tool
definitions, current state, policy summaries, prior results, and exposed safety
constraints. Tools represent business capabilities, not dialogue steps.

For features that accumulate provider-output suppression, phrase matching,
timing gates, adapter-local sentinel state, or cleanup branches, apply
`agentis-engineering-doctrine` explicitly and consider deletion,
simplification, a shared contract, or redesign at the owning layer.

## Voice Behavior

- Do not guess unclear audio or authority-owned facts.
- Ask one clarification at a time.
- Confirm exact names, dates, times, emails, phone numbers, services, and other
  high-precision entities when needed.
- Handle interruptions and corrections without rigid dialogue scripts.
- Do not over-talk or present invented availability, pricing, providers, or
  outcomes.

## Failure Posture

Return structured tool failures that support clarification, governed retry,
conflict recovery, explicit rejection, escalation, or safe termination.
Repeated failures should lead to safe termination, a declared supported
alternate path, or human escalation, never fabricated success.

## Required Validation

For behavior-changing prompt, tool, state, policy, or confirmation work:

- run deterministic tool-call fixtures and relevant evals;
- inspect available tool-call, policy, state, transcript, and Session Ledger
  evidence;
- prove governed writes cannot occur before server confirmation;
- cover ambiguity, unclear audio, missing fields, tool failure, and policy
  rejection;
- keep deterministic integration evidence at the owning service or contract
  boundary.

Report commands and evidence actually inspected.

## Codex Working Rules

1. Preserve model-native tool selection.
2. Keep schemas strict and tool descriptions clear.
3. Compose prompts, policy summaries, tools, and state from small components.
4. Treat state as context and safety, not a dialogue script.
5. Centralize tool metadata and server-enforced policy.
6. Make writes impossible without confirmation, authority, and idempotency.
7. Add observability and replay/eval coverage for changed behavior.
8. Expose ordinary product evidence that external proof harnesses can observe.

## Definition Of Done

The realtime model requests capabilities naturally while the application
enforces authority, policy, confirmation, current state, idempotency, and side
effects. Behavior changes have replayable evidence, and model wording alone can
never perform or prove a governed write.
