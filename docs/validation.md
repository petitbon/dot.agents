# Skill Validation

Run validation from the repository root:

```sh
./scripts/validate-skills.sh
```

The script verifies:

- every `skills/<skill>/` directory has `SKILL.md` and `agents/openai.yaml`;
- frontmatter `name:` matches the skill directory name;
- `references/...` paths mentioned by a skill exist;
- generated `.codesight/`, `.codegraph/`, and `.DS_Store` files are not tracked;
- the SDK release skill does not allow local publishing;
- implicit invocation policy matches the repository allowlist.

Manual review still matters for semantic changes. For skill content edits,
confirm that routing remains precise, broad skills do not over-trigger, and
domain-specific invariants still live in the owning skill or reference.
