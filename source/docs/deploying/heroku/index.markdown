---
layout: page
title: "Using Octopress with Heroku"
date: 2011-09-10 17:58
sidebar: false
footer: false
---

If you don't already have a Heroku account, [create one](https://api.heroku.com/signup), it's free. Then install the Heroku gem.

## Basic Octopress setup
{% render_partial docs/setup/_basic.markdown %}

Next create a heroku app for deployment. If this is your first time using Heroku, this command will ask for your account credentials,
and automatically upload your public SSH key. If you don't already have a public key follow [Github's guide and create one](http://help.github.com/set-up-git-redirect/).

```sh
heroku create
```

This will create a new Heroku app for you to deploy to and add a git remote named 'heroku'.

git config branch.master.remote origin
