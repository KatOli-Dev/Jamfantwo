# Roadmap

Long-term planning and improvement ideas for Jamfantwo. Prioritised by impact.

---

## P0 — Fixes (do first)

- [x] **README is stale.** README no longer contains stale stats or directory listing — resolved.
- [x] **404 page broken link.** The broken `/content/belief/ideology/open-hand` link has been removed from the 404 page — resolved.
- [x] **Align magic category coverage.** Resolved by replacing the static category include with generated category indices; the validator and site index now cover the same magic content tree.

---

## P1 — High impact

- [x] **Add search.** Jekyll plugin (`_plugins/generate_search_index.rb`) builds a JSON index on every build/serve; `search.html` page at `/search/` does client-side filtering. No external dependencies.

- [x] **Better navigation.** The header now provides a responsive Categories dropdown populated from `_data/navigation.yml`, alongside search and license links.
- [x] **Add `description` to front matter on content pages.** Content pages now include a `description` field in front matter per the style guide.
- [x] **Consolidate duplicate content.** `content/culture/still-flame.md` now redirects to the canonical `content/religion/still-flame.md` page.
- [x] **CI for content validation.** GitHub Actions now runs `scripts/validate_content.rb` on pushes and pull requests, alongside the strict Jekyll build.

---

## P2 — Medium impact

- [x] **Add OG/Twitter meta tags.** Open Graph and Twitter Card `<meta>` tags added to `_layouts/default.html` via Liquid — no plugin needed.
- [x] **Generate XML sitemap.** `_plugins/generate_sitemap.rb` builds a `sitemap.xml` at the site root on each build, listing all pages with their timestamps.
- [x] **Breadcrumb index pages.** Content subdirectories had no `index.md`, so breadcrumb segments rendered as plain text. Now auto-generated via `_plugins/generate_category_indices.rb`.
- [x] **Denser internal linking.** Cross-references were added throughout the content where related topics are first mentioned, improving discoverability.
- [ ] **Complete `_config.yml` metadata.** `authors` and `lang` are present, but `social` is absent and `url` still points to `http://localhost:4000`. Set both when the production host is chosen.
- [x] **Add RSS/Atom feed.** `_plugins/generate_atom_feed.rb` generates `feed.xml` on each build without external gems.
- [x] **Pre-commit hook for content validation.** `.githooks/pre-commit` runs the validator on staged content files before each commit; `core.hooksPath` set to `.githooks/`.
- [x] **Search UX improvements.** Fuzzy matching (bigram Dice coefficient + Levenshtein distance), typo tolerance, and `<mark>` highlighting applied to both title and snippet in results.
- [x] **"Last modified" dates on pages.** `_plugins/inject_last_modified.rb` injects `last_modified` from git timestamps; displayed below title on content pages.
- [x] **Validator: check hard style constraints.** The validator now loads regex-based style constraints from `scripts/validator_config.yml` and checks for direct reader address and anachronistic or real-world terms.

---

## Notes

- The validator (`scripts/validate_content.rb`) only performs basic structural and style checks (word count, front matter, heading levels, article usage, CJK corruption, link resolution, orphan detection). It does not evaluate prose quality, tone consistency, narrative coherence, or factual correctness across pages.

## P3 — Longer term / Aspirational

- [x] **Deploy the site.** The site is deployed on GitHub Pages.
- [ ] **In-universe maps.** Even a described "cartographer's view" page or an SVG region map would ground the geography-heavy content.
- [ ] **SCSS linting.** Leverage existing tooling or a custom script for SCSS checks to avoid new dependencies.
- [ ] **Mundane medicine.** Surgery, midwifery, infirmaries, and herbalism practised outside the Art — the healing arts of the non-practitioner are untouched.
- [ ] **Cuisine and cooking.** Regional dishes, cooking methods, and kitchen customs from the Vael valley to the Sahrani suq.
- [ ] **Writing systems.** The scripts and alphabets in which the spoken languages of the world are recorded — thirteen spoken tongues with no treatment of their written forms.
- [ ] **Philosophy and ethics.** Traditions of ethical thought, virtue, and the good life among the peoples — the Unwritten Name hints at a broader intellectual landscape that remains unexplored.
- [ ] **Dance traditions.** Ceremonial, social, and ritual dance forms of the different peoples — theatre and music are covered but dance is absent.
- [ ] **Games, sports, and pastimes.** Board games, horse racing, archery contests, children's games, and other leisure activities across the known world.
- [ ] **Ceremony and courtly life.** Audiences, diplomatic protocol, precedence, and the rituals of court — the political culture behind the government structures.
- [ ] **Weather and climate.** Prevailing winds, monsoons, and regional climate patterns that shape travel, farming, and trade — geography has only a single overview page.
- [ ] **Children's lore.** Lullabies, nursery tales, and bedtime stories — what children hear at the hearth before they learn the grand myths.
- [ ] **Mathematics.** Number systems, arithmetic, and geometry for surveyors, navigators, and architects — the quantitative foundation beneath the trade and navigation pages.
- [ ] **Folk heroes.** Trickster tales and folk hero legends passed down outside the historical record — distinct from mythology and from the documented lives in `content/people/`.
- [ ] **Famous vessels.** Notable ships with histories and legends of their own, from the Star-Seeker's successors to the great war galleys of the present age.
- [ ] **Education and scholarship.** Academies, scholarly traditions, and institutions of higher learning outside the magical traditions — the childhood page covers rearing but not the life of the mind beyond it.
- [ ] **Engineering.** Bridges, aqueducts, siege engines, and mechanical works — the technical craft distinct from architectural style, underpinning the public-works and fortifications pages.
- [ ] **Cross-cultural festival calendar.** A consolidated overview of observances and holy days across the cultures, complementing the individual festival pages scattered through `content/culture/`.
- [ ] **Major trade goods overview.** A single survey page of the principal commodities moving along the trade routes, tying together the individual pages on salt, spices, textiles, metals, and timber.
- [ ] **404 page links to deep pages, not category indices.** The 404 page links to specific content pages (e.g. `/content/species/sapient/humans`) that could move; it should link to the auto-generated index pages instead.
- [ ] **robots.txt does not reference the sitemap.** Add a `Sitemap:` directive so crawlers can discover `sitemap.xml` automatically.
- [ ] **No default social/OG image.** Only the homepage has `page.image`; every other page shares the same text-only Open Graph card. A default site banner would improve link previews.
- [ ] **No table of contents on content pages.** Pages run 1,000+ words; an auto-generated TOC from H2/H3 headings would aid navigation on long articles.
- [ ] **No "recently updated" page.** `last_modified` timestamps are injected and shown on individual pages but not aggregated anywhere in-site. A "What's new" page would surface recent changes alongside the Atom feed.
- [ ] **Redundant CI workflows.** `ci.yml` and `validate.yml` both run the validator on overlapping branch triggers; they should be consolidated into a single workflow.
- [ ] **Glossary data is manually maintained.** The glossary page is generated by `_plugins/generate_glossary.rb`, but `_data/glossary.yml` remains hand-curated and may fall behind the content. Generate its entries from tagged front matter or page content.
- [x] **Random page feature.** The navigation and `/random/` page use a lightweight JS script to choose a random content URL from the generated search index.
