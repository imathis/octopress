---
layout: page
title: "Codeblock"
date: 2011-07-22 09:13
sidebar: false
footer: false
---

With this plugin you can write blocks of code directly in your posts and optionally add titles and links.

## Syntax

    {{ "{% codeblock [lang:language] [title] [url] [link text] [start:#] [mark:#,#-#] [linenos:false]" }} %}
    code snippet
    {{ "{% endcodeblock" }} %}

### Basic options

- `[lang:language]` - Choose a language for the syntax highlighter. Passing 'plain' disables highlighting.
- `[title]` - Add a figcaption to your code block.
- `[url]` - Download or reference link for your code.
- `[link text]` - Text for the link, defaults to 'link'.

{% render_partial docs/plugins/_partials/options.markdown %}

## Examples

**1.** Here's an example without setting the language.

{% codeblock %}
Awesome code snippet
{% endcodeblock %}

*The source:*

    {{ "{% codeblock" }} %}
    Awesome code snippet
    {{ "{% endcodeblock" }} %}

**2.** This example uses syntax highlighting.

{% codeblock lang:objc %}
[rectangle setX: 10 y: 10 width: 20 height: 20];
{% endcodeblock %}

*The source:*

    {% raw %}{% codeblock lang:objc %}
    [rectangle setX: 10 y: 10 width: 20 height: 20];
    {% endcodeblock %}{% endraw %}

**3.** Including a file extension in the title can also trigger highlighting.

{% codeblock Time to be Awesome - awesome.rb %}
puts "Awesome!" unless lame
{% endcodeblock %}

*The source:*

    {{ "{% codeblock Time to be Awesome - awesome.rb" }} %}
    puts "Awesome!" unless lame
    {{ "{% endcodeblock" }} %}


**4.** Add an optional URL for downloading or linking to a source.

{% codeblock Javascript Array Syntax lang:js http://j.mp/pPUUmW MDN Documentation %}
var arr1 = new Array(arrayLength);
var arr2 = new Array(element0, element1, ..., elementN);
{% endcodeblock %}

*The source:*

    {% raw %}{% codeblock Javascript Array Syntax lang:js http://j.mp/pPUUmW MDN Documentation %}
    var arr1 = new Array(arrayLength);
    var arr2 = new Array(element0, element1, ..., elementN);
    {% endcodeblock %}{% endraw %}

**5.** This example uses a custom starting line number and marks lines 52 and 54 through 55.

{% codeblock lang:coffeescript Coffeescript Tricks start:51 mark:51,54-55 %}
# Given an alphabet:
alphabet = 'abcdefghijklmnopqrstuvwxyz'

# Iterate over part of the alphabet:
console.log letter for letter in alphabet[4..8]
{% endcodeblock %}

*The source:*

    {% raw %}{% codeblock Coffeescript Tricks lang:coffeescript start:51 mark:51,54-55 %}
    # Given an alphabet:
    alphabet = 'abcdefghijklmnopqrstuvwxyz'

    # Iterate over part of the alphabet:
    console.log letter for letter in alphabet[4..8]
    {% endcodeblock %}{% endraw %}

### Other ways to embed code snippets

You might also like to [use back tick code blocks](/docs/plugins/backtick-codeblock), [embed code from a file](/docs/plugins/include-code), or [embed GitHub gists](/docs/plugins/gist-tag).
