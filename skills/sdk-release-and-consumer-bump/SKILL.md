---
name: sdk-release-and-consumer-bump
description: "Release a shared SDK package, choose the correct semver bump, publish it, and update downstream consumers. Use for SDK repos/workspace packages, publish-version conflicts, and consumer dependency propagation."
---

# SDK Release And Consumer Bump

Execute SDK release work end to end without guessing version strategy or consumer scope.

## Precedence

- Apply `ThePetitbonDoctrine`: fail-close on missing metadata, auth, package declarations, validation failures, or ambiguous consumer scope.
- Use repo-defined commands and package manager. For John's Agentis repos, prefer `yarn` unless local docs say otherwise.

## Workflow

### 1. Establish release surface

Inspect the smallest relevant set:

- SDK `package.json`
- workspace manifests and lockfiles
- publish CI/workflows
- README/runbooks/nested `AGENTS.md`
- `docs/sdk-consumers.json` when present

Determine:

- package name/current version
- registry
- publish command
- validation commands
- standalone vs workspace package
- consumer inventory and dependency ranges

Do not assume package manager, publish command, registry, auth, or consumer scope.

### 2. Choose semver intentionally

Use the actual SDK change:

- patch: backward-compatible fixes, packaging/dependency maintenance, valid publish retry content
- minor: backward-compatible API additions
- major: breaking API/type/runtime/packaging/behavior changes

Do not use “always patch SDK releases.”

If publish fails because the version already exists, treat it as a metadata conflict. Confirm the pending content still matches the chosen bump, then move to the next valid version. Do not retry unchanged.

### 3. Validate before publish

Run repo-defined validation for build/lint/test/typecheck where declared.

If a check is absent, say so. Do not publish failing SDKs unless the user explicitly requests it.

### 4. Publish through declared path

Use the repo-defined publish command and configured registry.

If publish fails, classify the blocker:

- version conflict
- auth
- missing files
- validation failure
- registry config
- package metadata issue

Fix the actual blocker on the single correct path. No blind retries.

### 5. Discover consumers

After target version is known, update only in-scope consumers.

Prefer `docs/sdk-consumers.json` when available. If missing/stale/incomplete, verify with dependency declarations and update the inventory in the same change.

Search manifests for:

- `dependencies`
- `devDependencies`
- `peerDependencies`
- workspace package manifests
- deployment/build manifests only when they directly declare the package

Do not guess external repos. Preserve workspace protocols such as `workspace:*` or `workspace:^`.

### 6. Update consumers

For each in-scope consumer:

- update manifest version/range
- preserve existing range style unless there is a reason to change
- refresh lockfile with repo package manager
- run repo-defined consumer validation

Inspect each repo before editing. Do not assume sibling repos share commands.

### 7. Report facts

Return:

- package name
- published version
- semver rationale
- publish command used
- consumers updated
- validation commands and results for SDK/consumers
- skipped checks and why
- remaining follow-up items

## Pitfalls to avoid

- treating `409 version exists` as flaky infra
- bumping consumers before publish version is known
- replacing workspace deps with registry versions
- changing import sites when only manifest versions needed changing
- sweeping unknown consumers into scope
- publishing with missing metadata/auth/validation unless explicitly instructed
