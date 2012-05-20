---
layout: page
title: "Deploying to Github Pages"
date: 2011-09-10 17:52
sidebar: false
footer: false
---

## With Github User/Organization pages

Use this if you want to host a blog from `http://username.github.com` (though you can also use [custom domains](#custom_domains)).

Create a [new Github repository](https://github.com/repositories/new) and name the repository with your user name or organization name `username.github.com` or `organization.github.com`.

Github Pages for users and organizations uses the master branch like the public directory on a web server, serving up the files at your Pages url `http://username.github.com`.
As a result, you'll want to work on the source for your blog in the source branch and commit *the generated content* to the master branch. Octopress has a configuration task that helps you set all this up.

``` sh
rake setup_github_pages
```

This will:

1. Ask you for your Github Pages repository url.
2. Rename the remote pointing to imathis/octopress from 'origin' to 'octopress'
3. Add your Github Pages repository as the default origin remote.
4. Switch the active branch from master to source.
5. Configure your blog's url according to your repository.
6. Setup a master branch in the _deploy directory for deployment.

Next run:

```sh
rake generate
rake deploy
```

This will generate your blog, copy the generated files into `_deploy/`, add them to git, commit and push them up to the master branch. In a few seconds you should get an email
from Github telling you that your commit has been received and will be published on your site.

**Don't forget** to commit the source for your blog.

```sh
git add .
git commit -m 'your message'
git push origin source
```

**Note:** With new repositories, Github sets the default branch based on the branch you push first, and it looks there for the generated site content.
If you're having trouble getting Github to publish your site, go to the admin panel for your repository and make sure that the master branch is the default branch.

## With Github Project pages (gh-pages)

Github's Project Pages service allows you to host a site for your existing open source project.
Github will look for a `gh-pages` branch in your project's repository and make the contents available at url like `http://username.github.com/project`.

Here's now you can set up Octopress site to publish to your projects gh-pages repository:

``` sh
rake setup_github_pages
```

This will:

1. Ask you for the repository url for your project.
2. Rename the remote pointing to imathis/octopress from 'origin' to 'octopress'
3. Configure your blog for deploying to a subdirectory.
4. Set up a gh-pages branch for your project in the _deploy directory, ready for deployment.

Next run:

```sh
rake generate
rake deploy
```

This will generate your blog, copy the generated files into `_deploy/`, add them to git, commit and push them up to the master branch. In a few seconds you should get an email
from Github telling you that your commit has been received and will be published on your site.

Now you have a place to commit the generated content for your site, but you should also set up repository to store the source for your blog.
After you set up a repository for your blog source, add it as the origin remote.

```sh
git remote add origin (your repo url)
# set your new origin as the default branch
git config branch.master.remote origin
```

Now push your changes and you'll be all set.

<h2 id="custom_domains">Custom Domains</h2>

First you'll need to create a file named `CNAME` in the source containing your domain name.

``` sh
echo 'your-domain.com' >> source/CNAME
```

From [Github's Pages guide](http://help.github.com/pages/#custom_domains):<br>
Next, you’ll need to visit your domain registrar or DNS host and add a record for your domain name.
For a sub-domain like `www.example.com` you would simply create a CNAME record pointing at `charlie.github.com`.
If you are using a top-level domain like `example.com`, you must use an A record pointing to `207.97.227.245`.
*Do not use a CNAME record with a top-level domain* it can have adverse side effects on other services like email.
Many DNS services will let you set a CNAME on a TLD, even though you shouldn’t. Remember that it may take up to a full day for DNS changes to propagate, so be patient.
