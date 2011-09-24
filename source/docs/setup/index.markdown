---
layout: page
title: Octopress Setup
date: July 18 2011
sidebar: false
footer: false
---

First, I want to stress that **Octopress is a blogging framework for hackers**.
You should be comfortable running shell commands and familiar with the basics of Git.
If that sounds daunting, Octopress probably isn't for you.

## Before You Begin

You'll need to [install Git](http://git-scm.com/) and set up your Ruby environment.
**Octopress requires Ruby 1.9.2** wich you can easily install with [RVM](http://rvm.beginrescueend.com) or [rbenv](https://github.com/sstephenson/rbenv).
You can't use both rbenv and RVM on the same system, so choose one.

### Using RVM

If you don't have RVM yet, [Install RVM](/docs/setup/rvm) and then install Ruby 1.9.2.

```sh
rvm install 1.9.2 && rvm use 1.9.2
```

### Using rbenv

If you don't have rbenv yet, [Install rbenv](https://github.com/sstephenson/rbenv#section_2) and [install ruby-build](https://github.com/sstephenson/ruby-build), then install Ruby 1.9.2.

```sh
rbenv install 1.9.2-p290
```

## Setup Octopress

```sh
git clone git://github.com/imathis/octopress.git octopress
cd octopress    # If you use RVM, You'll be asked if you trust the .rvmrc file (say yes).
ruby --version  # Should report Ruby 1.9.2
```

If `ruby --version` doesn't say you're using Ruby 1.9.2, you may want to [revisit your RVM installation](/docs/setup/rvm).

Next, install dependencies.

```sh
gem install bundler
bundle install
```

Install the default Octopress theme.

``` sh
rake install
```

## Next Steps

- [Set up deployment](/docs/deploying)
- [Configure your blog](/docs/configuring)
- [Start blogging with Octopress](/docs/blogging)
