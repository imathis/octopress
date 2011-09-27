---
layout: post
title: "Running an Octopress blog on Heroku"
date: 2011-09-26 08:46
comments: true
categories: octopress heroku blog
---

As a software developer worth his salt, I use Git to version any code that I write. It works really well, and I've recently come to love the idea of extending that to include versioning *everything* in my life a developer. This means that when it comes to blogging, options like Wordpress just aren't going to cut it. After reading about Octopress, a blogging framework that generates your blog as a static website, I fell in love.

Another love of mine is Heroku, a platform-as-a-service web provider that I use for hosting my Ruby web applications. Unfortunately there isn't a lot of information on how to run an Octopress blog on Heroku. Octopress helps you generate a static site from the source, but Heroku isn't a static website host. Luckily for me, Scott Water contributed a `config.ru` file to Octopress, which tells Heroku (or any other Rack-based server) to serve files from the `public` directory.

This means that I can run `rake generate` like usual, and track my `public` directory by running `git add --force public` and `git commit`. Deploying is then as simple as `git push heroku master`.

This works great, until I wanted to do a `git push origin master` to keep my Github repository up-to-date. I'd rather not have to have my `public` directory visible on Github, given that the real magic is happening inside the `source` directory.

My solution was to deploy to Heroku from a Git branch, aptly named `deploy`. Creating the branch was as simple as `git checkout -b deploy`. Once on the branch, I quickly run `git merge master` to pull new posts I have written plus any other changes that need to be deployed.

I then ran `rake generate` and `git add --force public` like before, but the deploy step became `git push heroku deploy:master`. What this says is that I want to push my local `deploy` branch to the `heroku` remote's `master` branch.

I'm thinking of trying to make this process easier by writing a new Rake task or two within Octopress. If you have ideas on how it should work please let me know.