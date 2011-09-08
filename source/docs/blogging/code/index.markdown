---
layout: page
title: "Sharing Code Snippets"
date: 2011-07-19 18:10
sidebar: false
footer: false
---
[&laquo; Previous, Blogging Basics](/docs/blogging)

Sharing code is important, and blogging about it should be easy and beautiful.
That's why Octopress is packed with features to make blogging your code a breeze.
Though Jekyll comes with support for [Pygments syntax highlighting](http://pygments.org),
Octopress makes it way better. Here's how.

- A Sass port of [Solarized syntax highlighting](http://ethanschoonover.com/solarized) created specifically for Octopress.
- Gist code embedding - by [Brandon Tilly](https://gist.github.com/1027674).
- Insert code snippets from your filesystem with a download link.
- Easy inline code blocks with `<figure>` and `<figcaption>` and optional download links.
- Pygments caching - a [Jekyll community plugin](https://github.com/rsim/blog.rayapps.com/blob/master/_plugins/pygments_cache_patch.rb).
- Table based line numbers added with javascript.

## Solarized Highlighting

[Solarized](http://ethanschoonover.com/solarized) has a beautiful syntax highlighting color scheme, but reproducing it requires a highly sophisticated highlighting engine.
[Pygments](http://pygments.org) (the highlighter Jekyll uses) processes code snippets into styleable HTML, but it isn't nearly as powerful as the highlighting engine in Vim for example.
In order to port Solarized theme to octopress, I processed its [test files](https://github.com/altercation/solarized/tree/master/utils/tests) with Pygments and styled the output with Sass while comparing
them to the Vim rendered versions.

Check out the [test page](/docs/blogging/code/test) to see the results.

## Backtick Code Blocks
{% render_partial docs/plugins/backtick-codeblock/index.markdown %}

## Gist Embedding
{% render_partial docs/plugins/gist-tag/index.markdown %}

## Include Code Snippets
{% render_partial docs/plugins/include-code/index.markdown %}

## Inline Code Blocks
{% render_partial docs/plugins/codeblock/index.markdown %}

Also, see [Blogging with Plugins](/docs/blogging/plugins) and [The Octopress plugins page](/docs/plugins)

