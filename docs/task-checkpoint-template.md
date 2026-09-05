# Task Checkpoint Template

Use this template for large, interruptible, cross-repo, or high-risk work. Put
the checkpoint in the owning repository, usually under `docs/plans/`, unless a
child repo has a more specific convention.

For a solution investigation, bug fix, or refactor, complete the Architecture
Conformance Gate before recording the plan. Small and medium plans may record
the same gate inline instead of creating a checkpoint. Maintain only current
resume facts: replace stale entries, link evidence instead of copying it, and
omit transcripts. Aim for 500 words; expand when required facts need more space.
On resume, verify repository state and changed inputs before repeating completed
reads or checks. Small routine tasks need no checkpoint.

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
