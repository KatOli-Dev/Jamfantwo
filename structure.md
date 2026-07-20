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
Single `timeline.md` file containing the chronological history of the world.

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

## Page Structure Convention

Heading schemas are category-specific. There is no universal `## Overview` / `## Significance` rule. The schemas actually in use are:

### Sapient species (`content/species/sapient/*.md`)
A fixed six-section schema used by every page in this category:
1. `## Origins`
2. `## Anatomy and Physiology`
3. `## Life Cycle`
4. `## Habitat and Distribution`
5. `## Diet`
6. `## Ecology`

No `## Overview` or `## Significance` section is used.

### Historical figures (`content/people/historical/*.md`)
Begin with `## Overview`, followed by biographical sections (`Rise to Power`, `Reign`, `Legacy`, etc.). Pages in this category do not end with `## Significance`.

### Other content pages
Most other pages begin with `## Overview` and then use topic-specific sections suited to the subject. A section whose title contains `Significance` commonly closes place, polity, and creature pages, but overview pages and some established category templates may end with another subject-specific section. The validator enforces the opening heading and basic heading structure without imposing a false universal closing title.

The index page (`index.md`) renders these category lists through `_includes/content-list.html`, which groups pages automatically; the lists are not maintained by hand.
