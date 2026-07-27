---
description: Stage all changes and commit with a generated message
---

First run `git status` and `git diff --stat` to review what changed. Stage any uncommitted changes with `git add -A`.

Write a commit message matching the project's convention: a short summary line (imperative, no period), optionally followed by a blank line and bullet points for context. Example: `Fix broken links and stale docs; replace search.md with search.html`

Do not commit generated files, node_modules, or `.opencode/` config unless the user explicitly asked to change them. Do not amend the previous commit. Do not force push.
