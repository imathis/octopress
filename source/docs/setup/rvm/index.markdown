---
layout: page
title: "Installing RVM"
date: September 19 2011
sidebar: false
footer: false
---

RVM (Ruby Version Manager) handles the installation and management of multiple Ruby environments, and Octopress was designed to work in an RVM-controlled environment.
Installation should be pretty smooth, but if you have trouble [get help here](https://rvm.beginrescueend.com/support/).

Run this command to install RVM for your user account.

```sh
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
```

Next add RVM to your shell as a function.

```sh
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
source ~/.bash_profile

# If using Zsh do this instead
echo '[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm' >> ~/.zshrc
source ~/.zshrc
```

Install Ruby 1.9.2 and ensure RVM has the latest RubyGems.

```sh
rvm install 1.9.2
rvm rubygems latest
```
