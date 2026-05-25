---
name: eventstorming-workbench
description: Interpret EventStorming workbench storm JSON files as Codex implementation specifications. Use when Codex is given storm-*.json files, EventStorming workbench diagrams, BDD overlay scenarios, current/replace/target status labels, bounded-context policy splits, relationship graphs, schemaRef contract references, or architecture-to-implementation planning tasks.
---

# EventStorming Workbench

Use this skill to turn an EventStorming workbench document into implementation work without losing architecture boundaries, contract obligations, or BDD acceptance criteria.

## Workflow

1. Parse the storm JSON as data first. Do not infer from visual layout alone.
2. Read `storm` metadata for scope, owner, status, tags, and timestamp.
3. Build indexes for elements by `id`, relationships by source/target, and layout only after the domain graph is understood.
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
6. Treat BDD elements as definition-of-done tests. They are first-class elements even when absent from `layout.nodes`.
7. Treat `schemaRef`, `evidenceShape`, `recoveryShape`, command input/output summaries, and BDD `Then` clauses as required contract/test work.
8. Produce implementation guidance by bounded context and repository/service owner. Do not move rules into transport adapters when the storm assigns them to the shared SDK or Workflow.
9. Fail closed on ambiguity. If two target branches share a trigger, require an explicit mutually exclusive discriminator from structured evidence or policy notes.
10. Run the spec-quality gate before planning implementation. If the storm fails the gate, report the specific gaps and recommend storm updates before coding.

## Plan-First Mode

Default to plan-first behavior when this skill is used.

- Read the storm JSON and produce a current/replace/target map before any edits.
- Identify bounded-context owners, impacted repos/packages, contract/schema updates, and BDD acceptance tests.
- Produce a concrete execution plan with ordered implementation steps and validation commands.
- Stop after the plan and wait for explicit user approval before editing code, contracts, docs, or tests.
- If the user already says to implement, treat that as approval and execute the plan without asking again.
- If platform Plan mode is available, use it. If it is not available, behave plan-first in the normal response flow.
- Do not use the skill as permission to bypass Agentis workspace rules, SDK release gates, or fail-closed architecture constraints.

Default output format for plan-first runs:

1. `Spec Gate: PASS` or `Spec Gate: BLOCKED`.
2. If blocked, list only blocking gaps with card ids and exact required storm edits.
3. If passed, include only current/replace/target summary, bounded-context owners, contract/schema changes, BDD acceptance tests, execution order, and validation commands.

Keep plan-first output under 120 lines. Do not include exploration logs or repeated summaries.

## Required Checks

When using a storm as an implementation spec, answer these before editing code:

- What current behavior is preserved?
- What replace path must stop being used?
- What target path must be implemented?
- Which bounded context owns each policy, command, event, and contract?
- Which `schemaRef` documents or SDK tool schemas must change?
- Which BDD scenarios are acceptance tests?
- Which cross-channel parity requirements apply?
- Which relationships are conditional, mutually exclusive, or recovery-only?
- Are there dangling relationships, missing target contracts, or BDD scenarios not linked to implementation elements?

## Spec-Quality Gate

Do not treat a storm as implementation-ready until these checks pass:

- Runtime branch values are canonical. `semanticAct`, `recoveryReason`, statuses, and discriminators must define stable enum/code values for implementation. Human-readable labels may appear in docs or BDD prose, but must not be the only runtime values.
- Same-trigger policies are mutually exclusive. If multiple target or replace policies trigger from the same event, the storm must define the structured discriminator and the destination path for each branch.
- Booking flows separate commit, prepare-only, clarify, and restart-search paths. The storm must state which paths may call Workflow selection, Workflow confirm, Scheduling writes, or fresh availability search.
- New fields reconcile with existing contracts. A field that overlaps current contracts, such as a proposal identifier or source message identifier, must either map to the existing field name or declare an explicit contract/schema change.
- Realtime SDK target policies include cross-channel input parity. Browser-chat and phone must provide equivalent SDK inputs for the same semantic caller turn, or the storm must list adapter contract updates as prerequisite work.
- Target events and facts declare ownership. Each target fact must be classifiable as a Workflow domain event, SDK policy decision, Session Ledger/runtime observation, external-provider fact, or another explicit owner category.

## Implementation Rules

- Use `current` elements as existing baseline, not as work to rewrite.
- Implement `target` elements directly; avoid feature flags, compatibility shims, or parallel policy paths unless the storm explicitly requires them.
- Remove or bypass `replace` behavior only as far as needed to route to target behavior.
- Do not treat provider/model output as business truth. Use it as structured evidence only when the storm says the SDK or Workflow validates it.
- Do not parse caller English in backend policy unless the storm explicitly assigns that responsibility, and Agentis workspace rules allow it.
- Never bypass Workflow for governed booking writes.
- If a `schemaRef` is present on target elements, include contract documentation/schema updates in the implementation plan and tests.
- If BDD includes cross-channel parity, add or update tests for browser-chat and phone inputs over the same semantic caller turn.

## Reference

For the JSON shape, element fields, relationship semantics, and output checklist, read `references/storm-json.md` when the task requires detailed interpretation or implementation planning.
