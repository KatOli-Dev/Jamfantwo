---
layout: default
title: Content Structure
---

This document describes the current (as-implemented) layout of the `content/` directory and the rationale for each grouping. See [style-guide.md](/style-guide) for voice, linking, and formatting conventions.

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

Every content page opens with an `## Overview` section and closes with an `## Significance` section. This convention is enforced across all files and is not covered by the style guide.
