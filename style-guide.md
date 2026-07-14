---
layout: default
title: Content Style Guide
---

## Voice and Tone

- Write as an in-world chronicler or impartial historian. The narrator is someone within or observing the world, not a game master addressing players.
- Use a formal, measured register. Favour clarity over archaic flourish. A touch of old-world flavour is welcome, but never at the expense of readability.
- Be descriptive but concise. Paint a picture with specific details rather than long adjective chains.
- Avoid breaking the fourth wall. Do not reference mechanics, readers, players, or the real world.
- When writing about contentious or ambiguous events in the world, present multiple perspectives rather than asserting a single truth.

## Perspective and Tense

- Use third person for all content.
- Use past tense for historical events, biographies, and things that have already happened.
- Use present tense only when describing geography, architecture, or other enduring facts (e.g., 'The city of Eldmouth sits on the western coast').
- Avoid second person entirely.

## Spelling and Language

- Use British English spelling consistently (e.g., favour, honour, colour, centre, travelled, labelled, defence).
- Use single quotation marks for quotations and article titles within text.
- Use the serial (Oxford) comma in lists of three or more items.
- Do not use contractions in prose. Write 'do not' rather than 'don't'. Contractions are permitted within direct dialogue in quoted speech.

## Capitalisation

- Capitalise proper nouns: specific people, places, organisations, events, and titles when used with a name (e.g., King Aldric, the Kingdom of Vael, the Sunken War).
- Use lowercase for generic terms even when referring to a specific instance (e.g., the king, the kingdom, the war, the northern mountains).
- Capitalise the full formal name of an institution, but lowercase shortened forms (e.g., the Order of the Silver Flame, thereafter the order).
- Capitalise the names of races and peoples when used as proper nouns, but lowercase when used as adjectives (e.g., the Dwarves of Karhold, thereafter dwarven architecture).

## Numbers, Dates, and Measurements

- Spell out numbers from zero to ninety-nine in prose. Use numerals for 100 and above.
- Use numerals for precise measurements, distances, and quantities with units (e.g., 12 miles, 5 kilograms).
- In-world dates should follow the established calendar system of the project. If no calendar system has been established yet, use a consistent placeholder format and note it.
- Spell out ordinal numbers in prose (e.g., first, second, third).
- Avoid starting a sentence with a numeral. Reorder the sentence or spell the number out.

## Naming Conventions for Content Files

- Use kebab-case for all filenames: lowercase letters with words separated by hyphens (e.g., `the-sunken-war.md`, `kingdom-of-vael.md`, `aldric-the-pale.md`).
- Filenames should be short, descriptive, and match the primary subject's name or title.
- All content files live directly in the `content/` directory. Do not create subdirectories at this stage.
- Each file must have a Jekyll front matter block with at minimum a `title` and `layout`.

```yaml
---
layout: default
title: The Sunken War
---
```

- The `title` field uses title case and should match the canonical in-world name.

## Markdown Formatting

- Use ATX-style headings (`#`, `##`, `###`). Do not use Setext-style underlines.
- Begin content at the `##` heading level. The top-level heading (`h1`) is rendered by the layout and should not appear in content files.
- Do not use bold or italic formatting in content files.
- Use blockquotes for in-world quotations, excerpts, or in-character writing.
- Use unordered lists (`-`) for groups without hierarchy and ordered lists (`1.`) for sequential items.
- Keep paragraphs to three to seven sentences. Break longer passages into multiple paragraphs.
- Use tables sparingly and only for structured data (e.g., timelines, comparisons).

## Linking and Cross-References

- Link to other content pages using paths relative to the site root (e.g., `[Kingdom of Vael](/content/kingdom-of-vael)`).
- When a subject is mentioned for the first time on a page and has its own content page, link to it. Do not link every subsequent mention.
- Use the canonical in-world name as the link text, not the URL or a generic phrase.
- Until a content page exists for a subject, do not create dead links. Mention the subject in plain text and add the link once the page is written.

## Terminology and Consistency

- Maintain a glossary of canonical terms, names, and spellings. Every content file should use the established spelling from the glossary.
- When introducing a new in-world term for the first time, provide a brief inline definition or context.
- Pick one spelling and stick with it. Do not alternate between variant spellings (e.g., magick and magic, elfs and elves).
- In-world titles and honorifics should be consistent across all pages. If a ruler is called King in one article, do not call them Queen or Sovereign in another unless the change is intentional and explained.

## What to Avoid

- Do not use emoji or pictographic symbols in content.
- Do not use exclamation marks in narration. They are permitted only in quoted dialogue.
- Do not use all-caps for emphasis.
- Do not use slang, modern idioms, or anachronistic language that breaks the medieval fantasy setting.
- Do not duplicate content across files. If information is relevant to two pages, write it in detail on the primary page and summarise or link on the other.

## Revisions

This style guide is a living document and may be revised as the project evolves.
