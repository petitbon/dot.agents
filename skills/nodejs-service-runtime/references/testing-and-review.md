# Testing And Review

Load this reference when adding runtime tests, reviewing service quality, or
preparing validation evidence.

## Tests

For changed behavior, add or update:

- unit tests for pure logic;
- contract/application tests for transport boundaries;
- focused mocks or integration tests for external-client seams;
- at least one happy path and one explicit failure path.

Prefer observable behavior over implementation details.

## Review Output

Order findings by correctness/invariants, fail-close behavior/dependencies,
module and boundary clarity, observability/operability, and tests. Report exact
commands and results. If logs, metrics, traces, replay fixtures, or local
startup were inspected, name the concrete evidence; never imply validation that
did not occur.
