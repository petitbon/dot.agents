# EventStorming Workbench Storm JSON

Use this reference when reading `eventstorming-workbench/docs/eventstorming/**/storm-*.json`.

## Top-Level Shape

```json
{
  "version": "1.0.0",
  "storm": {},
  "elements": [],
  "relationships": [],
  "layout": { "nodes": [], "edges": [], "viewport": {} },
  "approvals": []
}
```

`layout` is presentation. The implementation spec is primarily `elements` plus `relationships`.

## Element Types

- `bounded_context` (`BC-*`): owner boundary, code paths, language rules.
- `actor` (`ACT-*`): human/system participant.
- `external_system` (`EXT-*`): provider or outside system; never business truth by itself.
- `command` (`CMD-*`): intent or operation to execute. Read `inputSummary`, `outputSummary`, `idempotencyKey`.
- `domain_event` (`EVT-*`): business fact. Read `facts`, `schemaRef`, `evidenceShape`, `recoveryShape`.
- `policy` (`POL-*`): rule that reacts to an event and issues a command. Read `triggerEventId`, `commandId`, `execution`, `failureBehavior`, `description`, `notes`.
- `bdd` (`BDD-*`): acceptance scenario. Read `scenario`, `given`, `when`, `then`, `linkedElementIds`.

## Status Semantics

- `current`: preserve as baseline unless target/replace explicitly changes use.
- `replace`: existing behavior/path that should stop driving the target flow.
- `target`: desired behavior/path or acceptance criterion.

For implementation, target and replace together define the delta. Current elements provide context and preserved invariants.

## Relationship Types

- `actor_issues_command`: actor initiates command.
- `command_emits_event`: command records event/fact.
- `event_triggers_policy`: event activates policy.
- `policy_issues_command`: policy issues command.
- `external_system_sends_command`: external/provider output sends command/tool call.
- `external_system_emits_event`: external system emits fact.
- `event_causes_event`: event causation.
- `context_contains_element`: bounded context ownership.

If an element field and relationship disagree, report the mismatch before implementation.

## Contract Work

Treat these as contract obligations:

- `schemaRef`
- `evidenceShape`
- `recoveryShape`
- command `inputSummary` / `outputSummary`
- BDD `Then` clauses mentioning contracts, SDK tool schema, parity, idempotency, or fail-closed behavior

For Agentis realtime booking storms, `docs/contracts/surface-registry.json#bkg_wish` and `docs/contracts/booking-workflow.md` references normally require both documentation and SDK/runtime schema checks.

## Spec-Quality Gate Details

Use these checks before writing an implementation plan. If any fail, report the storm as not implementation-ready and name the cards or fields that need revision.

### Canonical Runtime Values

Runtime decision fields must not rely only on English labels. For example:

- Good: `semanticActCode: "ACCEPT_PROPOSED_START"` with `semanticActLabel: "accept proposed start"`.
- Good: `recoveryReasonCode: "MATERIAL_CONSTRAINT_CHANGE"` with a display label.
- Not enough: `semanticAct: "maybe Tuesday at 1 means ambiguous_or_hedged"` without a canonical code.

Readable labels may remain in BDD prose. Implementation plans should bind code to canonical values, not to localized wording.

### Same-Trigger Branches

When two policies consume the same event, the storm must describe the mutually exclusive conditions. For example, if `EVT-003` can trigger both accepted confirmation and recovery, require a structured discriminator such as:

```json
{
  "acceptedWhen": {
    "semanticActCode": "ACCEPT_PROPOSED_START",
    "materialConstraintChange": false,
    "activeProposalMatch": true
  },
  "recoverWhen": {
    "recoveryReasonCode": [
      "MISSING_EVIDENCE",
      "AMBIGUOUS_OR_HEDGED",
      "DENIAL",
      "MATERIAL_CONSTRAINT_CHANGE"
    ]
  }
}
```

Do not infer branch choice from layout position or prose alone.

### Booking Path Separation

For booking confirmation or availability storms, verify that target paths clearly separate:

- Commit path: may call Workflow confirm and eventually Scheduling write.
- Prepare-only path: may prepare or select an itinerary, but must not commit.
- Clarify path: asks a non-redundant question and does not write.
- Restart-search path: invalidates stale proposal and returns to Workflow/Scheduling availability search.

If material constraint changes are present, they must not route through a stale proposal commit.

### Existing Contract Reconciliation

Field names introduced by the storm must be reconciled against existing contracts and code. If a storm says `selectedProposalId` but the current code uses `proposalSetId`, the implementation plan must either:

- map `selectedProposalId` to `proposalSetId`, or
- declare a contract/schema rename or additive field.

The same rule applies to message identifiers, client identifiers, correlation identifiers, provider preferences, and evidence hashes.

### Cross-Channel SDK Inputs

For realtime SDK policy changes, confirm that browser-chat and phone can provide equivalent SDK inputs:

- latest caller text or canonical transcript message body
- source message id or equivalent cross-channel turn id
- active proposal/proposal-set state
- client identity state
- timezone/business/location context
- allowed tool surface
- structured model evidence/tool args

If one channel lacks a required input, list adapter contract work before implementation.

### Target Fact Ownership

Every target event or fact should have an owner category. Prefer explicit wording in element notes or facts:

- `Workflow domain event`
- `SDK policy decision`
- `Session Ledger/runtime observation`
- `external-provider fact`
- `Scheduling domain event`

If ownership is unclear, block implementation planning until the storm distinguishes internal SDK decisions from persisted domain events and runtime observations.

## BDD Handling

BDD elements may not appear in `layout.nodes`; this is intentional. They are displayed in the workbench overlay and must be treated as first-class acceptance criteria.

When implementing:

- Convert each target BDD into tests or explicit verification steps.
- Use `linkedElementIds` to find the policies, commands, events, and contexts that must satisfy the scenario.
- Preserve exact quoted caller turns when present.
- For cross-channel BDD, test equivalent SDK policy inputs for both browser-chat and phone.

## Output Checklist

When asked whether a storm is enough for Codex, check:

1. No dangling relationships.
2. Target paths have concrete commands/events, not prose-only actions.
3. Mutually exclusive branches declare their discriminator.
4. Required contracts and schemas are explicit.
5. BDD covers happy path, negative path, recovery, and parity when applicable.
6. Bounded context ownership matches repository/service code paths.
7. Replace behavior is specific enough to remove or reroute.
8. No backend English parsing is implied unless explicitly allowed.
9. Runtime branch values have canonical code/enums, not only prose labels.
10. Booking target paths separate commit, prepare-only, clarify, and restart-search behavior.
11. New storm fields reconcile with existing contract terminology or declare contract changes.
12. Target facts declare their owning context and persistence/observation category.
