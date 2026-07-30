# Jamfantwo (Jfw)

A medieval fantasy world-building project built with [Jekyll](https://jekyllrb.com/) 4.4.1. The world is honest about hardship without being grim or bleak, presenting multiple perspectives on contentious events.

## Quick Start

```bash
bundle install
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`. Uses a custom SASS theme with a dark-mode glassmorphism design.

## Project Structure

```
├── _includes/        # Reusable layout snippets
├── _layouts/         # Page templates
├── _sass/            # SASS partials (glassmorphism theme)
├── assets/           # CSS, JS, images
├── content/
│   ├── art/          # Arts, crafts, and creative expression
│   ├── culture/      # Customs, festivals, daily life
│   ├── economy/      # Commerce, currency, trade
│   ├── geography.md  # Physical and political geography
│   ├── government/   # Rulers, laws, factions
│   ├── history/      # Timelines, chronicles, eras
│   ├── language/     # Linguistics, naming conventions
│   ├── law/          # Legal systems and codes
│   ├── magic/        # Spellcraft, magical theory
│   ├── military/     # Forces, fortifications
│   ├── mythology/    # Legends and traditional tales
│   ├── nature/       # Flora and fauna
│   ├── people/       # Characters, biographies
│   ├── population.md # Demographics, ethnic groups
│   ├── religion/     # Faiths and beliefs
│   └── species/      # Non-human peoples and creatures
├── scripts/          # Tooling (validator, etc.)
├── structure.md      # Style guide and content rules
└── temp/             # Scratch files (gitignored)
```

## Content Organization

Content is divided into 15 categories under `content/`. Index pages are auto-generated via `_plugins/generate_category_indices.rb` — do not maintain by hand.

## Validation

A custom content validator checks source files for style and structural compliance:

```bash
ruby scripts/validate_content.rb
```

Runs against source files only; does not require a Jekyll build.

## Style Guide

See [`structure.md`](structure.md) for the full style guide. Key constraints:

- At least 1,000 words of body prose per page
- No dead links (mention in plain text until the page exists)
- No slang, modern idioms, or anachronisms
- No addressing readers or referencing the real world
- The tree is extensible — new subdirectories may be added under any category

## License

This project is dedicated to the public domain under the [Unlicense](https://unlicense.org/).
