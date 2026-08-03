---
layout: default
image: /assets/images/banner.jpg
---

<p class="tagline">{{ site.description }}</p>

<div class="home-actions">
  <a href="{{ site.site_url }}/search/" class="button js-search-link">Search the archive</a>
  <a href="{{ site.site_url }}/random/" class="button button-secondary js-random-link" data-index-url="{{ site.site_url }}/assets/search-index.json">Take me somewhere random</a>
</div>

## Recently updated

{% assign updated_pages = site.pages | where_exp: "item", "item.path contains 'content/'" | where_exp: "item", "item.last_modified" | where_exp: "item", "item.layout != 'redirect'" | sort: "last_modified" | reverse %}

{% if updated_pages.size > 0 %}
<ol class="recently-updated-list">
  {% for item in updated_pages limit: 5 %}
  <li>
    <a href="{{ site.site_url }}{{ item.url }}">{{ item.title }}</a>
    <time datetime="{{ item.last_modified | date_to_xmlschema }}">{{ item.last_modified | date: "%Y-%m-%d" }}</time>
    {% if item.description %}
    <p>{{ item.description }}</p>
    {% endif %}
  </li>
  {% endfor %}
</ol>

[See the full list of recent changes]({{ site.site_url }}/recently-updated/)
{% endif %}
