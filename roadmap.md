# Roadmap

Long-term planning and improvement ideas for Jamfantwo. Prioritised by impact.

---

## P0 — Fixes (do first)

- [x] **README is stale.** README no longer contains stale stats or directory listing — resolved.
- [x] **404 page broken link.** The broken `/content/belief/ideology/open-hand` link has been removed from the 404 page — resolved.
- [x] **Sync magic subs between validator and index include.** The include lists `tradition,working,relic,practitioners,phenomena`; the validator lists `law,relic,tradition,working,practitioners,phenomena`. `law` is missing from the include (or vice versa).

---

## P1 — High impact

- [x] **Add search.** Jekyll plugin (`_plugins/generate_search_index.rb`) builds a JSON index on every build/serve; `search.html` page at `/search/` does client-side filtering. Standalone script at `scripts/generate_search_index.rb` for manual use. No external dependencies.
- [ ] **Deploy the site.** CI builds but never publishes. `_config.yml` still has `url: http://localhost:4000`. GitHub Pages, Netlify, or Cloudflare Pages would work.
- [x] **Better navigation.** Header only links to Geography, Population, Style, and License — none of the large categories (Species, Locations, History, Magic, etc.). Consider a category dropdown, a secondary nav, or sidebar.
- [x] **Add `description` to front matter on every page.** All pages now include a `description` field in front matter per the style guide.
- [ ] **Consolidate duplicate content.** The Still Flame is covered in both `content/culture/still-flame.md` and `content/religion/still-flame.md` with different titles and vantage points. One page should redirect or merge to eliminate redundancy.
- [x] **CI for content validation.** There is no CI workflow at all. Add a GitHub Actions workflow that runs `scripts/validate_content.rb` on push and PR to catch regressions before merge.

---

## P2 — Medium impact

- [ ] **Add SEO meta tags and sitemap.** Custom `_plugins/` scripts (like the search plugin) can generate OG/Twitter meta tags and an XML sitemap without external gems.
- [ ] **Breadcrumb index pages.** Content subdirectories (`content/location/settlement/city/`, etc.) have no `index.md`, so breadcrumb segments render as plain text. Lightweight index pages would turn them into links.
- [ ] **Denser internal linking.** Many pages reference other topics inline without linking them. A pass to add links where natural would improve discoverability.
- [ ] **Densify `_config.yml`.** Add `author`, `social`, `lang` declaration, and remove the placeholder `localhost` URL.
- [ ] **Add RSS/Atom feed.** A custom `_plugins/` script can generate an RSS/Atom feed on build without external gems.
- [ ] **Pre-commit hook for content validation.** Run the validator automatically before each commit so style regressions never reach the repo.
- [ ] **Search UX improvements.** Current search is exact substring match. Add fuzzy matching, typo tolerance, and result snippet highlighting for a better experience across 600+ pages.
- [ ] **"Last modified" dates on pages.** Use git timestamps to show when each page was last updated, giving readers a sense of content freshness. Could be a `_plugins/` script that injects a `last_modified` field into each page's data.
- [ ] **Validator: check hard style constraints.** The style guide bans slang, modern idioms, addressing readers, or referencing the real world, but the validator does not check these. Add regex patterns to catch violations automatically.

---

## Notes

- The validator (`scripts/validate_content.rb`) only performs basic structural and style checks (word count, front matter, heading levels, article usage, CJK corruption, link resolution, orphan detection). It does not evaluate prose quality, tone consistency, narrative coherence, or factual correctness across pages.

## P3 — Longer term / Aspirational

- [ ] **In-universe maps.** Even a described "cartographer's view" page or an SVG region map would ground the geography-heavy content.
- [ ] **Add more perspectival writing.** The style guide asks for multiple perspectives on contentious events. Many category pages (species, locations) stay descriptive/survey mode. A pass to introduce in-universe disagreement would add depth.
- [ ] **Distinctive world elements.** The world leans toward standard epic fantasy (elves, dwarves, orcs). Consider introducing elements that make it uniquely memorable beyond solid craft.
- [ ] **SCSS linting.** Leverage existing tooling or a custom script for SCSS checks to avoid new dependencies.
- [ ] **Validator enhancement.** Add a check that link target parent directories exist (catches phantom paths like `content/belief/`).
- [ ] **Sitemap link in footer.** Once a sitemap exists, link it from the footer for crawlers.
- [ ] **Glossary / term index.** Auto-generated index of in-universe terms (e.g., *working*, *pattern*, *hearth-hall*, *Sky Walkers' Way*) extracted from page content, linking back to the pages that define them.
- [ ] **Print stylesheet.** Add `@media print` styles so pages render cleanly on paper — no navigation, full-width text, visible link URLs.
- [ ] **Light / dark theme toggle.** Currently forced dark mode. A persisted toggle would let readers choose their preference.
