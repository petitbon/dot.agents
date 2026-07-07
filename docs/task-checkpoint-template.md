# Task Checkpoint Template

Use this template for large, interruptible, cross-repo, or high-risk work. Put
the checkpoint in the owning repository, usually under `docs/plans/`, unless a
child repo has a more specific convention.

```markdown
# <Task Title>

## Goal
- <Concrete outcome>

## Constraints
- <Owned repos/files>
- <Non-goals>
- <Forbidden side effects>

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
