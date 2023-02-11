---
layout: framework
sidebar: [
  blog-category-list,
  google-adsense
]
---

<div class="articles">
  {% if page.banner == nil %}
    {% assign banner = page.title %}
  {% endif %}

  {{ content }}

  {% include views/blog.html %}
</div>
