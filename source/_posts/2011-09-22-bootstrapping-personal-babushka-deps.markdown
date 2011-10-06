---
layout: post
title: "Bootstrapping Personal Babushka Deps"
date: 2011-09-22 08:10
comments: true
categories: babushka
---

One slightly more unconventional use that I have found for [Babushka](http://babushka.me/), a Ruby-based automation DSL tool written by [Ben Hoskings](http://benhoskin.gs/), is to use it to provision a complete local computer. To this effect, I have recently been using Babushka on fresh installs of varying operating systems.

As you can imagine, the first thing I do is install Babushka. That all works great, but my next step is to run something like `babushka natty-dev-box`. Unfortunately, a fresh machine doesn't have my personal deps on it, and I don't want to keep running all of my personal deps by prefixing my username (for example, `babushka jamesottaway:natty-dev-box`). If you aren't familiar with this convention in Babushka, read the [Sharing](http://babushka.me/sharing) page to understand what I mean.

I could go and create a new public/private SSH key pair, log into Github, give it my new public key, and then clone by `babushka-deps` repo. But why can't Babushka do it for me?

I managed to write a few deps that manage those steps above, which I can run on a fresh machine by using the "username-prefix" convention I mentioned above.

First I ensure that I have a public/private key pair.

{% gist 1234192 ssh.rb %}

Next I need to make sure Github has my public key and that I can authenticate with this public key over SSH.

{% gist 1234192 github.rb %}

Finally I clone my Babushka deps repo into `~/.babushka/deps`. The final line simply aliases the main dep to a single word.

{% gist 1234192 bootstrap.rb %}

The end result: `babushka jamesottaway:bootstrap` will get me up and ready to edit and run my personal deps without any further messing around.