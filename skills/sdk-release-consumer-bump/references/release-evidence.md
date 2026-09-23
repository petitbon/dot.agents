# SDK Release Evidence

For every SDK release, replace `docs/releases/current.md` when the repository
has a docs location for release records. The release request authorizes this
current-evidence rotation, not a change to numeric documentation limits. Do
not create version-named release-note files; Git history and GitHub Releases
retain prior evidence.

Record and report:

- package name, previous and new version, and semver rationale;
- SDK validation commands/results and skipped checks with reasons;
- publish trigger, exact commit SHA, GitHub Actions run, and registry check;
- consumers and lockfiles updated, their validation commands/results, and any
  change to `docs/sdk-consumers.json`;
- release evidence note path, blocker classification, and remaining follow-up.

Report unavailable evidence explicitly. Do not report a package as published
without registry verification or a consumer as validated without its results.
