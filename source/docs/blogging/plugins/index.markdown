---
layout: page
title: "Plugins"
date: 2011-07-22 11:18
sidebar: false
footer: false
---

There are [other plugins](/docs/plugins) for octopress, but here's an overview of the ones you'll be likely to use while blogging.
This is mainly a description and demo, so be sure to follow the links beneath each section for examples and documentation.

## Excerpts
When writing a post, you can add an HTML comment `<!--more-->` to split the post for an excerpt. Only the first section of the post, before the comment,
will show up on the blog index.

## HTML5 Video Tag
This plugin makes it easy to insert mp4 encoded HTML5 videos in a post. Octopress ships with javascripts which
detect mp4 video support ([using Modernizr](http://modernizr.com)) and automatically offer a flash player fallback.

[Examples & documentation &raquo;](/docs/plugins/video-tag/)

## Image Tag
This plugin makes it easy to insert images in a post, with optional class names, alt and title attributes.

[Examples & documentation &raquo;](/docs/plugins/image-tag/)

## Block quote

{% blockquote @AustinTaylor https://twitter.com/austintaylor/status/73136957617750016 %}
Give a man a fish, he'll have food for a day. Teach a man to fish, and he'll always come to you with his fishing problems.
{% endblockquote %}

[Examples & documentation &raquo;](/docs/plugins/blockquote/)

## Pull quote
Octopress offers a CSS only technique for pull quotes, based on the technique by [Maykel Loomans](http://miekd.com/articles/pull-quotes-with-html5-and-css/).

{% pullquote %}
When writing longform posts, I find it helpful to include pull quotes to help readers easily identify the topics covered in each section. Some prefer to break things up with lots of headings, and while this seems to be a trend it doesn't work so well for long form prose.
It is important to note that {" pull quotes are merely visual in presentation and should not appear twice in the text. "} That is why it a CSS only technique for styling pull quotes is preferable. Octopress includes a handy pull quote plugin to make this easy for you.
{% endpullquote %}

[Examples & documentation &raquo;](/docs/plugins/pullquote/)

## Code Blocks
Write blocks of code directly in your posts and optionally add titles and links.

{% codeblock Javascript Array Syntax (array.js) https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array MDN Documentation %}
var arr1 = new Array(arrayLength);
var arr2 = new Array(element0, element1, ..., elementN);
{% endcodeblock %}

[Examples & documentation &raquo;](/docs/plugins/codeblock/)

## Gist Tag
Easily embed gists in your posts or pages.

    {{ "{% gist 996818" }} %}

[Examples & documentation &raquo;](/docs/plugins/gist-tag/)

## Include Code
Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.

{% include_code Testing include_code javascripts/test.js %}

[Examples & documentation &raquo;](/docs/plugins/include-code/)

## Render Partial
Import files on your file system into any blog post or page. For example, to embed this page in another post I'd use the following code.

    {{ "{% render_partial docs/blogging/plugins/index.markdown" }} %}

[Examples & documentation &raquo;](/docs/plugins/render-partial/)

Also see the [Octopress Plugin index](/docs/plugins) for the full list of Octopress plugins.
