# Pagoda Workbench Boundaries

Use this reference for Agentis Workbench paths, source-of-truth questions, and
platform isolation.

## Repository Artifact Model

Preserve established repository conventions. Pagoda repositories may organize
artifacts like this:

```text
docs/
  pagoda/
    scenarios/<scenario-id>.scenario.json
    evidence-maps/<scenario-id>.evidence-map.json
    contracts/<scenario-id>.outcome-contract.json
src/
  evidence/
    outcome-contract-types.ts
    scenario-oracle.ts
    trace-evaluator.ts
```

Business-readable examples, evidence contracts, and runtime harness logic must
remain distinguishable.

## Agentis Workbench Owner

In Agentis, `agentis-pagoda-workbench` owns:

```text
docs/pagoda/scenarios/<scenario-id>.scenario.json
docs/pagoda/evidence-maps/<scenario-id>.evidence-map.json
docs/pagoda/contracts/<scenario-id>.outcome-contract.json
server/pagodaCli.ts
server/pagodaModelService.ts
server/simulation-ai/**
artifacts/**
```

Rules:

- Workbench owns Pagoda testing framework files, harness code, fixtures,
  trace/oracle code, EDD registry files, storm files, Workbench context, and
  generated artifacts.
- Platform repos must stay agnostic of Pagoda. They must not import, depend on,
  copy, generate, or persist Pagoda-specific harness code, storm context, EDD
  registry context, oracle logic, fixture definitions, generated artifacts, or
  testing-only contracts.
- Workbench may observe platform behavior through ordinary product contracts,
  logs, events, APIs, traces, dependency ledgers, and runtime evidence.
- If platform code must know Pagoda-specific terms or files, move that logic
  back into `agentis-pagoda-workbench`.
- `docs/pagoda/scenarios/*.scenario.json` is the scenario source of truth.
- `docs/pagoda/evidence-maps/*.evidence-map.json` is the Pagoda-native
  causal/evidence source of truth.
- `docs/pagoda/contracts/*.outcome-contract.json` is the generated contract
  projection.
- `server/pagodaModelService.ts` loads, validates, and projects scenarios and
  evidence maps.
- `server/simulation-ai/**` is executable EDD harness and oracle code.
- `artifacts/**` is run output evidence, not source-of-truth design input unless
  a specific run is being diagnosed.
- `agentis-scripts-local` no longer owns `simulation-ai`.

For implementation plans, connect workbench model changes to harness/oracle tests
when executable EDD behavior changes.
