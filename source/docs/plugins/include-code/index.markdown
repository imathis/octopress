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

## Syntax

    {{ "{% include_code [title] [lang:language] path/to/file [start:#] [end:#] [range:#-#] [mark:#,#-#] [linenos:false]" }} %}

### Basic options

- `[title]` - Add a custom figcaption to your code block (defaults to filename).
- `lang:language` - Force the syntax highlighter to use this language. By default the file extension is used for highlighing, but not all extensions are known by Pygments.

{% assign show-range = true %}
{% render_partial docs/plugins/_partials/options.markdown %}

## Examples

**1.** This code snipped was included from `source/downloads/code/test.js`.

{% include_code test.js %}

*The source:*

    {{ "{% include_code test.js" }} %}

**2.** Setting a custom caption.

{% include_code ruby/test.rb Add to_fraction for floats %}

*The source:*

    {{ "{% ruby/test.rb include_code Add to_fraction for floats" }} %}

This includes a file from `source/downloads/code/ruby/test.rb`.


### Including part of a file

**3.** Embed a file starting from a specific line.

{% include_code test.js start:10 %}

*The source:* 

    {% raw %}{% include_code test.js start:10 %}{% endraw %} 

**4.** Embed a file ending at a specific line.

{% include_code test.js end:10 %}

*The source:*

    {% raw %}{% include_code test.js end:10 %}{% endraw %}

**5.** Display only the lines in a specific range.

{% include_code test.js range:5-16 %}

*The source:*

    {% raw %}{% include_code test.js range:5-16 %}{% endraw %}

### Other ways to embed code snippets

You might also like to [use back tick code blocks](/docs/plugins/backtick-codeblock) or [embed GitHub gists](/docs/plugins/gist-tag).
