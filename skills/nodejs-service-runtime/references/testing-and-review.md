# Testing And Review

Load this reference when adding runtime tests, reviewing service quality, or
preparing validation evidence.

## Tests

Follow the `repo-agent-governance` Testing Boundary: no synthetic debugging
fixtures, provider/model evals, session probes or conversation replays. The user
performs end-to-end voice/browser testing. Use unit tests and isolated
code/contract checks that do not exercise a complete voice/browser session.

For changed behavior, add or update:

- unit tests for pure logic;
- contract/application tests for transport boundaries;
- focused mocks or integration tests for external-client seams;
- at least one happy path and one explicit failure path.

Prefer observable behavior over implementation details.

## Review Output

Order findings by correctness/invariants, fail-close behavior/dependencies,
module and boundary clarity, observability/operability, and tests. Report exact
commands and results. If supplied real logs, metrics or traces were inspected,
name the concrete evidence; never imply validation that did not occur. Report
user-owned end-to-end checks as not run by Codex; do not block permitted code
work on them.
