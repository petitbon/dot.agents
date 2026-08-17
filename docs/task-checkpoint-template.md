# Task Checkpoint Template

Use this template for large, interruptible, cross-repo, or high-risk work. Put
the checkpoint in the owning repository, usually under `docs/plans/`, unless a
child repo has a more specific convention.

For a solution investigation, bug fix, or refactor, complete the Architecture
Conformance Gate before recording the plan. Small and medium plans may record
the same gate inline instead of creating a checkpoint.

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
| Date | Decision | Reason |
| --- | --- | --- |
| YYYY-MM-DD | <Decision> | <Reason> |

## Progress
| Step | Status | Notes |
| --- | --- | --- |
| <Step> | Pending/In progress/Done/Blocked | <Notes> |

## Validation
| Guarantee | Command / Artifact | Result |
| --- | --- | --- |
| <Rule> | `<command>` or `<artifact>` | Pass/Fail/Skipped |

## Resume Notes
- <Where to continue>
- <Known blockers>
- <Files changed or intentionally left alone>
```
