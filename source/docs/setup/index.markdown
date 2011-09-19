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

You'll need to have Git and RVM installed before you move forward.

1. [Download Git](http://git-scm.com/)
2. [Setup RVM](/docs/setup/rvm)

Octopress requires Ruby 1.9.2 so once you have RVM set up, go ahead and install it.

```sh
rvm install 1.9.2
```

## Setup Octopress

```sh
git clone git://github.com/imathis/octopress.git octopress
cd octopress  # You'll be asked if you trust the .rvmrc file (say yes).
which ruby    # Should report Ruby 1.9.2
```

If `which ruby` doesn't say you're using Ruby 1.9.2, you may want to [revisit your RVM installation](/docs/setup/rvm).

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
