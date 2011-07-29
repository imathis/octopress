---
layout: page
title: "Video Tag"
date: 2011-07-23 17:34
sidebar: false
footer: false
---

This plugin makes it easy to insert mp4 encoded HTML5 videos in a post. Octopress ships with javascripts which
detect mp4 video support ([using Modernizr](http://modernizr.com)) and automatically offer a flash player fallback.

#### Syntax

    {{ "{% video url/to/video [width height] [url/to/poster]" }} %}

#### Example

    {{ "{% video http://s3.imathis.com/video/zero-to-fancy-buttons.mp4 640 320 http://s3.imathis.com/video/zero-to-fancy-buttons.png" }} %}


{% video http://s3.imathis.com/video/zero-to-fancy-buttons.mp4 640 320 http://s3.imathis.com/video/zero-to-fancy-buttons.png %}

<p>You're probably using a browser which supports HTML5 video and you're looking at this page wondering if it really works.
Reloading the page with the url hash <a href="#flash-test">#flash-test</a> and you'll get to see the flash player fallback.</p>

[&laquo; Plugins page](/docs/plugins)
