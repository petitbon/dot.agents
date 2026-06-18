# LLM Presentation Variance

Use this reference for assistant wording, semantic output checks, assistant
presentation contracts, and LLM judge protocol.

## Variance Rule

Pagoda scenarios must not require exact assistant wording unless the precise
wording is itself the regulated, contractual, legal, safety, or product outcome
under test.

Scenario Oracles should evaluate trusted outcome evidence, normalized intent,
canonical domain facts, Workflow/domain events, required presentation meaning,
missing or incorrect claims, forbidden disclosures, and forbidden side effects.

Allowed assistant-output checks:

- required information is semantically present;
- prohibited information is absent;
- presentation is consistent with trusted domain facts;
- structured fields are present when the channel supports them;
- refusal, clarification, confirmation, recovery, or next-step meaning is
  correct.

Disallowed checks:

- exact sentence matching;
- fragile regexes over natural language;
- full-response snapshots;
- pass/fail based only on model self-report;
- pass/fail based only on whether a phrase appears;
- deterministic prose requirements when exact prose is not the outcome.

Exact wording may be required only for outcomes such as legal consent, safety or
medical disclaimers, regulated notices, or approved product copy. The contract
must state which authority owns the approved language.

## Assistant Presentation Contract Pattern

Use this pattern when user-facing language matters but exact wording does not:

```text
Assistant Output Contract:
  Required meaning:
    - communicate the canonical outcome class
    - include required confirmed, rejected, repaired, or clarified facts
    - omit unsupported claims
    - avoid prohibited disclosures

  Must be consistent with:
    - trusted domain facts
    - Workflow-owned outcome evidence
    - selected itinerary, policy decision, identity state, or recovery code

  Must not include:
    - wrong provider, service, price, time, identity, status, or policy result
    - unsupported confirmation
    - claim of success before authority-owned success evidence
    - prohibited information or policy-unsafe instruction

  Oracle:
    PASS if semantic meaning is consistent with trusted evidence and no
    prohibited meaning is present.
    FAIL if the assistant claims a wrong or unsupported outcome.
    OBSERVABILITY_FAILED if assistant output or trusted evidence cannot be
    observed.
```

## LLM Judge Protocol

Use an LLM judge only for assistant presentation meaning. The judge must be
subordinate to deterministic setup, evidence, trace, oracle, and
forbidden-side-effect clauses.

Judge input must include scenario ID, generated case ID, channel, normalized
intent, assistant transcript excerpt, trusted facts/evidence refs, required and
forbidden presentation meanings, and deterministic clause status that the judge
must not override.

Judge output must be strict JSON with a closed result enum. Required
classifications:

- `PASS`: presentation meaning is consistent with trusted evidence and no
  forbidden meaning is present.
- `FAIL`: required meaning is absent, forbidden meaning is present, or assistant
  output contradicts trusted evidence.
- `SETUP_FAILED`: judge-required provider configuration is missing before the run
  can execute.
- `OBSERVABILITY_FAILED`: transcript, trusted evidence, judge response, or
  parseable judge output cannot be observed.

The judge must never infer business truth, convert failed deterministic evidence
into `PASS`, accept model self-report as proof, require exact wording unless
declared by contract, or hide malformed/ambiguous output behind success.
