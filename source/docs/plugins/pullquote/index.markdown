---
layout: page
title: "Pullquote"
date: 2011-07-22 09:15
sidebar: false
footer: false
---

Octopress offers a CSS only technique for pull quotes, based on the technique by [Maykel Loomans](http://miekd.com/articles/pull-quotes-with-html5-and-css/).

#### Syntax

    {{ "{% pullquote" }} %}
    Surround your paragraph with the pull quote tags. Then when you come to
    the text you want to pull, {" surround it like this "} and that's all there is to it.
    {{ "{% endpullquote" }} %}

Here's a more realistic example of how you might use a pull quote.
{% pullquote %}
When writing longform posts, I find it helpful to include pull quotes to help readers easily identify the topics covered in each section. Some prefer to break things up with lots of headings, and while this seems to be a trend it doesn't work so well for long form prose.
It is important to note that {" pull quotes are merely visual in presentation and should not appear twice in the text. "} That is why it a CSS only technique for styling pull quotes is preferable. Octopress includes a handy pull quote plugin to make this easy for you.
{% endpullquote %}

**Inspect the source** and you'll see the pulled content appears in the data-pullquote attribute of the paragraph. The pull quote effect is created
entirely with CSS, and is supported by all modern browsers as well as IE8 and up.

[&laquo; Plugins page](/docs/plugins)
