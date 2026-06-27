---
name: sdk-release-consumer-bump
description: "Release a shared SDK package, choose the correct semver bump, publish through the declared authority, verify registry availability, and update downstream consumers. Use for SDK repos/workspace packages, publish-version conflicts, registry verification, and consumer dependency propagation."
---

# SDK Release Consumer Bump

Execute SDK release work end to end without guessing version strategy or consumer scope.

## Rules

- Apply `agentis-engineering-doctrine`: fail-close on missing metadata, auth, package declarations, validation failures, or ambiguous consumer scope.
- Use repo-defined commands and package manager.
- For Agentis repos, prefer `yarn` unless repo-local docs say otherwise.
- Do not publish or update consumers from assumptions.

## 0. Publishing Authority

For Agentis SDK repos, SDK publishing is owned by GitHub Actions.

Do not run `yarn publish`, `yarn npm publish`, `npm publish`, or equivalent from the local machine.

If a user requests local publishing, decline that path and use the declared GitHub Actions release flow instead.

Every SDK code update that changes published package contents, generated types, runtime behavior, public API, package metadata, or distributed files requires a new package version.

Docs-only, test-only, or internal non-packaged changes do not require a package version bump unless they change published package contents, generated types, runtime behavior, or public metadata.

Standard flow:

1. Make the SDK change.
2. Bump the SDK version intentionally.
3. Run repo-defined SDK validation locally.
4. Commit only the SDK code/version change.
5. Push the SDK branch to GitHub.
6. Monitor the GitHub Actions publish workflow until it succeeds.
7. Verify the exact package version exists in the registry, for example with `yarn npm info`.
8. Update downstream consumers to that exact published version and refresh lockfiles.
9. Run repo-defined consumer validation.

This release gate is mandatory before editing downstream consumer manifests or lockfiles.

Do not pre-bump consumers to an unpublished SDK version. Do not revert consumers back to the old SDK version as a release-hygiene fix unless the user explicitly asks to stop before publish.

If publishing cannot be completed, leave consumers untouched and report the blocker.

If consumer validation is needed before the workflow has published the package, state that validation is blocked unless the user explicitly approves a temporary local pack/link validation path. Do not commit temporary local package references, and do not edit consumer manifests or lockfiles for the unpublished version.

Never add local registry auth config or tokens for SDK release work. Registry auth for SDK publishing belongs in GitHub Actions secrets and workflows.

## 1. Establish Release Surface

Inspect the smallest relevant set:

- SDK `package.json`;
- workspace manifests and lockfiles;
- publish CI/workflows;
- README/runbooks/nested `AGENTS.md`;
- `docs/sdk-consumers.json` when present.

Determine:

- package name/current version;
- registry;
- publish command/path;
- validation commands;
- standalone vs workspace package;
- consumer inventory and dependency ranges.

Do not assume package manager, publish command, registry, auth, or consumer scope.

## 2. Choose Semver Intentionally

Use the actual SDK change:

- **patch**: backward-compatible fixes, packaging/dependency maintenance, valid publish retry content;
- **minor**: backward-compatible API additions;
- **major**: breaking API/type/runtime/packaging/behavior changes.

Do not use “always patch SDK releases.”

If publish fails because the version already exists, treat it as a metadata conflict. Confirm the pending content still matches the chosen bump, then move to the next valid version. Do not retry unchanged.

## 3. Validate Before Publish

Run repo-defined validation for build, lint, test, typecheck, generation, or packaging checks where declared.

If a check is absent, say so.

Do not publish failing SDKs unless the user explicitly requests it.

## 4. Publish Through Declared Path

Use the repo-defined GitHub Actions workflow by committing only the SDK version/code change and pushing the current branch to GitHub.

Monitor the workflow until it reaches a terminal state, then verify registry availability for the exact version before touching consumers.

Do not use local publish commands. Publishing must go through the declared GitHub Actions workflow.

If workflow publishing fails, classify the blocker:

- version conflict;
- auth;
- missing files;
- validation failure;
- workflow registry config;
- package metadata issue.

Fix the actual blocker on the single correct path. No blind retries.

## 5. Discover Consumers

After target version is known, update only in-scope consumers.

Prefer `docs/sdk-consumers.json` when available. If missing, stale, or incomplete, verify with dependency declarations and update the inventory in the same change.

Search manifests for:

- `dependencies`;
- `devDependencies`;
- `peerDependencies`;
- workspace package manifests;
- deployment/build manifests only when they directly declare the package.

Do not guess external repos. Preserve workspace protocols such as `workspace:*` or `workspace:^`.

## 6. Update Consumers

For each in-scope consumer:

- update manifest version/range;
- preserve existing range style unless there is a reason to change;
- refresh lockfile with repo package manager;
- run repo-defined consumer validation.

Inspect each repo before editing. Do not assume sibling repos share commands.

## 7. Release Evidence Artifact

For every SDK release, produce or update a release evidence note when the repository has a docs location for release records.

Include:

- package name;
- previous version;
- new version;
- semver rationale;
- SDK validation commands and results;
- GitHub Actions workflow run;
- registry verification;
- consumers updated;
- consumer validation commands and results;
- skipped checks and why;
- blocker classification if publish failed;
- release evidence note path;
- consumer inventory changes when `docs/sdk-consumers.json` was updated.

## Report Facts

Return:

- package name;
- published version;
- semver rationale;
- publish path used;
- consumers updated;
- validation commands and results for SDK/consumers;
- skipped checks and why;
- remaining follow-up items;
- release evidence note path, when created or updated;
- consumer inventory changes, when `docs/sdk-consumers.json` was updated.

## Pitfalls To Avoid

- treating `409 version exists` as flaky infrastructure;
- bumping consumers before publish version is known;
- replacing workspace deps with registry versions;
- changing import sites when only manifest versions needed changing;
- sweeping unknown consumers into scope;
- publishing with missing metadata/auth/validation unless explicitly instructed;
- committing local pack/link references;
- adding registry auth tokens or local `.npmrc` secrets.

## Definition Of Done

The SDK version was chosen intentionally, validated locally, published through the declared authority, verified in the registry, propagated only to in-scope consumers, lockfiles were refreshed, consumer validation was run, and release evidence was recorded or explicitly reported as unavailable.
