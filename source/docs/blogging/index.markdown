---
layout: page
title: Blogging Basics
date: July 19 2011
sidebar: false
comments: false
footer: false
---

Create your first post.

    rake new_post["hello world"]

This will put a new post with a name like like `2011-07-3-hello-world.markdown` in the `source/_posts` directory.
The filename will determine your url, and depending on your [permalink settings](https://github.com/mojombo/jekyll/wiki/Permalinks) your url may end up looking like this
`site.com/blog/20011/07/03/hello-world/index.html`.

New post expects a title and attempts to strip out undesirable url characters when creating the filename.

    rake new_post["Zombie Ninjas Attack: A survivor's retrospective"]
    # Creates the file
    source/_posts/2011-07-03-zombie-ninjas-attack-a-survivors-retrospective.markdown

The default file extension for new posts is `markdown` but you can configure that in the `Rakefile`.
Open up your post in a text editor and you'll see a block of [yaml front matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter)
which tells Jekyll how to processes posts and pages.

    ---
    layout: post
    title: "Hello World"
    date: 2011-07-03 5:59
    comments: true
    categories:
    ---

If you like, you can turn comments off, add categories for your post. Beneath the yaml block, go ahead and type up a sample post, or use some [inspired filler](http://baconipsum.com/).
After you've saved that post you'll want to generate your blog.

### Generate & Preview

    rake generate   # Generates posts and pages into the public directory
    rake watch      # Watches source/ and sass/ for changes and regenerates
    rake preview    # Watches, and mounts a webserver at http://localhost:4000

Jekyll's built in webbrick server is handy, but if you're a [POW](http://pow.cx) user, you can set it up to work with Octopress like this.

    cd ~/.pow
    ln -s /path/to/octopress
    cd -

Now that you're setup with POW, you'll just run `rake watch` and load up `http://octopress.dev` instead.

### Pages

You can add pages anywhere in your blog source directory and they'll be parsed by Jekyll. The URL will correspond directly to the filepath, so `about.markdown` will become `site.com/about.html`. If you prefer the URL `site.com/about/` you'll want to create the page as `about/index.markdown`.
Octopress has a rake task for creating new pages easily.

    rake new_page[awesome]
    # creates
    /source/awesome/index.markdown

    rake new_page[awesome/page.html]
    # creates
    /source/awesome/page.html

Like with the new post task, the default file extension is `markdown` but you can configure that in the `Rakefile`. A freshly generated page might look like this:

    ---
    layout: page
    title: "Awesome"
    date: 2011-07-03 5:59
    comments: true
    sharing: true
    footer: true
    ---

The title is derived from the filename so you'll likely want to change that. This is very similar to the post yaml except it doesn't include categories, and you can toggle sharing and comments or remove the footer altogehter. If you don't want to show a date on your page, just remove it from the yaml.
