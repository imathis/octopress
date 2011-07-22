---
layout: page
title: "Include Code"
date: 2011-07-22 09:13
sidebar: false
footer: false
---

Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
In the `_config.yml` you can set your `code_dir` but the default is `source/downloads/code`. Simply put a file anywhere under that directory and
use the following tag to embed it in a post.

#### Syntax

    {{ "{% include_code [title] url" }} %}

#### Example 1

    {{ "{% include_code javascripts/test.js" }} %}

#### Example 2 (with optional title)

    {{ "{% include_code Testing include_code javascripts/test.js" }} %}

This includes a file from `source/downloads/code/javascripts/test.js`. By default the `<figcaption>` will be the filename, but you can add a title before the filepath if you like.

#### Demo of Example 2

{% include_code Testing include_code javascripts/test.js %}
