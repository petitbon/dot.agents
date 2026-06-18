# Evidence Scenario Thinking

Use this reference for scenario families, invariant properties, generated
variations, counterexamples, and property-based testing.

## Practice

Evidence Scenario Thinking turns one outcome path into a family of examples,
properties, variations, and counterexamples before implementation work begins.

Use it when an Evidence Map, Outcome Contract, Scenario Oracle, Pagoda contract
repair, or implementation change could affect outcome behavior.

```text
Outcome rule -> invariant properties -> scenario families -> evidence clauses
-> implementation constraints -> oracle proof
```

## Scenario-Family Questions

For each target outcome, ask:

1. What simple valid path should pass, and what trusted evidence proves it?
2. What must always be true across valid variations?
3. What must never be true?
4. Which inputs vary without changing outcome class?
5. Which fields affect branch selection?
6. Which channel differences normalize away?
7. Which policy, identity, provider, timing, fixture, or dependency states
   matter?
8. What invalid, unauthorized, incomplete, ambiguous, stale, or conflicting
   inputs must reject?
9. What forbidden side effects must not happen before identity, confirmation,
   policy acceptance, payment, authorization, or Workflow approval?
10. What is the smallest counterexample, and how should the oracle classify it?
11. Which evidence must appear after setup, and which authority owns it?

## Family Shape

An Evidence Scenario Family should define:

```text
Outcome:
Authority:
Invariant Property:
Generators:
Concrete Examples:
Negative Examples:
Forbidden Side Effects:
Required Evidence:
Oracle:
```

A family is implementation-ready only when:

- generators are domain-bounded;
- generated cases map to valid setup or explicit `SCENARIO_INVALID` rules;
- invariants name the enforcing authority;
- positive and negative paths both have evidence obligations;
- forbidden side effects are checked independently from positive evidence;
- counterexamples trace back to scenario, generator input, evidence clause, and
  oracle clause.

## Property-Based Tests

Property-based testing is an implementation technique for Evidence Scenario
Thinking. Use it when an invariant can be expressed over generated domain input.

Property-based tests may validate normalization invariants, policy branch
exclusivity, command preconditions, forbidden-side-effect guards, ranking
stability, recovery classification, trace ordering, channel normalization
equivalence, and presentation consistency with trusted facts.

Property-based tests do not replace Outcome Contracts, Evidence Contracts, Trace
Contracts, Scenario Oracles, trusted runtime evidence, or end-to-end Pagoda
outcome proof unless the run also produces the required evidence trace and oracle
classification.

Prefer bounded, domain-specific generators over arbitrary random data.
