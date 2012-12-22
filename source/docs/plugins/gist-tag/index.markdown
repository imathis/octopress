---
layout: page
title: "Gist Tag"
date: 2011-07-22 09:13
sidebar: false
footer: false
---

All you need is the gist's id and you can easily embed it in your page. This actually downloads a cache of the gist and embeds it in a `<noscript>` tag for RSS
readers and search engines, while still using Github's javascript gist embed code for browsers.

#### Syntax

    {{ "{% gist gist_id [filename]" }} %}

#### Example

    {{ "{% gist 4321346" }} %}

{% gist 4321346 %}

If you want syntax highlighting (for a [supported language](http://pygments.org/docs/lexers/)), specify the filename (with extension):

    {{ "{% gist 4321346 gistfile1.diff" }} %}

{% gist 4321346 gistfile1.diff %}

If you have a gist with multiple files, you can include files one at a time by adding the name after the gist id.

    {{ "{% gist 1059334 svg_bullets.rb" }} %}
    {{ "{% gist 1059334 usage.scss" }} %}

This plugin was initially developed by [Brandon Tilly](http://brandontilley.com/2011/01/31/gist-tag-for-jekyll.html) for Jekyll blogs.
