---
layout: page
title: "Installing Ruby with Rbenv"
date: July 31 2012
sidebar: false
footer: false
---

Rbenv handles the installation and management of multiple Ruby environments. Ruby 1.9.3 is required for Octopress and using rbenv you can install it with ease.

## Standard Rbenv Installation

The standard method for installing rbenv uses Git. From your terminal, run the following commands:

```sh
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bash_profile
```

**Zsh users:** In the instructions above substitute `~/.bash_profile` with `~/.zshenv`.

## Alternate Installation Using Homebrew

If you use Homebrew on Mac OS X you may prefer to install rbenv like this:

```sh
brew update
brew install rbenv
brew install ruby-build
```

## Install Ruby 1.9.3

Next install Ruby 1.9.3 and you'll be all set.

```sh
rbenv install 1.9.3-p0
rbenv rehash
```

Run `ruby --version` to be sure you're using Ruby 1.9.3. If you're having trouble, [seek help here](https://github.com/sstephenson/rbenv/issues)

[&larr; Return to setup](/docs/setup)
