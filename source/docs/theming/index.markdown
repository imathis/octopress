---
layout: page
title: "Theming &amp; Customization"
date: 2011-07-19 18:16
sidebar: false
footer: false
---

I hope to eventually release more themes, but for now Octopress ships with a single theme comprised of layouts, partials, pages, javascripts, and
Sass stylesheets located in `.themes/classic/source` and `.themes/classic/sass`.
When you install the Octopress theme, these directories are copied into `/source` and `/sass`. You are free to make any changes you like,
but I've set up a few patterns to make it easy to customize your site.

## Customizing Styles

For stylesheet customizations, check out the  `/sass/custom` directory and you'll find three files.

   _colors.scss     # Change the color scheme
   _layout.scss     # Make simple changes to the layout
   _styles.scss     # Easly Override any style

### Changing the Color Scheme

All of the colors for Octopress are defined in `/sass/base/_theme.scss` and the variables are used throughout the other stylesheets. Here's
a look at the navigation section of the theme.

{% codeblock Navigation (_theme.scss) https://github.com/imathis/octopress/tree/master/.themes/classic/sass/base/_theme.scss view on Github %}
/* Navigation */
$nav-bg: #ccc !default;
$nav-color: darken($nav-bg, 38) !default;
$nav-color-hover: darken($nav-color, 25) !default;
...
{% endcodeblock %}

The `!default` means that if the color has already been defined it will use that value instead and since `custom/_colors.scss`
is imported before the `_theme.scss` it can predefine these colors easily. There are comments to help out with this in the
[source](https://github.com/imathis/octopress/tree/master/.themes/classic/sass/custom/_colors.scss).

Many of the colors in the theme are picked using [Sass's color functions](http://sass-lang.com/docs/yardoc/Sass/Script/Functions.html).
As a result you can pick a new background color for the navigation by setting the `$nav-bg` variable
and the other colors will derived for you. This isn't perfect, but it should do a decent job with most colors.

### Changing Layout Sizes & Padding

Just like with colors, widths in `/sass/base/_layout.scss` are defined like `$max-width: 1200px !default;` and can be easily customized
by defining them in `sass/custom/_layout.scss`. Here's a look at the layout defaults.

{% codeblock Layout Defaults (_layout.scss) https://github.com/imathis/octopress/tree/master/.themes/classic/sass/base/_layout.scss view on Github %}
$max-width: 1200px !default;

// Padding used for layout margins
$pad-min: 18px !default;
$pad-narrow: 25px !default;
$pad-medium: 35px !default;
$pad-wide: 55px !default;

// Sidebar widths used in media queries
$sidebar-width-medium: 240px !default;
$sidebar-pad-medium: 15px !default;
$sidebar-pad-wide: 20px !default;
$sidebar-width-wide: 300px !default;

$indented-lists: false !default;
{% endcodeblock %}

These variables are used to calculate the width and padding for the responsive layouts. The `$indented-lists` variable allows you to
choose if you prefer indented or normal lists.

### Overriding Styles
If you want to add or override styles, edit `sass/custom/_styles.css`. This stylesheet is imported last, so you can override styles with the cascade.

## Customizing Layouts & Partials
The key source directories are as follows:

    source/
      _includes/    # main layout partials
        asides/     # sidebar partials
        post/       # post metadata, sharing & comment partials
      _layouts/     # layouts for pages, posts & category archives

It's pretty likely you'll create pages and want to add them to the main navigation partial at `source/_includes/navigation.html`.
Beyond that, I don't expect there to be a great need to change the markup very much, since the HTML is flexible and semantic and most common
customizations be taken care of [with configuration](/docs/configuring).

If you study the layouts and partials, you'll see that there's a lot of conditional markup. Logic in the view is lamentable, but a necessary
side effect of simple static site generation.

Also see [Updating Your Blog &raquo;](/docs/updating)
