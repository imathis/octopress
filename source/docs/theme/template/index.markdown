---
layout: page
title: "Theming &amp; Customization"
date: 2011-08-01 21:16
sidebar: false
footer: false
---

Shortly after the 2.0 release Octopress added the `source/_includes/custom` directory. If you don't have this, you'll want to [update](/docs/updating) because it's really nice.

    source/
      _includes/    # Main layout partials
        custom/     # <- Customize head, header, navigation, footer, and sidebar here
        asides/     # Theme sidebar partials
        post/       # post metadata, sharing & comment partials
      _layouts/     # layouts for pages, posts & category archives

## Changing the &lt;HEAD&gt;

If you want to add to the `<HEAD>`take a look at `/source/_includes/custom/head.html`.

{% codeblock &lt;HEAD&gt; (source/_includes/custom/head.html) %}
{% render_partial ../.themes/classic/source/_includes/custom/head.html raw %}
{% endcodeblock %}

Here you can easily change or remove the [Google Webfonts](http://google.com/webfonts), insert javascripts, etc.


### Changing the sidebar
Octopress integrates with some [3rd party services](/docs/configuring/#third_party) like Twitter, Pinboard and Delicious which appear in the sidebar.
In the `_config.yml` you can rearrange these, create custom sidebars for each layout, and add your own sidebar sections.

{% codeblock Sidebar configuration (_config.yml) %}
default_asides:   [asides/recent_posts.html, asides/twitter.html, asides/delicious.html, asides/pinboard.html]
# blog_index_asides:
# post_asides:
# page_asides:
{% endcodeblock %}

If you want to add a section to your sidebar, create a new file in `source/_includes/custom/asides/`.
Since many people probably want to add an About Me section, there's already an `about.html` file in there waiting to be added. Here's a look.

{% codeblock About Me (source/_includes/custom/asides/about.html) %}
{% render_partial ../.themes/classic/source/_includes/custom/asides/about.html raw %}
{% endcodeblock %}

Whenever you add a section to the sidebar, follow this pattern, with a `<section>` block and an `<h1>` for a title. To add it to the sidebar, edit the `_config.yml` and add it to the list of asides.

{% codeblock Sidebar configuration (_config.yml) %}
default_asides:     [asides/recent_posts.html, asides/twitter.html, asides/delicious.html, asides/pinboard.html]
blog_index_asides:  [custom/asides/about.html, asides/recent_posts.html, asides/twitter.html, asides/delicious.html, asides/pinboard.html]
post_asides:        [custom/asides/about.html, asides/recent_posts.html, asides/twitter.html, asides/delicious.html, asides/pinboard.html]
# page_asides:
{% endcodeblock %}

In the configuration above I've added the about page to the blog index and post pages. Since `page_asides` isn't being set, it will inherit from the default list.

## Changing the Header, Navigation & Footer

These are sections of the site that are most likely to be customized. You can edit each in `/source/_includes/custom/` and your changes will be preserved across updates.

### Changing the Header

The header title and subtitle should be configured in the `_config.yml` If you want to make other changes to the header, edit `/source/_includes/custom/header.html` which looks like this:

{% codeblock Header (source/_includes/custom/header.html) %}
{% render_partial ../.themes/classic/source/_includes/custom/header.html raw %}
{% endcodeblock %}

### Changing the Navigation

To change or add links to the main navigation, edit `/source/_includes/custom/navigation.html` which looks like this:

{% codeblock Navigation (source/_includes/custom/navigation.html) %}
{% render_partial ../.themes/classic/source/_includes/custom/navigation.html raw %}
{% endcodeblock %}

The `href` for each link begins with `{% raw %}{{ root_url }}{% endraw %}` (this helps Octopress write urls differently if a site is deployed to a subdirectory).
If you're deploying your site to a subdirectory like `yoursite.com/octopress` you'll want to add this to any links you add.

### Changing the Footer

You can customize the footer in `source/_includes/custom/footer.html` which looks like this:

{% codeblock Footer (source/_includes/custom/footer.html) %}
{% render_partial ../.themes/classic/source/_includes/custom/footer.html raw %}
{% endcodeblock %}

Change this however you like, but be cool and keep the Octopress link in there.
