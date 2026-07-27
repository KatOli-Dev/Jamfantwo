---
description: Find topics, connections, or categories that lack coverage
---

Search every file under `content/` for three kinds of gap:

1. **Unrealised mentions**: Proper nouns, named entities, or concepts that appear in prose (e.g. "the Treaty of Marak", "the Ashen Waste", "King Harald Voss") that have no corresponding file under `content/`. Cross-reference with `_includes/content-list.html` to confirm absence. Exclude entities that are clearly minor colour (named only once in passing).

2. **Thin categories**: Categories with fewer files or lower total word counts than sibling categories under the same parent. Compare file counts and prose quality across siblings (e.g. `content/religion/` vs `content/culture/`).

3. **Orphan pages**: Files under `content/` that no other content page links to. Check both markdown links and plain-text mentions. Exclude pages that are linked from `_includes/` or `_layouts/` or index files.

Report results as three sections:
```
## Unrealised mentions
content/path/to/file.md:entity name

## Thin categories
category/ — N files vs sibling-category/ — M files

## Orphan pages
content/path/to/file.md
```

Do not suggest creating pages unless asked. Just report findings.
