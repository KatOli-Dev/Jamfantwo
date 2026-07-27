---
name: search-index
description: Regenerate the site search index outside of a Jekyll build, or troubleshoot search functionality
---

The search index is generated automatically by the Jekyll plugin at `_plugins/generate_search_index.rb`. It runs on every `jekyll build` and `jekyll serve` — no action needed during normal development.

## Standalone regeneration

If you need to regenerate the index without a full Jekyll build (e.g. the file at `_site/assets/search-index.json` is stale and you want to test the search page without rebuilding):

```
ruby scripts/generate_search_index.rb
```

This writes to `assets/search-index.json` in the source tree, which the dev server serves directly.

## Search page

The search interface lives at `search.html` (served at `/search/`). It fetches the JSON index and does client-side filtering. No server-side processing or external dependencies.

## Troubleshooting

- If search returns no results, check that the index is being served by visiting `/assets/search-index.json` directly in the browser.
- If the index is missing, run `bundle exec jekyll build` (the plugin generates it during the `:post_write` hook) or use the standalone script above.
- The search uses simple substring matching against title + body snippet — it does not support fuzzy matching or typo tolerance.
