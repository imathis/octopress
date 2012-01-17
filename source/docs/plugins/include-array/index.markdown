---
layout: page
title: "Include Array Plugin"
date: 2011-08-02 00:10
footer: false
sidebar: false
---

This plugin was created for Octopress by [Jason Woodward](http://www.woodwardjd.com) to make it possible to manage order of the sidebar partials from the `_confgi.yml`.
This is mostly useful for those working on an Octopress theme.

### First, How Partials Work
Jekyll allows you to include partials from the `/source/_includes` directory as follows:

``` html
    {% raw %}{% include partial.html %}{% endraw %}
```

This will embed the contents of `/source/_includes/partial.html` in place of the snippet above.

### Now, How Include Array Works

First add an array pointing to a list of partials underneath `/source/_includes`

``` yaml
    asides: [asides/about.html, asides/social.html]
```

Now from within a template you can render the partials from the yaml array like this.

``` html
    {% raw %}{% include_array asides %}{% endraw %}
```

Octopress uses `include_array` to allow configuration of different sidebars for each layout.
