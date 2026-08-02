---
layout: default
title: Recently Updated
description: The latest changes to the Jamfantwo archive, ordered by the recorded modification date of each content page.
---

<p>
  The archive's most recently modified content pages are listed below. Generated category indexes are omitted so that the list points to substantive entries.
</p>

{% assign updated_pages = site.pages | where_exp: "item", "item.path contains 'content/'" | where_exp: "item", "item.last_modified" | where_exp: "item", "item.layout != 'redirect'" | sort: "last_modified" | reverse %}

{% if updated_pages.size > 0 %}
<ol class="recently-updated-list">
  {% for item in updated_pages limit: 50 %}
  <li>
    <a href="{{ site.site_url }}{{ item.url }}">{{ item.title }}</a>
    <time datetime="{{ item.last_modified | date_to_xmlschema }}">{{ item.last_modified | date: "%Y-%m-%d" }}</time>
    {% if item.description %}
    <p>{{ item.description }}</p>
    {% endif %}
  </li>
  {% endfor %}
</ol>
{% else %}
<p>No modification dates are available.</p>
{% endif %}
