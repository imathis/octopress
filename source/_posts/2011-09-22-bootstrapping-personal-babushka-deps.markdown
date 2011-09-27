---
layout: post
title: "Bootstrapping Personal Babushka Deps"
date: 2011-09-22 08:10
comments: true
categories: babushka
---

I have recently been pushing the envelope of how I use [Babushka](http://babushka.me/), with the aim of using it to provision everything I need for my personal and work machines. To this effect, I am running Babushka on fresh installs of both OS X Lion and Ubuntu 11.04.

As you can imagine, the first thing I do is install Babushka. That all works great, but my next step is to run something like `babushka natty-dev-box`. Unfortunately, this fresh machine doesn't have my personal deps on it, and I don't want to keep running all of my personal deps by prefixing my username (for example, `babushka jamesottaway:natty-dev-box`). If you aren't familiar with this convention in Babushka, read the [Sharing](http://babushka.me/sharing) page to understand what I mean.

I could go and create a new public/private SSH key pair, log into Github, give it my new public key, and then clone by `babushka-deps` repo. But why can't Babushka do it for me?

The solution is to write a few deps that manage those steps above, which I can run on a fresh machine by prefixing my Github username to the dep (ie. `babushka jamesottaway:bootstrap`).

The first dep ensures that I have a public/private key pair.

{% gist 1234192 ssh.rb %}

The next dep ensures I can push and pull from Github.

{% gist 1234192 github.rb %}

And the final dep will clone my Babushka deps repo into `~/.babushka/deps`, as well as alias the main dep to give it a shorter name.

{% gist 1234192 bootstrap.rb %}

The end result: `babushka jamesottaway:bootstrap` will get me up and ready to edit and run my personal deps without any further messing around.