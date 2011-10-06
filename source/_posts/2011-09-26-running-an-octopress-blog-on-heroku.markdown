---
layout: post
title: "Running an Octopress blog on Heroku"
date: 2011-09-26 08:46
comments: true
categories: octopress heroku blog meta
---

As a software developer I don't write code without using a version control system such as Git. Recently, though, I have come to love the idea of extending that discipline to include versioning *everything* in my life. This means that when it comes to blogging, options like Wordpress just aren't going to cut it. After reading about Octopress, a blogging framework that generates your blog as a static website, I fell in love.

Another love of mine is Heroku, a platform-as-a-service hosting provider. Unfortunately, because Octopress generates static content, Heroku isn't an obvious hosting choice for many. I wasn't so convinced of this limitation, and luckily for me Scott Water contributed a patch to Octopress which enables an Octopress blog to run on Heroku. The patch features a `config.ru` file which tells Heroku (or any other Rack-based server) to serve files from the `public` directory.

This means that I can run `rake generate` like usual, and track my `public` directory in Git by running `git add --force public` and `git commit`. Deploying is then as simple as `git push heroku master`.

This works great, but I ran into an issue when I came to run `git push origin master` in order to keep my Github repository up-to-date. The problem is that I'd rather not have to have my `public` directory polluting my Github repository, especially given that the real magic is happening inside the `source` directory.

My solution was to deploy to Heroku from a Git branch, aptly named `deploy`. Creating the branch was as simple as `git checkout -b deploy`. Once on the branch, I run `git merge master` to pull in any new posts I have written plus any other changes that need to be deployed.

I then ran `rake generate` and `git add --force public`, as before, but the deploy step became `git push heroku deploy:master`. What this says is that I want to push my local `deploy` branch to the `heroku` remote's `master` branch.

I'm thinking of trying to make this process easier by writing a new Rake task or two within Octopress. If you have ideas on how it should work please let me know.
