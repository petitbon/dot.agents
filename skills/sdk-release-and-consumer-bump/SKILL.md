---
name: sdk-release-and-consumer-bump
description: Release a shared SDK package, choose the correct semver bump, publish it, and update downstream consumers to the new version. Use when Codex is working on an SDK repo or workspace package and needs to prepare a release, recover from a publish failure caused by an existing version, or propagate a newly published SDK version into consuming repos or packages.
---

# SDK Release And Consumer Bump

Use this skill to execute SDK release work end to end without guessing version strategy or consumer scope.

## Workflow

### 1. Establish the release surface

Inspect the SDK first.

Read the smallest relevant set of:

- `package.json`
- workspace manifests such as `package.json`, `yarn.lock`, `pnpm-lock.yaml`, `pnpm-workspace.yaml`, `turbo.json`, or `nx.json`
- CI workflows that publish the package
- `README.md`, runbooks, and any nested `AGENTS.md`

Determine:

- the package name
- the current version
- the configured registry
- the repo-defined publish command
- the repo-defined validation commands
- whether the SDK is a standalone repo or a package inside a larger workspace

Do not assume the package manager, publish command, or release flow.

### 2. Choose semver intentionally

Choose the version bump from the actual SDK change.

Use:

- patch for backward-compatible fixes, packaging-only corrections, dependency-only maintenance, and publish retries where the already-prepared release content is still correct
- minor for backward-compatible API additions such as new exports, options, helper functions, or additive types
- major for breaking API, type, runtime, packaging, or behavior changes

Do not encode "always patch SDK releases" as a rule. That creates incorrect release history the first time the SDK adds or breaks API.

If publishing fails because the registry reports that the version already exists:

- treat it as a release metadata conflict, not a transient infrastructure failure
- confirm that the pending SDK change is still backward-compatible
- bump to the next valid patch version only when the pending release content still fits a patch release
- otherwise choose the appropriate minor or major version

### 3. Validate the SDK before publish

Run the repo-defined validation commands discovered from the repository itself.

At minimum, run the commands that the repo declares for:

- build
- lint
- test
- typecheck when the repo defines one explicitly or treats it as standard validation

If the repo does not define one of these commands, say so explicitly and run the closest documented equivalent only when one exists.

Do not publish a failing SDK unless the user explicitly asks for a publish despite validation failures.

### 4. Publish using the declared release path

Use the publish command defined by the SDK repo.

Respect:

- the configured registry
- publish-time auth requirements
- prepack or prepublish hooks
- package manager behavior for workspaces versus standalone repos

If a publish fails:

- identify whether the blocker is version conflict, auth, missing files, validation failure, or registry configuration
- fix the actual blocker on the single correct path
- avoid retry loops that do not change the release state

### 5. Discover consumers from declarations

Update consumers only after the target version is known.

Prefer an explicit consumer inventory when the repo or org maintains one.

In this repository, treat `docs/sdk-consumers.json` as the first consumer-scope source of truth for SDK release work inside the current workspace.

Use that file to identify:

- releasable SDK package names
- SDK repo paths
- SDK manifest paths
- declared in-workspace consumers
- the currently declared dependency range in each consumer manifest

If the inventory file is missing, incomplete, or stale for the SDK you are releasing:

- verify consumers by inspecting dependency declarations
- update `docs/sdk-consumers.json` in the same change so the inventory remains authoritative for the next release task

Search for the SDK package name in:

- `dependencies`
- `devDependencies`
- `peerDependencies`
- workspace package manifests
- deployment or build manifests only when they declare the package directly

Do not guess consumer repositories. Only update repos or packages that are in scope, discoverable from the available workspace, or explicitly named by the user.

If a consumer uses a workspace protocol such as `workspace:*` or `workspace:^`, keep it as a workspace dependency. Do not replace workspace-local dependencies with published registry versions.

### 6. Update consumers deliberately

For each declared consumer in scope:

- update the SDK version in the manifest
- preserve the existing range style unless there is a reason to change it
- refresh the lockfile using the repo's package manager
- run the repo-defined validation commands for that consumer

When multiple consumer repos exist side by side, inspect each repo before editing it. Do not assume they share the same package manager or validation commands.

### 7. Report release facts clearly

Return:

- the published SDK version
- the package name
- the publish command used
- the consumers updated
- the validation commands run for the SDK and each consumer
- any skipped checks and why they were skipped
- any remaining follow-up items such as non-blocking warnings or consumers left intentionally unchanged

## Decision Rules

- Prefer the smallest correct semver bump, not the most convenient one.
- Prefer `docs/sdk-consumers.json` over ad hoc consumer discovery when it is available.
- Prefer explicit dependency declarations over grep hits in source code.
- Prefer repo-defined commands over invented commands.
- Prefer updating only consumers that should move now over sweeping edits across unknown repos.
- Fail fast on missing release metadata, missing auth, or missing package declarations rather than guessing.

## Common Pitfalls

- Publishing the same version twice and treating the `409` as flaky infrastructure.
- Bumping consumers before confirming the SDK version that was actually published.
- Replacing workspace dependencies with registry versions.
- Updating import sites when only manifest versions needed to change.
- Assuming all consumers should move together without checking scope.
