---
name: agentis-unversioned-contracts
description: "Use for current-only SDK/DTO/schema/parser contracts and compatibility removal. Reject versioned shapes; exclude HTTP routes, semver, and third-party types."
---

# Agentis Unversioned Contracts

Keep one authoritative contract in code and on the wire. Change consumers with
the contract instead of preserving retired names, selectors, adapters, readers,
or migrations.

## Classify Before Editing

Classify every version-looking token before changing it:

- **Forbidden contract versioning:** identifiers such as
  `AgentisEventEnvelopeV1Type`, `BookingInputV3`, or `CatalogSnapshotV8`;
  wire selectors such as `schemaVersion`, `eventVersion`, `grammarVersion`,
  `resolverVersion`, or `evaluatorAbiVersion`; compatibility aliases and
  fallback readers; `LEGACY_TERM`; migration commands that translate retired
  shapes.
- **Allowed transport/release versioning:** HTTP paths such as `/v1/...`, npm
  semver, dependency versions, release notes, and provider-owned API versions.
- **Allowed business revision/provenance:** fields such as `configVersion`,
  `policyVersion`, `sourceRevision`, hashes, publication IDs, aggregate
  revisions, and runtime provenance values such as
  `"GeminiRealtimePhoneRuntimeV1"`. These describe identity or evidence; they
  do not select an alternate contract parser.
- **Allowed negative evidence:** tests and fixtures that prove obsolete input
  is rejected. Do not make rejection tests into a production compatibility
  reader.

When classification is ambiguous, inspect the owning contract, parser, and
consumer. Treat a field as forbidden when it changes which shape, grammar,
resolver, evaluator, or compatibility path executes.

## Implement the Current Contract

1. Define the authoritative contract with an unversioned name.
2. Update all repo-owned producers, consumers, validators, tests, fixtures, and
   active documentation in the same change.
3. Delete replaced types, exports, aliases, selector fields, compatibility
   branches, fallback readers, retired migrations, and their positive-path
   tests.
4. Keep or add rejection tests proving obsolete persisted or wire shapes fail
   closed.
5. If a published SDK boundary changes, use `sdk-release-consumer-bump` for the
   major release and downstream dependency propagation. A major package release
   replaces the contract; it does not justify version suffixes inside the new
   package API.
6. If deployed data must be removed, transformed, backfilled, or reseeded, use
   a separate fail-closed maintenance-window cutover script in
   `agentis-scripts-local/scripts/`, execute it through `yarn cli run`, and
   provide exact environment-specific execution and validation instructions.
   The script must write only the current authoritative shape and preserve the
   owning domain's write boundary. Do not hide data repair in a runtime reader,
   service startup, or publication path.

## Reject These Designs

- Parallel `CurrentType` and `CurrentTypeV2` exports.
- A version field that dispatches to multiple schemas or parsers.
- An alias that keeps an old exported name compiling.
- A compatibility adapter that maps a retired payload into the current shape.
- A fallback that treats missing current fields as an older valid contract.
- A migration, replay, or reprojection path retained only to upgrade retired
  application shapes.
- A feature flag or dual-read/dual-write path that preserves the retired
  contract.

Fail closed with an explicit current-contract error when required shape or
identity is absent, invalid, ambiguous, or obsolete.

A bounded offline cutover script is not a compatibility path. Use a
current-state action name such as `cutover-*`, `backfill-*`, or `reset-*`, and
remove the script when the cutover is complete and it is no longer an active
operational procedure.

## Validate

From `agentis-scripts-local`, run:

```bash
yarn cli run --env dev validate-unversioned-contracts
yarn test
yarn typecheck
```

Also run the narrow tests, typecheck, and build for every changed SDK or
consumer. For a cross-repository contract change, verify every registered
consumer before handoff.

## Report Evidence

Report:

- The authoritative unversioned name and shape.
- Removed versioned symbols, selectors, branches, and migrations.
- Any allowed version-looking tokens and why they are provenance, transport, or
  release metadata rather than contract dispatch.
- Validator and affected-repository results.
