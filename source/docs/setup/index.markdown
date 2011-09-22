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

Octopress requires Ruby 1.9.2 so you have two alternatives to install it: RVM or rbenv.

**Important:** you can't have both rbenv and RVM installed on the same system. Choose one.

### RVM steps

1. [Setup RVM](/docs/setup/rvm)
2. Install Ruby 1.9.2

```sh
rvm install 1.9.2
```

### rbenv steps

1. [Install rbenv](https://github.com/sstephenson/rbenv#section_2)
2. [Install ruby-build](https://github.com/sstephenson/ruby-build)
3. Install Ruby 1.9.2

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
