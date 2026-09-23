# SDK Release Preparation

## Discover The Release Surface

Inspect the smallest relevant set: SDK `package.json`, workspace manifests and
lockfiles, publish workflows, README/runbooks, nested `AGENTS.md`, and
`docs/sdk-consumers.json` when present. Determine package name and current
version, registry, publish path, validation commands, standalone/workspace
status, consumer inventory, and dependency ranges. Do not infer missing facts.

## Choose And Validate The Version

Classify the actual SDK change as patch, minor, or major under the entrypoint's
Release Gate. A published version already existing is a metadata conflict:
confirm pending content still matches the bump, choose the next valid version,
and do not retry unchanged.

Run repo-defined build, lint, test, typecheck, generation, and packaging checks
where declared. Report absent checks. Failed required validation blocks
publishing; user instruction does not override release integrity.
