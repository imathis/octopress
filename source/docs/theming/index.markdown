---
layout: page
title: "Theming &amp; Customization"
date: 2011-07-19 18:16
sidebar: false
footer: false
---

For now Octopress ships with a single theme in the `.themes` directory. When you install the Octopress theme, HTML and Javascripts are copied into `/source` and Sass stylesheets are copied into `/sass`.
You are free to make any changes you like, but I've set up a few patterns to make it easy to customize and keep your site up to date with the latest Octopress releases (see [Updating Octopress](/docs/updating)).

I've broken this up into the following sections.

1. [Customizing the Template](#customizing_template)
2. [Changing the Color Scheme](#customizing_colors)
3. [Changing the Layout](#customizing_layout)
4. [Overriding styles](#overriding_styles)

<h2 id="customizing_template">Customizing the Template</h2>
{% render_partial docs/theming/_template.markdown %}

<h2 id="customizing_styles">Changing the Color Scheme</h2>
{% render_partial docs/theming/_colors.markdown %}

<h2 id="changing_layout">Changing the Layout</h2>
{% render_partial docs/theming/_layout.markdown %}

<h2 id="overriding_styles">Overriding Styles</h2>
{% render_partial docs/theming/_styles.markdown %}

Also see [Updating Your Blog &raquo;](/docs/updating)
