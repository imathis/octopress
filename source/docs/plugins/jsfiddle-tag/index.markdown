---
layout: page
title: "jsFiddle Tag"
date: 2011-09-26 12:33
sidebar: false
footer: false
---

All you need is the fiddle's id and you can easily embed it in your page. 

#### Syntax
    {{ "{% jsfiddle shorttag [tabs] [skin] [height] [width]" }} %}

#### Example

    {{ "{% jsfiddle ccWP7" }} %}

{% jsfiddle ccWP7 %}


#### Adjusting Tabs

It’s possible to easily adjust the display order of the tabs. In this case, I’m moving the result to be the first item shown.

    {{ "{% jsfiddle ccWP7 result,js,html,css" }} %}

{% jsfiddle ccWP7 result,js,html,css %}


#### Presentation: Skin

We can easily adjust the skin. Right now, it looks like light and presentation are really the only supported options, but if jsFiddle announces new options, you can start using them immediately.

    {{ "{% jsfiddle ccWP7 default presentation" }} %}

{% jsfiddle ccWP7 default presentation %}

This plugin was developed by [Brian Arnold](http://brianarn.github.com/blog/2011/08/jsfiddle-plugin/).
