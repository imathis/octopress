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

Next, **if you're using [Github Pages](http://pages.github.com) to host a site for your user or organization**, create a source branch and push to origin source.
If you're using Github project pages, or hosting the site in a different way, skip this step.

``` sh
    git checkout -b source
    git push origin source
```

The `source` branch is created to have somewhere to store the source
for your site. GitHub user/organization pages expects the generated site to be pushed to the
`master` branch of your GitHub repository so that branch needs to stay
clean. In [Deploying Octopress](/docs/deploying/) we'll setup the `master` branch for deployment.

Next, setup an [RVM](http://beginrescueend.com/) and install dependencies.

``` sh
    rvm rvmrc trust
    rvm reload
    gem install bundler
    gem install rake
    bundle install
```

Install the default Octopress theme,

``` sh
    rake install
```

### What to Commit?

With `rake install` you've setup the default Octopress theme in the `source` and `sass` directories. Add them to your git repository, commit and push. *Remember if you're hosting with Github user/organization pages, you'll want to commit these to the `source` branch.*

``` sh
    git add .
    git commit -m 'Installed Octopress theme'
    git push
```

Whenever you write a new post, or make changes to your blog, be sure to commit and push those changes.

See also [Configuring Octopress](/docs/configuring), [Blogging with Octopress](/docs/blogging/) and [Deploying Octopress](/docs/deploying/)
