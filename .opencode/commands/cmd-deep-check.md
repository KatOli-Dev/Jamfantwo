---
description: Flag content with weak prose or inconsistent tone
---

Review every file under `content/` for the following, referencing `structure.md` and the content-validator skill for baseline rules:

- **Vague or weak prose**: weasel words ("many", "various", "some"), passive constructions where active would be clearer, filler phrases
- **Novelistic tone**: narrative flourish, sensory description, internal perspective, or dramatic framing — rewrite as neutral encyclopedic exposition
- **Purple prose**: ornate or overwrought language, needless adjectives, metaphor clusters
- **Inconsistent register**: shifts between formal and casual, or uses of modern/slang phrasing (cf. structure.md: "No slang, modern idioms, or anachronisms")
- **Repetition**: the same point or phrasing echoed across nearby paragraphs or across pages (cf. structure.md: "Avoid mechanical repetition across pages")

For each issue found, report:
```
content/path/to/file.md:line_number: [vague|tone|purple|register|repetition] — description
```

Skip files already flagged by the validator for structural issues; focus on prose quality only. If a file has many issues, prioritise the first half of the page and pages below 1,200 words (they risk being thin).
