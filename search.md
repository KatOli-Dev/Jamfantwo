---
layout: default
title: Search
---

<form id="search-form" role="search" aria-label="Site search">
  <label for="search-input" style="display:block;margin-bottom:0.5rem;font-size:1.1rem;">
    Search the archive
  </label>
  <input
    type="text"
    id="search-input"
    placeholder="Type to search…"
    autocomplete="off"
    aria-describedby="search-hint"
    style="
      width:100%;
      font:inherit;
      font-size:1.1rem;
      padding:0.65rem 1rem;
      background:rgba(0,0,0,0.45);
      border:1px solid rgba(255,255,255,0.12);
      border-radius:10px;
      color:#f0e6d2;
      outline:none;
    "
  >
  <span id="search-hint" style="display:block;margin-top:0.4rem;font-size:0.85rem;color:#8b8b9a;">
    Search across all pages by title and text
  </span>
</form>

<div id="search-results" aria-live="polite" style="margin-top:2rem;"></div>

<script>
  (function() {
    var index = null;
    var input = document.getElementById('search-input');
    var results = document.getElementById('search-results');

    function loadIndex() {
      if (index) return Promise.resolve(index);
      return fetch('/assets/search-index.json')
        .then(function(r) { return r.json(); })
        .then(function(data) {
          index = data;
          return data;
        });
    }

    function renderResults(query, data) {
      if (!query || query.length < 1) {
        results.innerHTML = '';
        return;
      }

      var q = query.toLowerCase();
      var matches = [];

      for (var i = 0; i < data.length; i++) {
        var entry = data[i];
        var haystack = (entry.title + ' ' + entry.snippet).toLowerCase();
        if (haystack.indexOf(q) !== -1) {
          matches.push(entry);
        }
      }

      if (matches.length === 0) {
        results.innerHTML = '<p style="color:#8b8b9a;">No results found.</p>';
        return;
      }

      var html = '<p style="color:#8b8b9a;margin-bottom:1rem;">' + matches.length + ' page' + (matches.length === 1 ? '' : 's') + ' found</p>';
      for (var j = 0; j < matches.length; j++) {
        var m = matches[j];
        html += '<article style="margin-bottom:1.25rem;">' +
          '<a href="' + m.url + '" style="font-size:1.15rem;font-weight:700;">' + escapeHtml(m.title) + '</a>' +
          '<p style="margin:0.25rem 0 0;font-size:0.95rem;color:#8b8b9a;">' + escapeHtml(m.snippet.substring(0, 200)) + '…</p>' +
          '</article>';
      }
      results.innerHTML = html;
    }

    function escapeHtml(str) {
      var div = document.createElement('div');
      div.appendChild(document.createTextNode(str));
      return div.innerHTML;
    }

    input.addEventListener('input', function() {
      loadIndex().then(function(data) {
        renderResults(input.value, data);
      });
    });
  })();
</script>
