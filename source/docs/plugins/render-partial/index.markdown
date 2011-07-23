---
layout: page
title: "Render Partial"
date: 2011-07-22 09:14
sidebar: false
footer: false
---

Import files on your file system into any blog post or page. As a best practice, be sure these files are included in your site's repository.

#### Syntax

    {{ "{% render_partial path/to/file" }} %}

The `render_partial` tag resolves paths to the `source` directory, so write your paths accordingly.

#### Example Usage 1
Perhaps you want to create a readme page for your blog. You have a file at `source/readme/index.markdown` and the `README.markdown` for your project is
a sibling to your source directory. To import your project's readme into your readme page, you'd do this:

    {{ "{% render_partial ../README.markdown" }} %}

#### Example Usage 2
You may have two pages which need to share some of the same content. To prevent your partial from being rendered by Jekyll as a page, add an underscore to the
beginning of the file name, or put it in a directory that begins with an underscore. For example, if you wanted multiple pages to share a table of contents, you might create `source/documentation/_partials/TOC.markdown`.
Any post or page could import this file like this:

    {{ "{% render_partial documentation/TOC.markdown" }} %}

[&laquo; Plugins page](/docs/plugins)
