# Task Checkpoint Template

Use for large, interruptible, cross-repo, or high-risk work in the owner's
`docs/plans/`, unless child instructions specify otherwise. Complete the gate
before investigation/fix/refactor plans; small/medium plans may use it inline.
Keep current facts, linked evidence, no transcripts; aim for 500 words, expanding
as needed. On resume, verify changed inputs/repository state before repeating
checks. Routine tasks need no checkpoint.

```markdown
# <Task Title>

## Goal
- <Concrete outcome>

## Constraints
- <Owned repos/files>
- <Non-goals>
- <Forbidden side effects>

## Architecture Conformance Gate
- Canonical sources inspected: <repository-designated architecture and owners>
- Semantic owner and responsibility map: <responsibility -> owner>
- Current code-to-architecture delta: <existing divergence or None>
- Existing canonical seams to reuse: <APIs, registries, hooks, tests>
- Proposed responsibility placement: <planned behavior -> owner>
- Architecture delta: None
- Forbidden duplicate or non-owner responsibilities: <responsibilities>
- Mechanical proof planned: <boundary, architecture, contract, behavior checks>
- Completion criteria: <requested behavior, required checks, explicit exclusions>
- Shared-contract impact: <necessity, owner, producers/consumers, test migrations, rollout dependencies; or None>
- Scope-expansion evidence: <added work -> dependency/blocker evidence, owner, completion check; or None; link unrelated findings separately>

## Decisions
- <Current decision and reason; omit superseded decisions>

## Repository State
| Repository / Branch | Commit / Dirty files | Remaining work |
| --- | --- | --- |
| <Owner / branch> | <Commit and scoped dirty files> | <Next action> |

## Validation
| Guarantee | Command / Artifact | Result / Validated inputs |
| --- | --- | --- |
| <Rule> | <Command or evidence link> | <Pass/Fail/Skipped; commit or changed files> |

## Resume Notes
- <Next authorized action and its exact owner/path>
- <Blockers, pending user input, and existing approvals/limits>
- <Unrelated changes to preserve; evidence to reopen only if inputs change>
```
