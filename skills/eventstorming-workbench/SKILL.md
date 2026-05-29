---
name: eventstorming-workbench
description: Interpret EventStorming workbench storm JSON files as architecture, implementation, and Evidence Driven Development specifications. Use when Codex is given storm-*.json files, EventStorming workbench diagrams, BDD scenario overlays, EDD Outcome Contracts, current/replace/target status labels, bounded-context policy splits, relationship graphs, schemaRef contract references, evidenceShape/recoveryShape references, or architecture-to-implementation planning tasks.
---

# EventStorming Workbench

Use this skill to turn an EventStorming workbench document into implementation work without losing architecture boundaries, bounded-context ownership, contract obligations, behavior examples, or Evidence Driven Development evidence requirements.

EventStorming defines the domain flow. BDD describes the business-facing example. Evidence Driven Development defines the evidence required to prove the outcome.

This skill is the bridge between the architecture graph and implementation planning. It does not replace the Evidence Driven Development skill. Use this skill to interpret storm artifacts and extract implementation/evidence obligations. Use the EDD skill to write or update Outcome Contracts, Evidence Contracts, Fixture Contracts, Trace Contracts, and scenario oracle rules.

## Core Principle

Treat the storm graph as the architecture source of truth, not the visual layout alone.

Actors, commands, policies, domain events, external systems, relationships, bounded contexts, status labels, schema references, evidence shapes, recovery shapes, and behavior overlays are implementation signals. Preserve those signals when producing plans or coding instructions.

Do not treat model output, assistant transcript wording, tool attempts, or visual proximity in the diagram as business truth. For LLM-mediated and agent-native behavior, implementation must target canonical evidence, Workflow-owned outcomes, explicit rejection/repair codes, and forbidden-side-effect protection.

## Relationship To BDD And EDD

Use this vocabulary consistently:

- EventStorming Workbench: the architecture graph of actors, commands, policies, events, relationships, ownership, current behavior, replacement behavior, and target behavior.
- BDD Scenario: the human-readable business example that explains the behavior in domain language.
- Evidence Driven Development: the methodology for proving that an agent-native system achieved the intended business outcome.
- Outcome Contract: the machine-evaluable oracle that defines required setup, normalized intent, required evidence, accepted/rejected outcome, Workflow result, trace requirements, and forbidden side effects.
- Evidence Contract: the required canonical facts, events, tool results, Workflow commands, Workflow outcomes, rejection codes, repair codes, and side-effect checks that prove the outcome.
- Fixture Contract: the controlled Given state required before the scenario can be evaluated.
- Trace Contract: the runtime evidence that must be captured from transcript, tool calls, domain facts, Workflow commands, dependency calls, and side effects.

BDD scenarios are not the executable oracle. They are business-facing examples. EDD Outcome Contracts are the executable evidence oracle.

## Workflow

1. Parse the storm JSON as data first. Do not infer from visual layout alone.
2. Read `storm` metadata for scope, owner, status, tags, timestamp, version, and source references.
3. Build indexes for elements by `id`, relationships by source/target, bounded context, status, schema references, and evidence references. Consider layout only after the domain graph is understood.
4. Interpret element `status`:
   - `current`: exists and should be preserved unless a target/replace path explicitly changes its use.
   - `replace`: exists but the proposed architecture replaces this behavior/path.
   - `target`: does not exist yet or must become the desired behavior/path.
5. Follow relationships as executable architecture:
   - `actor_issues_command`: actor initiates intent.
   - `command_emits_event`: command produces a fact.
   - `event_triggers_policy`: fact triggers policy.
   - `policy_issues_command`: policy chooses the next command.
   - `external_system_sends_command`: model/provider/tool system supplies command/tool args, not business truth.
   - `context_contains_element`: bounded context ownership.
6. Identify the intended business outcome for each target behavior.
7. Identify the controlled fixture/setup state required to evaluate the target behavior.
8. Identify the canonical evidence required to prove accepted paths.
9. Identify the explicit rejection/repair evidence required to prove rejected paths.
10. Identify Workflow commands, Workflow outcomes, scheduling writes, external dependency calls, and forbidden side effects.
11. Treat BDD elements as business-facing scenario descriptions, not as sufficient executable evidence.
12. Treat `schemaRef`, `evidenceShape`, `recoveryShape`, command input/output summaries, EDD Outcome Contracts, and required domain facts as required contract/evidence work.
13. Produce implementation guidance by bounded context and repository/service owner. Do not move rules into transport adapters when the storm assigns them to the shared SDK, Workflow, Session Ledger, or another explicit owner.
14. Fail closed on ambiguity. If two target branches share a trigger, require an explicit mutually exclusive discriminator from structured evidence or policy notes.
15. Run the spec-quality gate before planning implementation. If the storm fails the gate, report the specific gaps and recommend storm updates before coding.

## Plan-First Mode

Default to plan-first behavior when this skill is used.

- Read the storm JSON and produce a current/replace/target map before any edits.
- Identify bounded-context owners, impacted repos/packages, contract/schema updates, EDD Outcome Contracts, BDD scenario overlays, and validation commands.
- Produce a concrete execution plan with ordered implementation steps and validation commands.
- Stop after the plan and wait for explicit user approval before editing code, contracts, docs, or tests.
- If the user already says to implement, treat that as approval and execute the plan without asking again.
- If platform Plan mode is available, use it. If it is not available, behave plan-first in the normal response flow.
- Do not use the skill as permission to bypass Agentis workspace rules, SDK release gates, Workflow ownership boundaries, or fail-closed architecture constraints.

Default output format for plan-first runs:

1. `Spec Gate: PASS` or `Spec Gate: BLOCKED`.
2. If blocked, list only blocking gaps with card ids and exact required storm edits.
3. If passed, include only current/replace/target summary, bounded-context owners, contract/schema changes, Outcome Contracts, BDD scenario overlays, execution order, and validation commands.

Keep plan-first output under 120 lines. Do not include exploration logs or repeated summaries.

## Required Checks

When using a storm as an implementation spec, answer these before editing code:

- What current behavior is preserved?
- What replace path must stop being used?
- What target path must be implemented?
- What business outcome does each target path intend to achieve?
- Which bounded context owns each policy, command, event, fact, and contract?
- Which `schemaRef` documents, SDK tool schemas, Workflow inputs, or dependency contracts must change?
- Which BDD scenarios describe the business examples?
- Which EDD Outcome Contracts prove the behavior?
- Which Evidence Contracts define required positive evidence?
- Which rejection or repair contracts define required negative-path evidence?
- Which fixture/setup facts are required before evaluation?
- Which cross-channel parity requirements apply?
- Which relationships are conditional, mutually exclusive, or recovery-only?
- Which side effects are allowed, forbidden, or confirmation-gated?
- Are there dangling relationships, missing target contracts, missing evidence shapes, missing rejection codes, or scenario overlays not linked to implementation elements?

## Spec-Quality Gate

Do not treat a storm as implementation-ready until these checks pass:

- Runtime branch values are canonical. `semanticAct`, `recoveryReason`, statuses, discriminators, rejection codes, repair codes, and outcome codes must define stable enum/code values for implementation. Human-readable labels may appear in docs or BDD prose, but must not be the only runtime values.
- Same-trigger policies are mutually exclusive. If multiple target or replace policies trigger from the same event, the storm must define the structured discriminator and the destination path for each branch.
- Target behavior has evidence obligations. Every target path must define an Outcome Contract, `evidenceShape`, or equivalent required canonical evidence.
- Accepted paths define positive evidence. Every accepted path must name the domain facts, Workflow commands, Workflow outcomes, dependency calls, or side effects that prove the outcome.
- Rejected paths define rejection evidence. Every rejected path must name the rejection reason, repair code, clarification code, or recovery outcome.
- Fixture state is explicit. If a scenario requires an active proposal, selected start, prior booking session, known provider, known service chain, caller identity, or other precondition, the storm must define the fixture/setup source or contract.
- Setup evidence does not count as behavior proof. Setup calls, fixture creation, and dependency seeding must not be used as pass evidence for the behavior under test.
- Transcript wording is not the sole oracle unless the behavior is explicitly presentation behavior.
- Tool attempts are not success evidence. Malformed, rejected, or partial tool calls must be treated as rejection evidence, setup failure, or debugging evidence, not as proof of accepted behavior.
- Booking flows separate commit, prepare-only, clarify, repair, and restart-search paths. The storm must state which paths may call Workflow selection, Workflow confirm, Scheduling writes, or fresh availability search.
- New fields reconcile with existing contracts. A field that overlaps current contracts, such as a proposal identifier, selected start, source message identifier, provider identity, or caller turn identifier, must either map to the existing field name or declare an explicit contract/schema change.
- Realtime SDK target policies include cross-channel input parity. Browser-chat and phone must provide equivalent SDK inputs for the same semantic caller turn, or the storm must list adapter contract updates as prerequisite work.
- Parity scenarios are executable. If the storm claims browser-chat/phone parity, it must define both channel paths and a normalization/comparison contract identifying fields that must match and fields that may differ.
- Target events and facts declare ownership. Each target fact must be classifiable as a Workflow domain event, SDK policy decision, Session Ledger/runtime observation, external-provider fact, scheduling-provider fact, or another explicit owner category.
- Observability is sufficient. Required evidence must be persisted or otherwise captured in the trace. If the behavior depends on evidence not currently observable, the storm must include observability work before implementation is considered complete.
- Scenario result semantics are defined. Executable scenarios must distinguish `PASS`, `FAIL`, `SETUP_FAILED`, `OBSERVABILITY_FAILED`, and `SCENARIO_INVALID`.

## Scenario Result Semantics

Use these classifications for executable behavior/evidence runs:

- `PASS`: required setup exists, required evidence exists, required Workflow/dependency outcomes exist, and forbidden side effects are absent.
- `FAIL`: setup and observability are valid, but the required business outcome or evidence did not occur.
- `SETUP_FAILED`: the Given state was not established, a fixture dependency failed, or setup calls were malformed/rejected.
- `OBSERVABILITY_FAILED`: the behavior may have occurred, but required facts, events, traces, dependency calls, or side effects were not captured.
- `SCENARIO_INVALID`: the scenario name, channel coverage, fixture, branch, or rule does not match what was executed.

Do not collapse setup failures, observability gaps, invalid scenario definitions, or rejected setup calls into `PASS` or `FAIL`.

## Implementation Rules

- Use `current` elements as existing baseline, not as work to rewrite.
- Implement `target` elements directly; avoid feature flags, compatibility shims, or parallel policy paths unless the storm explicitly requires them.
- Remove or bypass `replace` behavior only as far as needed to route to target behavior.
- Do not treat provider/model output as business truth. Use it as structured evidence only when the storm says the SDK, Workflow, or owning bounded context validates it.
- Do not parse caller English in backend policy unless the storm explicitly assigns that responsibility, and workspace rules allow it.
- Do not implement from transcript expectations alone. For LLM-mediated behavior, implement toward canonical evidence, Workflow outcomes, explicit rejection/repair codes, and forbidden-side-effect protection.
- Never bypass Workflow for governed booking writes.
- Never allow a prepare-only path to perform a commit write unless the storm explicitly defines confirmation and commit ownership.
- If a `schemaRef` is present on target elements, include contract documentation/schema updates in the implementation plan and tests.
- If `evidenceShape` or `recoveryShape` is present, include Outcome Contract or Evidence Contract updates in the implementation plan and tests.
- If BDD includes cross-channel parity, add or update browser-chat and phone Outcome Contracts for the same semantic caller turn, plus a normalized parity comparison contract.
- If a scenario claims parity but only one channel is executed, classify the result as `SCENARIO_INVALID`, not `PASS`.
- If a required fixture is missing or created through a rejected setup call, classify the result as `SETUP_FAILED`, not `PASS`.
- If a required domain fact or Workflow outcome is not observable, classify the result as `OBSERVABILITY_FAILED` unless the captured evidence is sufficient to prove failure.
- If a tool call is rejected, do not count the attempt as successful evidence. Count only accepted, validated, and correlated evidence.
- If assistant prose conflicts with canonical facts, canonical facts win for domain behavior. Prose may be evaluated separately as presentation behavior.

## Channel Parity Rules

When a storm contains browser-chat, phone, or other cross-channel parity paths:

- Treat each channel path as its own executable evidence path.
- Require the same semantic caller turn to be normalized through each channel.
- Require a parity contract that identifies which fields must match and which fields may differ.
- Do not infer parity from one channel run.
- Do not use assistant phrasing similarity as parity evidence.
- Compare canonical inputs, canonical evidence, validation decisions, Workflow commands, Workflow outcomes, rejection/repair codes, and forbidden side effects.

Fields that usually must match:

- semantic intent
- normalized business action
- provider preference
- provider identity or resolvable provider name
- requested service chain
- selected start or missing-start rejection
- time range
- fallbackAllowed
- validation decision
- Workflow command type
- Workflow outcome class
- forbidden side-effect result

Fields that may differ:

- channel
- session id
- caller transport metadata
- transcript wording
- timestamps
- platform-specific latency evidence

## Evidence Priority

When deciding whether a storm path is implementation-ready or whether a run proves a behavior, prefer evidence in this order:

1. Canonical domain events and facts.
2. Workflow-owned commands and outcomes.
3. SDK policy decisions and validated tool inputs.
4. External dependency calls and accepted/rejected provider facts.
5. Explicit rejection, repair, or clarification codes.
6. Persisted trace evidence with stable ordering.
7. Transcript or assistant prose as supporting evidence only.

A tool attempt is not proof of success. A transcript phrase is not proof of domain outcome. A rejected setup call is not positive evidence.

## Output Guidance

When the storm passes the spec-quality gate, structure implementation guidance around:

- Current behavior to preserve.
- Replace behavior to stop using.
- Target behavior to implement.
- Bounded-context owners.
- Contract/schema updates.
- Outcome Contracts and Evidence Contracts.
- Fixture/setup requirements.
- Trace/observability requirements.
- BDD scenario overlays, if present.
- Cross-channel parity contracts, if present.
- Execution order.
- Validation commands.

When the storm is blocked, report only blocking gaps and required storm edits. Prefer exact card ids, relationship ids, missing contract references, missing discriminator names, missing evidence shapes, or missing owner assignments.

## Reference

For the JSON shape, element fields, relationship semantics, and output checklist, read `references/storm-json.md` when the task requires detailed interpretation or implementation planning.
