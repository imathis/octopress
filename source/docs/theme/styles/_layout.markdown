    # In /sass/base
    _layout.scss     # Responsive layouts are defined here

    # In /sass/custom - Change these files for easy customization
    _layout.scss     # Override settings for base/_layout.scss to change the layout

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
