---
layout: default
title: Content Structure
---

This document describes the current (as-implemented) layout of the `content/` directory and the rationale for each grouping. See [style-guide.md]({{ '/style-guide/' | relative_url }}) for voice, linking, and formatting conventions.

## Directory Tree

```
content/
├── geography.md
├── population.md
├── belief/
│   ├── ideology/
│   ├── religion/
│   │   ├── monotheist/
│   │   └── polytheist/
│   └── science/
│       ├── physical/
│       └── theoretical/
├── culture/
├── government/
│   ├── local/
│   └── national/
├── history/
├── language/
│   └── pseudo/
├── location/
│   ├── natural/
│   │   ├── continent/
│   │   ├── ecosystem/
│   │   └── feature/
│   ├── route/
│   │   └── trade/
│   └── settlement/
│       ├── city/
│       ├── outpost/
│       ├── region/
│       ├── town/
│       └── village/
├── people/
│   ├── historical/
│   └── notable/
└── species/
    ├── beasts/
    └── sapient/
```

## Category Rationale

### Root-level files
`geography.md` and `population.md` sit at `content/` root as overview/index pages that link into the detail pages below them.

### `belief/` — Systems of thought and worship
Organised by the nature of the belief system.
- `ideology/` — ethical and philosophical codes not tied to worship.
- `religion/` — faiths, split into `monotheist/` and `polytheist/`.
- `science/` — schools of thought that conflict with one another; each file represents a divergent theory.

### `culture/` — Cultural practices and events
Flat directory. No subcategorisation — each file is a distinct cultural practice, festival, or rite.

### `government/` — Governing bodies and polities
Split by governing scope.
- `local/` — bodies governing a single settlement or small area (councils, courts, compacts).
- `national/` — kingdoms, republics, leagues, and other state-level entities.

### `history/`
A loose collection of pages covering the major eras, conflicts, treaties, and turning points of the world. `timeline.md` remains the principal chronological reference; the other pages treat individual events or periods at length.

### `language/`
- `pseudo/` — non-verbal, commonly understood signalling systems (e.g. gestures, flag signals). Not full spoken languages.

### `location/` — Places in the world
Three broad types, each with sub-types:
- `natural/` — landmasses (`continent/`), biomes (`ecosystem/`), and named geographical features like oceans or straits (`feature/`).
- `route/` — travel corridors, currently only `trade/`.
- `settlement/` — inhabited places, split by size/type: `city/`, `outpost/`, `region/`, `town/`, `village/`.

### `people/` — Individual characters
Split by their status in the world's chronology.
- `historical/` — figures from the past.
- `notable/` — living or recently living figures.

### `species/` — Creatures and peoples
Split by sapience.
- `beasts/` — non-sapient animals and monsters.
- `sapient/` — intelligent, language-using species.

## Filename and Title Conventions

Filenames are kebab-case slugs without leading articles. No slug begins with `the-`; titles may begin with `The` when natural to prose (e.g. "The Stormfall Sea") but the slug itself drops the article. The front-matter `title` is title case, with articles capitalised in the usual English way.

Older entries in some directories (`belief/`, `culture/`, `language/pseudo/`, and a few of the existing entries in `location/natural/ecosystem/`) were originally created with a `the-` prefix; they remain as historical exceptions and need not be renamed unless a page is being substantially rewritten. All new pages use bare slugs.

## Page Structure

Headings are flexible. Each page should use whatever ATX heading structure best suits its subject matter, as long as the body starts at `##` (the layout renders the `h1`), headings do not skip levels, and the page contains at least 1,000 words of body prose. There is no required opening heading or closing section; pages may begin with any `##` heading and close with any section that fits the subject.

The index page (`index.md`) renders category lists through `_includes/content-list.html`, which groups pages automatically; the lists are not maintained by hand.
