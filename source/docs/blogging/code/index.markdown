---
layout: page
title: "Sharing Code Snippets"
date: 2011-07-19 18:10
sidebar: false
footer: false
---

Sharing code is important, and blogging about it should be easy and beautiful.
That's why Octopress is packed with features to make blogging your code a breeze.
Though Jekyll comes with support for [Pygments syntax highlighting](http://pygments.org),
Octopress makes it way better. Here's how.

- A Sass port of [Solarized syntax highlighting](http://ethanschoonover.com/solarized) created specifically for Octopress
- Gist code embedding - by [Brandon Tilly](https://gist.github.com/1027674)
- Insert code snippets from your filesystem with a download link.
- Easy inline code blocks with `<figure>` and `<figcaption>` and optional download links.
- Pygments caching - a [Jekyll community plugin](https://github.com/rsim/blog.rayapps.com/blob/master/_plugins/pygments_cache_patch.rb)
- Table based line numbers added with javascript

## Gist Code embedding
All you need is the gist's id and you can easily embed it in your page. This actually downloads a cache of the gist and embeds it in a `<noscript>` tag for RSS
readers and search engines, while still using Github's javascript gist embed code for browsers.

    {{ "{% gist 996818" }} %}

The output looks like this:

{% gist 996818 %}

If you have a gist with multiple files, you can include files one at a time by adding the name after the gist id.

    {{ "{% gist 1059334 svg_bullets.rb" }} %}
    {{ "{% gist 1059334 usage.scss" }} %}

## Include Code Snippets
Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
In the `_config.yml` you can set your `code_dir` but the default is `source/downloads/code`. Simply put a file anywhere under that directory and
use the following tag to embed it in a post.

    {{ "{% include_code javascripts/test.js" }} %}

    # or with optional title
    {{ "{% include_code Testing include_code javascripts/test.js" }} %}

This includes a file from `source/downloads/code/javascripts/test.js`. By default the `<figcaption>` will be the filename, but you can add a title before the filepath if you like.
Here's what it looks like:

{% include_code Testing include_code javascripts/test.js %}

## Inline Codeblocks
You can also write blocks of code directly in your posts.

{% codeblock %}
Awesome sauce Is Awesome.
{% endcodeblock %}
