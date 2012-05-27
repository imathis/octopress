---
layout: page
title: "Include Code"
date: 2011-07-22 09:13
updated: 201-08-21 16:18
sidebar: false
footer: false
---

Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
In the `_config.yml` you can set your `code_dir` but the default is `source/downloads/code`. Simply put a file anywhere under that directory and
use the following tag to embed it in a post.

### Syntax

    {{ "{% include_code [title] [lang:language] path/to/file [start:#] [end:#] [range:#,#]" }} %}

### Basic
This includes a file from `source/downloads/code/test.js`.

    {{ "{% include_code test.js" }} %}

{% include_code test.js %}

### Custom title
By default the `<figcaption>` will be the filename, but you can add a title before the filepath if you like.

    {{ "{% include_code Add to_fraction for floats ruby/test.rb" }} %}

This includes a file from `source/downloads/code/ruby/test.rb`.

{% include_code Add to_fraction for floats ruby/test.rb %}

### Include part of a file

Start on line a specific line.

    {% raw %}{% include_code test.js start:10 %}{% endraw %}

{% include_code test.js start:10 %}

End on line a specific line.

    {% raw %}{% include_code test.js end:10 %}{% endraw %}

{% include_code test.js end:10 %}

Choose a custom range of lines to include.

    {% raw %}{% include_code test.js range:10,15 %}{% endraw %}

{% include_code test.js range:10,15 %}

### Force highlighting

Pygments supports many languages, but doesn't recognize some file extensions.
Add `lang:your_language` to force highlighting if the filename doesn't work.

    {{ "{% include_code test.coffee lang:coffeescript" }} %}

{% include_code test.coffee lang:coffeescript %}

