---
layout: default
title: Content Style Guide
---

## Voice and Tone
- Write as an in-world chronicler or impartial historian; stay in-world. Never address readers or reference mechanics, players, or the real world.
- Formal, measured register; clarity over archaic flourish. Descriptive but concise—show with specifics, not adjective chains.
- Present multiple perspectives on contentious or ambiguous events rather than asserting one truth.
- Third person; past tense for history and biography, present only for enduring facts (geography, architecture). No second person.

## Content File Conventions
- kebab-case filenames in `content/`, organised into subdirectories by category. Filenames are bare slugs with no leading article; do not prefix slugs with `the-`. Front matter needs `layout: default` and a title-case `title` matching the canonical name. Titles do not begin with a leading article (`The`, `A`, `An`); drop the article from the title just as it is dropped from the slug. The canonical name in prose may still take an article where natural.
- Body begins at `##`; the `h1` is rendered by the layout. ATX headings only. No bold/italic. No links in headings; use the first body paragraph to link the subject on its first mention. Blockquotes for in-world quotes. Use `-` for groups, `1.` for sequences. Paragraphs 3–7 sentences. Tables sparingly.
- Headings are flexible; see [structure.md]({{ '/structure/' | relative_url }}) for the general conventions.
- Every page must be at least 1,000 words of body prose (excluding front matter, link destinations, and fenced code blocks).
- Avoid mechanical repetition across pages: each entry should open in a way suited to its subject rather than starting every section with the same "The X is..." construction.

## Linking
- Link with site-root-relative paths (`/content/...`). Link a subject on its first mention only, using its canonical name as link text. No dead links—mention in plain text until the page exists.
- The auto-generated index and navigation use `{{ '/path/' | relative_url }}` so the same content builds correctly under any `baseurl`.

## Terminology and Consistency
- Maintain a glossary of canonical terms and spellings; use it everywhere. Define new in-world terms inline on first use.
- One spelling per term; consistent titles and honorifics across all pages.
- Standard English article usage: "a" before consonant sounds, "an" before vowel sounds (e.g., "a kingdom", "an empire", "a unified", "an inhabitant"). Watch for copy-paste slips that produce "a apple", "a independent", "an kingdom".

## World Atmosphere
- Medieval fantasy, but not grim or bleak. Honest about hardship without exaggeration; settlements are functional, not failing. Coexistence and conflict both present, neither dominant.
- Prose is English only. Anomalous scripts (Han, Hangul, Hiragana/Katakana, full-width punctuation, and similar) appearing inside English sentences indicate a copy-paste corruption and must be corrected.

## Avoid
- Emoji or pictographs; exclamation marks outside dialogue; all-caps emphasis; slang, modern idioms, or anachronistic language; duplicated content across files.

## Revisions
This is a living document and may be revised as the project evolves.
