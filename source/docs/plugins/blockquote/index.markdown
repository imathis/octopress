---
layout: page
title: "Blockquote"
date: 2011-07-22 09:15
sidebar: false
footer: false
---

The blockquote plugin takes and author, source, title and quote, and outputs semantic HTML.

#### Syntax

    {{ "{% blockquote [author[, source]] [link] [source_link_title]" }} %}
    Quote string
    {{ "{% endblockquote" }} %}

You'll notice there are two entries for `source`; one after `author`, and one after `link`. If you are citing from a printed work or a speech or something you cannot link to,
use the first method `Author's Name, Cited Work`. If you're going to link to the work, omit the first source method, and add a source title after the link `Author's Name http://source.com Article title`.

#### Examples
Blockquote arguments are optional, you can output a plain blockquote like this.

    {{ "{% blockquote" }} %}
    Last night I lay in bed looking up at the stars in the sky and I thought to myself, where the heck is the ceiling.
    {{ "{% endblockquote" }} %}

{% blockquote %}
Last night I lay in bed looking up at the stars in the sky and I thought to myself, where the heck is the ceiling.
{% endblockquote %}

**Quote from a printed work.**

    {{ "{% blockquote Douglas Adams, The Hichhikers Guide to the Galaxy" }} %}
    Flying is learning how to throw yourself at the ground and miss.
    {{ "{% endblockquote" }} %}

{% blockquote Douglas Adams, The Hitchhikers Guide to the Galaxy %}
Flying is learning how to throw yourself at the ground and miss.
{% endblockquote %}

**Quote from Twitter**

    {{ "{% blockquote @allanbranch https://twitter.com/allanbranch/status/90766146063712256" }} %}
    Over the past 24 hours I've been reflecting on my life & I've realized only one thing. I need a medieval battle axe.
    {{ "{% endblockquote" }} %}

{% blockquote @allanbranch https://twitter.com/allanbranch/status/90766146063712256 %}
Over the past 24 hours I've been reflecting on my life & I've realized only one thing. I need a medieval battle axe.
{% endblockquote %}

**Quote from an article on the web**

    {{ "{% Seth Godin http://sethgodin.typepad.com/seths_blog/2009/07/welcome-to-island-marketing.html Welcome to Island Marketing" }} %}
    Every interaction is both precious and an opportunity to delight.
    {{ "{% endblockquote" }} %}

{% blockquote Seth Godin http://sethgodin.typepad.com/seths_blog/2009/07/welcome-to-island-marketing.html Welcome to Island Marketing %}
Every interaction is both precious and an opportunity to delight.
{% endblockquote %}

For those who appreciate the little things, you'll notice in the Twitter example above, the url is truncated and drops the protocol segment.
Sometimes (like with Twitter) ading a link title doesn't really make sense, but showing the full url is noisy and distracting.
For this reason, the blockquote plugin automatically strips out the protocol, and if the url is longer than 32 characters it truncates the url on a forward slash for beauty's sake.
