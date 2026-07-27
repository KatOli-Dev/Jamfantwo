# Roadmap

Long-term planning and improvement ideas for Jamfantwo. Prioritised by impact.

---

## P0 — Fixes (do first)

- [ ] **README is stale.** Says ~390 pages / 282,000 words; actual is 613 pages / ~877,000 words. Directory listing also wrong (lists `belief/` — does not exist as a top-level dir).
- [ ] **404 page broken link.** `/content/belief/ideology/open-hand` references a `belief/` directory that doesn't exist. Content lives under `content/religion/`.
- [ ] **Sync magic subs between validator and index include.** The include lists `tradition,working,relic,practitioners,phenomena`; the validator lists `law,relic,tradition,working,practitioners,phenomena`. `law` is missing from the include (or vice versa).

---

## P1 — High impact

- [x] **Add search.** Jekyll plugin (`_plugins/generate_search_index.rb`) builds a JSON index on every build/serve; `search.md` page at `/search/` does client-side filtering. Standalone script at `scripts/generate_search_index.rb` for manual use. No external dependencies.
- [ ] **Deploy the site.** CI builds but never publishes. `_config.yml` still has `url: http://localhost:4000`. GitHub Pages, Netlify, or Cloudflare Pages would work.
- [ ] **Better navigation.** Header only links to Geography, Population, Style, and License — none of the large categories (Species, Locations, History, Magic, etc.). Consider a category dropdown, a secondary nav, or sidebar.
- [ ] **Add `description` to front matter on every page.** No page has a description meta tag. Even one sentence per page would improve SEO, link previews, and usability.

---

## P2 — Medium impact

- [ ] **Add `jekyll-seo-tag` and `jekyll-sitemap`.** Both are standard Jekyll plugins. Would generate proper OG/Twitter meta tags and an XML sitemap automatically.
- [ ] **Breadcrumb index pages.** Content subdirectories (`content/location/settlement/city/`, etc.) have no `index.md`, so breadcrumb segments render as plain text. Lightweight index pages would turn them into links.
- [ ] **Denser internal linking.** Many pages reference other topics inline without linking them. A pass to add links where natural would improve discoverability.
- [ ] **Densify `_config.yml`.** Add `author`, `social`, `lang` declaration, and remove the placeholder `localhost` URL.
- [ ] **Add RSS/Atom feed.** `jekyll-feed` is a bundled plugin. Readers and feed aggregators would pick up new/updated pages.

---

## Notes

- The validator (`scripts/validate_content.rb`) only performs basic structural and style checks (word count, front matter, heading levels, article usage, CJK corruption, link resolution, orphan detection). It does not evaluate prose quality, tone consistency, narrative coherence, or factual correctness across pages.

## P3 — Longer term / Aspirational

- [ ] **In-universe maps.** Even a described "cartographer's view" page or an SVG region map would ground the geography-heavy content.
- [ ] **Add more perspectival writing.** The style guide asks for multiple perspectives on contentious events. Many category pages (species, locations) stay descriptive/survey mode. A pass to introduce in-universe disagreement would add depth.
- [ ] **Distinctive world elements.** The world leans toward standard epic fantasy (elves, dwarves, orcs). Consider introducing elements that make it uniquely memorable beyond solid craft.
- [ ] **SCSS linting.** Add `stylelint` for SCSS to catch issues before build.
- [ ] **Validator enhancement.** Add a check that link target parent directories exist (catches phantom paths like `content/belief/`).
- [ ] **Sitemap link in footer.** Once a sitemap exists, link it from the footer for crawlers.
