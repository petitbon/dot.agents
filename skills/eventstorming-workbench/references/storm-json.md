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
- `domain_event` (`EVT-*`): business fact. Read `facts`, `schemaRef`, `evidenceShape`, `recoveryShape`, owner notes, and persistence or trace expectations.
- `policy` (`POL-*`): rule that reacts to an event and issues a command. Read `triggerEventId`, `commandId`, `execution`, `failureBehavior`, `description`, `notes`.
- `bdd` (`BDD-*`): business-facing scenario overlay. Read `scenario`, `given`, `when`, `then`, `linkedElementIds`, but do not treat it as the executable oracle.
- `outcome_contract` or EDD contract elements (`EDD-*`, when present): evidence oracle. Read setup, normalized intent, required evidence, Workflow outcome, forbidden side effects, trace requirements, and result classifications.

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
- EDD Outcome Contracts, Evidence Contracts, Fixture Contracts, Trace Contracts, or linked contract references
- BDD `Then` clauses mentioning contracts, SDK tool schema, parity, idempotency, evidence, oracle semantics, or fail-closed behavior

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

### Evidence Obligations

Every target path must identify the evidence that proves the intended business outcome. Prefer canonical evidence over transcript wording:

- domain events and persisted facts
- Workflow commands and outcomes
- SDK policy decisions and validated tool inputs
- dependency calls and accepted/rejected provider facts
- rejection, repair, clarification, and recovery codes
- side-effect records and forbidden side-effect checks
- correlation identifiers for caller turn, session, workflow, and provider/dependency calls

If required evidence is not currently observable, the storm must include observability work before implementation can be considered complete.

### Scenario Result Semantics

Executable scenarios must define how to classify a run:

- `PASS`: setup exists, required evidence and outcomes exist, forbidden side effects are absent.
- `FAIL`: setup and observability are valid, but the business outcome or evidence did not occur.
- `SETUP_FAILED`: Given state, fixture, or setup dependency was not established.
- `OBSERVABILITY_FAILED`: the behavior may have occurred, but required traces, facts, outcomes, or side effects were not captured.
- `SCENARIO_INVALID`: the scenario name, channel coverage, fixture, branch, or rule does not match what was executed.

Do not count setup calls, rejected setup attempts, transcript wording, or generic tool attempts as positive evidence for the behavior under test.

## BDD Handling

BDD elements may not appear in `layout.nodes`; this is intentional. They are displayed in the workbench overlay and must be treated as first-class business examples.

When implementing:

- Link each target BDD to an EDD Outcome Contract or explicit evidence oracle.
- Use `linkedElementIds` to find the policies, commands, events, and contexts that must satisfy the scenario.
- Preserve exact quoted caller turns as input examples, not as transcript-only pass criteria.
- For cross-channel BDD, require equivalent SDK policy inputs for both browser-chat and phone plus a normalized parity comparison contract.

## EDD Handling

When a storm includes EDD Outcome Contracts, evidence shapes, recovery shapes, or linked evidence references:

- Separate controlled setup from the behavior under test.
- Identify positive evidence for accepted paths.
- Identify rejection or repair evidence for negative paths.
- Identify allowed and forbidden side effects.
- Identify Workflow commands, Workflow outcomes, dependency calls, and persisted facts.
- Require trace capture for every fact needed by the oracle.
- Use `PASS`, `FAIL`, `SETUP_FAILED`, `OBSERVABILITY_FAILED`, and `SCENARIO_INVALID` distinctly.

## Output Checklist

When asked whether a storm is enough for Codex, check:

1. No dangling relationships.
2. Target paths have concrete commands/events, not prose-only actions.
3. Mutually exclusive branches declare their discriminator.
4. Required contracts and schemas are explicit.
5. Target behavior has Outcome Contracts, evidence shapes, or equivalent required canonical evidence.
6. Bounded context ownership matches repository/service code paths.
7. Replace behavior is specific enough to remove or reroute.
8. No backend English parsing is implied unless explicitly allowed.
9. Runtime branch values have canonical code/enums, not only prose labels.
10. Booking target paths separate commit, prepare-only, clarify, and restart-search behavior.
11. New storm fields reconcile with existing contract terminology or declare contract changes.
12. Target facts declare their owning context and persistence/observation category.
13. BDD overlays link to implementation elements and EDD outcome oracles.
14. Fixture/setup state is explicit and cannot be counted as pass evidence.
15. Rejection, repair, clarification, and recovery paths name stable codes.
16. Required evidence is captured in traces or the storm includes observability work.
17. Channel parity claims include both channel paths and a normalization/comparison contract.
