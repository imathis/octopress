---
layout: page
title: "Codeblock"
date: 2011-07-22 09:13
sidebar: false
footer: false
---

With this plugin you can write blocks of code directly in your posts and optionally add titles and links.

#### Syntax

    {{ "{% codeblock [title] [lang:language] [url] [link text]" }} %}
    code snippet
    {{ "{% endcodeblock" }} %}

#### Example 1

    {{ "{% codeblock" }} %}
    Awesome code snippet
    {{ "{% endcodeblock" }} %}

{% codeblock %}
Awesome code snippet
{% endcodeblock %}

#### Example 2

You can also add syntax highlighting like this.

    {% raw %}{% codeblock lang:objc %}
    [rectangle setX: 10 y: 10 width: 20 height: 20];
    {% endcodeblock %}{% endraw %}

{% codeblock lang:objc %}
[rectangle setX: 10 y: 10 width: 20 height: 20];
{% endcodeblock %}

#### Example 3

Including a file extension in the title enables highlighting

    {{ "{% codeblock Time to be Awesome - awesome.rb" }} %}
    puts "Awesome!" unless lame
    {{ "{% endcodeblock" }} %}

{% codeblock Time to be Awesome - awesome.rb %}
puts "Awesome!" unless lame
{% endcodeblock %}

#### Example 4 (Force Highlighting)

Pygments supports many languages, but doesn't recognize some file extensions.
Add `lang:your_language` to force highlighting if the filename doesn't work.

    {{ "{% codeblock Here's an example .rvmrc file. lang:ruby" }} %}
    rvm ruby-1.8.6 # ZOMG, seriously? We still use this version?
    {{ "{% endcodeblock" }} %}

{% codeblock Here's an example .rvmrc file. lang:ruby %}
rvm ruby-1.8.6 # ZOMG, seriously? We still use this version?
{% endcodeblock %}

#### Example 5

Add an optional URL to enable downloading or linking to source.

    {% raw %}{% codeblock Javascript Array Syntax lang:js http://j.mp/pPUUmW MDN Documentation %}
    var arr1 = new Array(arrayLength);
    var arr2 = new Array(element0, element1, ..., elementN);
    {% endcodeblock %}{% endraw %}

{% codeblock Javascript Array Syntax lang:js http://j.mp/pPUUmW MDN Documentation %}
var arr1 = new Array(arrayLength);
var arr2 = new Array(element0, element1, ..., elementN);
{% endcodeblock %}

The last argument `link_text` is optional. You may want to link to a source for download file, or documentation on some other site.
