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

1. [Install Git](http://git-scm.com/).
2. Install Ruby 1.9.3 using either [rbenv](/docs/setup/rbenv) or [RVM](/docs/setup/rvm).

If `ruby --version` doesn't say you're using Ruby 1.9.3, revisit your [rbenv](/docs/setup/rbenv) or [RVM](/docs/setup/rvm) installation.

## Setup Octopress

```sh
git clone git://github.com/imathis/octopress.git octopress
cd octopress    # If you use RVM, You'll be asked if you trust the .rvmrc file (say yes).
ruby --version  # Should report Ruby 1.9.3
```

Next, install dependencies.

```sh
gem install bundler
rbenv rehash    # If you use rbenv, rehash to be able to run the bundle command
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
