---
name: content-validator
description: Validate content files for structural and style compliance, or fix failures reported by the Ruby validator script
---

The project has a custom content validator at `scripts/validate_content.rb`. It runs against source files only (no Jekyll build required) and can be invoked at any time with:

```
ruby scripts/validate_content.rb
```

## What it checks

- Front matter exists with `layout: default` and a non-empty `title`
- Body has at least 1,000 words (after stripping code blocks, links, HTML comments)
- No H1 headings in body (the layout renders the page title as H1)
- No setext-style headings (use ATX `##` syntax)
- No links inside headings
- No bold (`**`) or italic (`*`) emphasis
- No CJK / Hangul scripts (copy-paste corruption)
- No emoji or pictographs
- Correct `a`/`an` article usage (with exception list in `scripts/validator_config.yml`)
- Heading levels do not skip (e.g. H2 to H4 without H3)
- Internal links resolve to existing source pages
- Link text matches target page title (fuzzy match)
- All content pages are listed in the homepage index (no orphans)

## What it does NOT check

Prose quality, tone consistency, narrative coherence, or factual correctness across pages.

## When a check fails

The script exits with code 1 and prints each failure as:

```
content/path/to/file.md:line_number: description of the problem
```

Warnings (not blockers) are printed separately under a "Warnings" heading.
