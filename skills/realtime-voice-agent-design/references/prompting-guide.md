# Realtime Prompting Guide

Use this reference when creating or updating realtime system prompts.

Before using model-specific guidance, identify the owning runtime and verify its
contract. For OpenAI Realtime models, verify current behavior against the
[official Realtime prompting guide](https://developers.openai.com/api/docs/guides/realtime-models-prompting).
Do not apply OpenAI-specific settings or channel names to another provider.

## Prompt Structure

Use short labeled sections so the model can find instructions quickly:

```text
# Role and Objective
# Personality and Tone
# Language
# Reasoning
# Message Channels
# Preambles
# Verbosity
# Tools
# Unclear Audio
# Entity Capture
# Long Context Behavior
# Escalation
```

## Reasoning Effort

For OpenAI Realtime models that support configurable reasoning effort, start
with `low` for most production voice agents and tune based on task complexity.
For other models, use only settings declared by the owning runtime contract.

- Direct answers: do not reason.
- Multi-step tasks or tool decisions: reason before acting.
- Unclear audio: do not reason; ask for clarification.

## Preambles

Use short spoken updates when calling a slow tool, checking records, or preparing
an escalation. Do not use preambles for direct answers, simple confirmations, or
unclear audio. Keep them natural and action-oriented.

## Verbosity

- Direct answers: 1-2 short sentences.
- Clarifying questions: ask one question at a time.
- Tool results: summarize the result first, then give the next useful action.

## Tool Behavior

- Read-only lookup: call when intent is clear.
- Write actions: confirm amount, target, and consequence before calling.
- Tool failures: explain briefly, avoid raw errors, ask for correction when an
  identifier is bad, and avoid repeated calls with identical failing arguments.
- Tool availability: do not invent or simulate tools. State unavailable tools as
  unavailable.

## Silence And Background Audio

Provide a `wait_for_user` tool for silence, background noise, or side
conversation. Instruct the model to call it to end the turn without speaking.

## Message Channels

- `commentary`: preambles and intermediate updates.
- `final`: final user-facing response.

Specify channel behavior only when the runtime uses channels. In OpenAI
Realtime API output, `final_answer` may appear as a response phase value; it is
not the prompt channel name.

## Unclear Audio

Only act on audio understood with confidence. If unclear, ask a brief
clarification. Do not guess, reason, or call tools when audio is cut off or
noisy.

## Exact Entity Capture

For high-precision fields such as order IDs, tracking numbers, or emails:

1. Collect one field at a time.
2. Treat spelled-out characters as compact values, such as `A B C one two` ->
   `ABC12`.
3. Normalize spoken numbers to digits.
4. Confirm numeric identifiers digit by digit and emails character by character
   before tools.

## Literal Instruction Traps

Realtime models can follow prompt constraints literally. Avoid broad constraint
words like `always`, `never`, or `only` unless truly required. Scope constraints
precisely, such as "For write actions that modify user data, ask for
confirmation before calling the tool."

## Language And Accent

Default to English. Switch languages only if the user explicitly asks or uses a
substantive utterance in another language. Do not switch based on accent, filler
words, or names.

Control accent separately with specific prosody instructions. Keep speech easy
to understand and do not exaggerate accents.

## Long Context

For dense long sessions, separate current state from historical background.
Explicitly label "Latest known state" and "Older background facts" so the model
prioritizes the right source.
