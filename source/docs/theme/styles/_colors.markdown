For help choosing colors check out [HSL Color Picker](http://hslpicker.com), an easy to use web based color picker.

    # In /sass/base/
    _theme.scss      # All colors are defined here

    # In /sass/custom/ - Change these files for easy customization
    _colors.scss     # Override colors in base/_theme.scss to change color schemes
    _styles.scss     # Easly Override any style (last in the cascade)


All of the colors for Octopress are defined as Sass variables in `/sass/base/_theme.scss`.
To customize your color scheme edit `sass/custom/_colors.scss` and override the colors in `sass/base/_theme.scss`.

The official Octopress site is using the default 'classic' theme with a few minor color changes to the custom colors file. Take a look at this file and you'll see some lines of sass code that have been commented out.

{% codeblock Custom Colors (sass/custom/_colors.scss) https://github.com/imathis/octopress/tree/master/.themes/classic/sass/custom/_colors.scss View on Github %}
$header-bg: #263347;
$subtitle-color: lighten($header-bg, 58);
$nav-bg: desaturate(lighten(#8fc17a, 18), 5);
$sidebar-bg: desaturate(#eceff5, 8);
$sidebar-link-color: saturate(#526f9a, 10);
$sidebar-link-color-hover: darken(#7ab662, 9);
{% endcodeblock %}

The custom colors file has some commented out colors you can use. The theme file is broken up into sections to make it easier to read through. Here's a look at the navigation section of `sass/base/_theme.scss`.

{% codeblock Navigation (sass/base/_theme.scss) https://github.com/imathis/octopress/tree/master/.themes/classic/sass/base/_theme.scss View on Github %}
/* Navigation */
$nav-bg: #ccc !default;
$nav-color: darken($nav-bg, 38) !default;
$nav-color-hover: darken($nav-color, 25) !default;
...
{% endcodeblock %}

The `!default` rule lets the variable be overridden if it is defined beforehand.
is imported before the `_theme.scss` it can predefine these colors easily. There are comments to help out with this in the
[source](https://github.com/imathis/octopress/tree/master/.themes/classic/sass/custom/_colors.scss).

Many of the colors in the theme are picked using [Sass's color functions](http://sass-lang.com/docs/yardoc/Sass/Script/Functions.html).
As a result you can pick a new background color for the navigation by setting the `$nav-bg` variable
and the other colors will derived for you. This isn't perfect, but it should do a decent job with most colors.
