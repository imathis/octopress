---
layout: page
title: "Key"
date: 2011-08-03 21:47
sidebar: false
footer: false
---

The key plugin produces visual key sequences of the arguments given to
the block.

#### Syntax

    {{ "{% key Ctrl + X" }} %}.

Each item separated by a plus character will be put into a span with
the class `key` and for each plus a span with the class `key-sep` will
be inserted (the plus is added again in the style sheet). The whole key
command is then wrapped in a span with the class `key-sequence`.

To insert the plus key, escape the plus character using `\+`.

#### Examples

    Sample text with {{ "{% key some + different + keys + \+" }} %} inside.

Sample text with {% key some + different + keys + \+ %} inside.

    Pressing {{ "{% key &#8984; + Q" }} %} will quit your browser on OS X.

Pressing {% key &#8984; + Q %} will quit your browser on OS X.
