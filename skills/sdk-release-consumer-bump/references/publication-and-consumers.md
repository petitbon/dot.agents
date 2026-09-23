# SDK Publication And Consumers

## Publish Through GitHub Actions

Inspect declared workflow triggers. Push the SDK commit if its branch is a
publish branch. Otherwise dispatch a declared `workflow_dispatch` for that ref
or prepare a PR to the publish branch and report publishing blocked on merge.
Do not assume a feature-branch push starts publishing.

Monitor the workflow run for the exact commit SHA to terminal success. Verify
the exact package version in the registry, for example with `yarn npm info`,
before touching consumers. Classify a failed run as version conflict, auth,
missing files, validation, workflow registry configuration, or package metadata.
Fix the actual blocker; do not retry blindly.

Never run `yarn publish`, `yarn npm publish`, `npm publish`, or equivalent
locally. Registry publishing auth belongs in GitHub Actions secrets and
workflows.

## Discover And Update Consumers

Use `docs/sdk-consumers.json` when present. If missing, stale, or incomplete,
verify against dependency declarations and update the inventory in the same
change. Inspect `dependencies`, `devDependencies`, `peerDependencies`, workspace
manifests, and deployment/build manifests that directly declare the package.
Do not guess external repos or replace `workspace:*` or `workspace:^` with
registry ranges.

For each in-scope consumer, inspect its local instructions, update its manifest
while preserving range style, refresh its lockfile with its package manager,
and run its declared validation. Do not change import sites for a manifest-only
bump.

If consumer validation is needed before publication, report it blocked unless
the user explicitly approves temporary local pack/link validation. Do not
commit temporary package references or edit consumer manifests or lockfiles for
the unpublished version.
