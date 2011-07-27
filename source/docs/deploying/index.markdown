---
layout: page
title: Deploying Octopress
date: July 18 2011
sidebar: false
footer: false
---

[&laquo; Previous, Configuring Octopress](/docs/configuring)

### Deploying with Rsync via SSH

Add your server configurations to the `Rakefile` under Rsync deploy config. To deploy with Rsync, be sure your public key is listed in your server's `~/.ssh/authorized_keys` file.

    ssh_user       = "user@domain.com"
    document_root  = "~/website.com/"
    deploy_default = "rsync"

Now if you run `rake deploy` in your terminal, your `public` directory will be synced to your server's document root.

### Deploying to Github Pages

To setup deployment, you'll want to clone your target repository into the `_deploy` directory in your Octopress project.
If you're using Github project pages, clone the repository for that project, eg `git@github.com:username/project.git`.
If you're using Github user or organization pages, clone the repository `git@github.com:username/username.github.com.git`.

    # For Github project pages:
    git clone git@github.com:username/project.git _deploy
    rake config_deploy[gh-pages]

    # For Github user/organization pages:
    git clone git@github.com:username/username.github.com _deploy
    rake config_deploy[master]

    # Now to deploy, you'll run
    rake deploy

The `config_deploy` rake task takes a branch name as an argument and creates a [new empty branch](http://book.git-scm.com/5_creating_new_empty_branches.html), and adds an initial commit.
This also sets `deploy_default = "push"` in your `_config.yml` and prepares your branch for easy deployment. The `rake deploy` task copies the generated blog from the `public` directory to the `_deploy` directory, adds new files, removes old files, sets a commit message, and pushes to Github.
Github will queue your site for publishing (which usually occurs instantly or within minutes if it's your first commit).


### Deploying to a Subdirectory (Github Project Pages does this)

If you're deploying to a subdirectory on your site, or if you're using Github's project pages, make sure you set up your urls correctly in your configs.
You can do this *almost* automatically:

    rake set_root_dir[your/path]

    # To go back to publishing to the document root
    rake set_root_dir[/]

Then update your `_config.yml` and `Rakefile` as follows:

    # _config.yml
    url: http://yoursite.com/your/path

    # Rakefile (if deploying with rsync)
    document_root = "~/yoursite.com/your/path"

To manually configure deployment to a subdirectory, you'll change `_config.yml`, `config.rb` and `Rakefile`.
Here's an example for deploying the Octopress website to Github Project Pages:

    # _config.yml
    destination: public/octopress
    url: http://imathis.github.com/octopress
    subscribe_rss: /octopress/atom.xml
    root: /octopress

    # config.rb - for Compass & Sass
    http_path = "/octopress"
    http_images_path = "/octopress/images"
    http_fonts_path = "/octopress/fonts"
    css_dir = "public/octopress/stylesheets"

    # Rakefile
    public_dir = "public/octopress"
    # If deploying with rsync, update your Rakefile path
    document_root = "~/yoursite.com/your/path"

For more info on deploying a Jekyll Blog, checkout [Jekyll's deployment wiki page](https://github.com/mojombo/jekyll/wiki/Deployment).

[Next, Blogging Basics &raquo;](/docs/blogging)
