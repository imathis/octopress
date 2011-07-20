---
layout: page
title: Octopress Setup
date: July 18 2011
sidebar: false
footer: false
---


[Create a new repository](https://github.com/repositories/new) for your website then
open up a terminal and follow along. If you plan to host your site on [Github Pages](http://pages.github.com) for a user or organization, make sure the
repository is named `your_username.github.com` or `your_organization.github.com`.

    mkdir my_octopress_site
    cd my_octopress_site
    git init
    git remote add octopress git://github.com/imathis/octopress.git
    git pull octopress master
    git remote add origin (your repository url)
    git push origin master

    # Next, if you're using Github user or organization pages,
    # Create a source branch and push to origin source.
    git branch source
    git push origin source


Next, setup an [RVM](http://beginrescueend.com/) and install dependencies.

    rvm rvmrc trust
    bundle install

    # Install pygments (for syntax highlighing)
    sudo easy_install pip
    sudo pip install pygments

Install the default Octopress theme,

    rake install

and you should be all set up to begin blogging with Octopress.

[Next, Deploying Octopress &raquo;](/docs/deploying)
