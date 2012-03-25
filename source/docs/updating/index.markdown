---
layout: page
title: "Updating Octopress"
date: 2011-07-22 19:46
sidebar: false
footer: false
---

[&laquo; Previous, Theming & Customization](/docs/theme/)

## How to Update

``` sh
    git pull octopress master     # Get the latest Octopress
    bundle install                # Keep gems updated
    rake update_source            # update the template's source
    rake update_style             # update the template's style
```

This will update your plugins, theme, gemfiles, rakefile and configs, preserving your changes as explained in [Theming &amp; Customization](/docs/theme).
Read on for an explanation of how all this works.

### How Updating Works

In the open source world, version control generally takes care of staying current with the latest releases, but once you've begun to customize your code,
merging in updates isn't always what you want. As a result I've come up with the following pattern for Octopress:

1. Plugins, configs, gemfiles, `.themes`, `.gitignore` and the `Rakefile` are all tracked for easy to updating and collaborating.

2. The install process copies layouts, pages, javascripts, and styles out of the `.themes` directory. Once you've installed a theme, none of the
files under `source` or `sass` are in any repository except your own. This way you can change them to your liking without worrying about merging in
updates and screwing up your changes.

When you pull down changes from the Octopress repository, the latest layouts, pages, javascripts and styles are merged into your `.themes` directory.
To update your site, you must manually merge in the new files. Before you do a spit-take, I written some Rake tasks to help out with this.

### Updating the Template's Style
If you've pulled in changes and you want to update your `/sass` directory, run this.

    rake update_style

This task will:

1. Move `/sass` to `/sass.old`
2. Copy `.themes/classic/sass` to `/sass`
3. Replace `/sass/custom/` with `/sass.old/custom/`

This way if you keep your theme changes in `/sass/custom` you'll be able to upgrade your stylesheets without losing any of your work. If you made changes elsewhere, you can copy them back them from `/sass.old`.
After you have the update in place, you can remove the `/sass.old` directory.

### Updating the Template's Source
If you've pulled in changes and you want to update your `/source` directory, run this.

    rake update_source

This task will:

1. Move `/source` to `/source.old`
2. Copy `.themes/classic/source` to `/source`
3. Copy back everything in `/source.old` (`cp -rn` - without replacing )
4. Replace everything in `/source/_includes/custom/` with `/source.old/_includes/custom/` which includes head, header, navigation, footer and custom asides.

This way all of the files you've added, eg. `_posts`, `about.html` etc. and all the customizations in `source/_includes/custom` will be preserved while all files tracked by Octopress will be updated.
If you made changes elsewhere, you can copy them back them from `/source.old` or check them out from your git repository. After you have the update in place, you can remove the `/source.old` directory.

## That's It?

Yep. I figured this is the simplest thing that could possibly work. I don't like the idea of having blog files change if someone wants to update their plugins,
and I haven't yet figured out a better way. If you have a better idea, [post an issue](https://github.com/imathis/octopress/issues) with your idea for improving this.

See also [Blogging With Octopress](/docs/blogging) and [Theming & Customization](/docs/theme)
