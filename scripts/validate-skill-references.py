#!/usr/bin/env python3
"""Check concrete file references in every skill guide using explicit roots."""

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parent.parent
WORKSPACE = ROOT.parent
IN_WORKSPACE = (WORKSPACE / "WORKSPACE_CONTEXT.md").is_file()
CODE = re.compile(r"`([^`\n]+)`")
LINK = re.compile(r"\[[^\]]*\]\(([^\s)]+)(?:\s+\"[^\"]*\")?\)")
WORKSPACE_PATH = re.compile(r"^(?:docs|agentis-[\w-]+|sdks|services|web)/")


def target_path(source, token, markdown_link=False):
    token = token.strip("<>").split("#", 1)[0]
    if not token or re.match(r"[\w+.-]+:", token) or token.startswith("@"):
        return None
    # Templates, globs, commands, and contextual filenames are not source links.
    if re.search(r"[<>${}*?\s]", token) or "..." in token:
        return None
    if not markdown_link and ("/" not in token or not Path(token).suffix):
        return None
    if markdown_link:
        return source.parent / token
    if token.startswith("references/"):
        skill = source.relative_to(ROOT / "skills").parts[0]
        return ROOT / "skills" / skill / token
    if token.startswith(".agents/"):
        return ROOT / token.removeprefix(".agents/")
    if WORKSPACE_PATH.match(token):
        return WORKSPACE / token if IN_WORKSPACE else None
    return source.parent / token


def main():
    checked = 0
    skipped = 0
    errors = 0
    sources = sorted((ROOT / "skills").rglob("*.md"))
    for source in sources:
        for number, line in enumerate(source.read_text().splitlines(), 1):
            references = [(match, False) for match in CODE.findall(line)]
            references += [(match, True) for match in LINK.findall(line)]
            for token, markdown_link in references:
                target = target_path(source, token, markdown_link)
                if target is None:
                    if not IN_WORKSPACE and WORKSPACE_PATH.match(token):
                        skipped += 1
                    continue
                checked += 1
                if not target.is_file():
                    errors += 1
                    print(
                        f"FAIL: {source.relative_to(ROOT)}:{number} references "
                        f"missing file: {token} (resolved to {target}); "
                        "update the reference to its owning source",
                        file=sys.stderr,
                    )
    if skipped:
        print(
            f"NOTE: skipped {skipped} workspace references in standalone checkout; "
            "run validation inside the Agentis workspace to check them"
        )
    print(f"Checked {checked} file references across {len(sources)} skill guides.")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
