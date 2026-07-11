# Refactor And Enforcement

Use this reference when planning a structural refactor, test layout, or
mechanical enforcement.

## Enforcement

For non-trivial services, use the smallest useful combination of:

- ESLint import-boundary rules;
- dependency-cruiser rules;
- custom architecture tests;
- file naming or size checks;
- forbidden global technical-folder checks;
- provider SDK leakage checks;
- controller-to-repository import checks.

Each finding must state the violated rule, why it matters, target dependency
direction, exact remediation, and candidate prevention check.

## Tests

Prefer:

```text
tests/unit
tests/contract
tests/integration
tests/fixtures
```

Map domain logic to unit tests, application behavior to unit/integration tests,
presentation boundaries to contract tests, and infrastructure to integration or
focused client/repository tests.

## Refactor Sequence

1. Identify capabilities and classify the service.
2. Map existing files to business owners and layers.
3. Move module-owned files and rename vague concepts.
4. Fix imports and dependency direction.
5. Preserve behavior unless intentionally changing it.
6. Delete obsolete duplicates and empty folders.
7. Update tests and docs.
8. Run repository-defined validation.

Do not leave old/new duplicate structures, compatibility paths, or fallback
behavior unless explicitly requested.
