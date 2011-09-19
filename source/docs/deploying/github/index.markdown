---
layout: page
title: "Deploying to Github Pages"
date: 2011-09-10 17:52
sidebar: false
footer: false
---

To setup deployment, you'll want to clone your target repository into the `_deploy` directory in your Octopress project.
If you're using Github user or organization pages, clone the repository `git@github.com:username/username.github.com.git`.

### With Github User/Organization pages

``` sh
    git clone git@github.com:username/username.github.com _deploy
    rake config_deploy[master]
```

### With Github Project pages (gh-pages)

``` sh
    git clone git@github.com:username/project.git _deploy
    rake config_deploy[gh-pages]
```

The `config_deploy` rake task takes a branch name as an argument and creates a [new empty branch](http://book.git-scm.com/5_creating_new_empty_branches.html), and adds an initial commit.
This also sets `deploy_default = "push"` in your `_config.yml` and prepares your branch for easy deployment. The `rake deploy` task copies the generated blog from the `public` directory to the `_deploy` directory, adds new files, removes old files, sets a commit message, and pushes to Github.
Github will queue your site for publishing (which usually occurs instantly or within minutes if it's your first commit).

Now you should be set up to deploy, just run

``` sh
    rake generate   # If you haven't generated your blog yet
    rake deploy     # Pushes your generated blog to Github
```

<h2 id="deploy_subdir">Deploying to a Subdirectory (Github Project Pages does this)</h2>

{% render_partial docs/deploying/_subdir.markdown %}

<h2 id="custom_domains">Custom Domains</h2>

First you'll need to create a file named `CNAME` in the source containing your domain name.

``` sh
echo 'your-domain.com' >> source/CNAME
```

From [Github's Pages guide](http://pages.github.com):<br>
Next, you’ll need to visit your domain registrar or DNS host and add a record for your domain name.
For a sub-domain like `www.example.com` you would simply create a CNAME record pointing at `charlie.github.com`.
If you are using a top-level domain like `example.com`, you must use an A record pointing to `207.97.227.245`.
*Do not use a CNAME record with a top-level domain* it can have adverse side effects on other services like email.
Many DNS services will let you set a CNAME on a TLD, even though you shouldn’t. Remember that it may take up to a full day for DNS changes to propagate, so be patient.
