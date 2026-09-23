---
name: sdk-release-consumer-bump
description: "Use for shared SDK semver, GitHub Actions publication, registry verification, publish conflicts, and downstream consumer bumps."
---

# SDK Release Consumer Bump

Release SDK changes through the declared workflow, then update only consumers
of the verified published version. Use repo-defined commands and package manager;
prefer `yarn` in Agentis repos unless local docs say otherwise. Fail closed on
missing metadata, auth, package declarations, validation, or consumer scope.

## Release Gate

- GitHub Actions alone publishes Agentis SDKs. Never publish locally or add
  local registry auth config or tokens. If local publishing is requested, use
  the declared GitHub Actions release flow instead.
- Bump the package version whenever changed code, generated types, runtime,
  public API, metadata, or distributed files affect published contents.
  Docs-only, test-only, and unpackaged internal changes need no bump unless
  published contents change.
- Choose patch for compatible fixes or packaging maintenance, minor for
  compatible API additions, and major for breaking API, type, runtime,
  packaging, or behavior changes. Do not default to patch.
- Run required SDK validation before publishing. A failed required check blocks
  the release.
- Inspect the workflow trigger, bind the run to the exact SDK commit SHA, and
  wait for terminal success. Verify the exact package version in the registry
  before editing consumer manifests or lockfiles.
- If publishing is blocked, leave consumers untouched and report the blocker.
  Never pre-bump consumers to an unpublished version or revert them to the old
  version as a release-hygiene fix unless the user explicitly stops the release.

## Workflow

1. Inspect the SDK package, release workflow, validation commands, and consumer
   inventory. Do not assume a registry, trigger, auth path, or consumer scope.
2. Make the SDK change, choose the version, validate, and commit only the SDK
   code/version change.
3. Publish via a declared GitHub Actions trigger. Verify the exact workflow run
   and registry version.
4. Update in-scope consumer manifests and lockfiles to that published version;
   validate each affected consumer with its own repo commands.
5. Record release evidence and report skipped checks or blockers.

## Reference Loading

- Load `references/release-preparation.md` for release surface discovery,
  semver decisions, and SDK validation.
- Load `references/publication-and-consumers.md` for workflow triggers,
  publication failures, registry checks, inventory, and consumer updates.
- Load `references/release-evidence.md` when preparing the current release
  record or final report.

Follow the `repo-agent-governance` Testing Boundary. Complete the release only
after publication, registry verification, consumer validation, and evidence.
Report blockers when the full release cannot complete.
