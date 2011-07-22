---
layout: page
title: "Codeblock"
date: 2011-07-22 09:13
sidebar: false
footer: false
---

With this plugin you can write blocks of code directly in your posts and optionally add titles and links.

#### Syntax

    {{ "{% codeblock [title] [url] [link text]" }} %}

#### Example 1

    {{ "{% codeblock" }} %}
    Awesome code snippet
    {{ "{% endcodeblock" }} %}

{% codeblock %}
Awesome code snippet
{% endcodeblock %}

#### Example 2

    # Including a file extension in the title enables highlighting
    {{ "{% codeblock Time to be Awesome - awesome.rb" }} %}
    puts "Awesome!" unless lame
    {{ "{% endcodeblock" }} %}

{% codeblock Time to be Awesome - awesome.rb %}
puts "Awesome!" unless lame
{% endcodeblock %}

#### Example 3

    # Add an optional URL to enable downloading or linking to source
    {{ "{% codeblock Got pain? painreleif.sh http://example.com/painreleief.sh Download it!" }} %}
    $ rm -rf ~/PAIN
    {{ "{% endcodeblock" }} %}

{% codeblock Javascript Array Syntax (array.js) https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array MDN Documentation %}
var arr1 = new Array(arrayLength);
var arr2 = new Array(element0, element1, ..., elementN);
{% endcodeblock %}

The last argument `link_text` is optional. You may want to link to a source for download file, or documentation on some other site.
