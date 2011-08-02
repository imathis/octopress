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

``` sh
    mkdir my_octopress_site
    cd my_octopress_site
    git init
    git remote add octopress git://github.com/imathis/octopress.git
    git pull octopress master
    git remote add origin your/repository/url
    git push origin master
```

Next, if you're using Github pages for users or organizations, create a source branch and push to origin source.

``` sh
    git checkout -b source
    git push origin source
```

Next, setup an [RVM](http://beginrescueend.com/) and install dependencies.

``` sh
    rvm rvmrc trust
    rvm reload
    bundle install
```

Install the default Octopress theme,

``` sh
    rake install
```

### What to Commit?

Now that you've installed the `source` and `sass` directories add them to your git repository, commit and push.

``` sh
    git add .
    git commit -m 'Installed Octopress theme'
    git push
```

Whenever you write a new post, or make changes to your blog, be sure to commit and push those changes.

See also [Configuring Octopress](/docs/configuring), [Blogging with Octopress](/docs/blogging/) and [Deploying Octopress](/docs/deploying/)
