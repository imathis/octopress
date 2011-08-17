---
layout: page
title: Blogging Basics
date: July 19 2011
sidebar: false
comments: false
footer: false
---

Octopress offers some rake tasks to create post and pages preloaded with metadata and according to Jekyll's naming conventions.

## Blog Posts
Blog posts must be stored in the `source/_posts` directory and named according to Jekyll's naming conventions: `YYYY-MM-DD-post-title.markdown`. The name of the file will be used
as the url slug, and the date helps with file distinction and determines the sorting order for post loops.

Octopress provides a rake task to create new blog posts with the right naming conventions, with sensible yaml metadata.

#### Syntax

``` sh
    rake new_post["title"]
```

`new_post` expects a naturally written title and strips out undesirable url characters when creating the filename.
The default file extension for new posts is `markdown` but you can configure that in the `Rakefile`.

#### Example

``` sh
    rake new_post["Zombie Ninjas Attack: A survivor's retrospective"]
    # Creates source/_posts/2011-07-03-zombie-ninjas-attack-a-survivors-retrospective.markdown
```

The filename will determine your url. With the default [permalink settings](https://github.com/mojombo/jekyll/wiki/Permalinks) the url would be something like
`http://site.com/blog/2011/07/03/zombie-ninjas-attack-a-survivors-retrospective/index.html`.

Open a post in a text editor and you'll see a block of [yaml front matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter)
which tells Jekyll how to processes posts and pages.

``` yaml
    ---
    layout: post
    title: "Zombie Ninjas Attack: A survivor's retrospective"
    date: 2011-07-03 5:59
    comments: true
    categories:
    ---
```

Here you can turn comments off and or categories to your post. If you are working on a multi-author blog, you can add `author: Your Name` to the
metadata for proper attribution on a post. If you are working on a draft, you can add `published: false` to prevent it from being posted when you generate your blog.

You can add a single category or multiple categories like this.

``` yaml
    # One category
    categories: Sass

    # Multiple categories example 1
    categories: [CSS3, Sass, Media Queries]

    # Multiple categories example 2
    categories:
    - CSS3
    - Sass
    - Media Queries
```

## New Pages

You can add pages anywhere in your blog source directory and they'll be parsed by Jekyll. The URL will correspond directly to the filepath, so `about.markdown` will become `site.com/about.html`. If you prefer the URL `site.com/about/` you'll want to create the page as `about/index.markdown`.
Octopress has a rake task for creating new pages easily.

``` sh
    rake new_page[super-awesome]
    # creates /source/super-awesome/index.markdown

    rake new_page[super-awesome/page.html]
    # creates /source/super-awesome/page.html
```

Like with the new post task, the default file extension is `markdown` but you can configure that in the `Rakefile`. A freshly generated page might look like this.

``` yaml
    ---
    layout: page
    title: "Super Awesome"
    date: 2011-07-03 5:59
    comments: true
    sharing: true
    footer: true
    ---
```

The title is derived from the filename so you'll likely want to change that. This is very similar to the post yaml except it doesn't include categories, and you can toggle sharing and comments or remove the footer altogehter. If you don't want to show a date on your page, just remove it from the yaml.

## Generate & Preview
``` sh
    rake generate   # Generates posts and pages into the public directory
    rake watch      # Watches source/ and sass/ for changes and regenerates
    rake preview    # Watches, and mounts a webserver at http://localhost:4000
```

Using the `rake preview` server is nice, but If you're a [POW](http://pow.cx) user, you can set up your Octopress site like this.

``` sh
    cd ~/.pow
    ln -s /path/to/octopress octopress
    cd -
```

Now that you're setup with POW, you'll just run `rake watch` and load up `http://octopress.dev` instead.

Also see [Sharing Code Snippets](/docs/blogging/code) and [Blogging with Plugins](/docs/blogging/plugins)
