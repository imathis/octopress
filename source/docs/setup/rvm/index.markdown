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
curl -L https://get.rvm.io | bash -s stable --ruby
```

Next add RVM to your shell as a function. (Or simply close and reopen your shell.)

```sh
source ~/.bash_profile

# If using Zsh do this instead
source ~/.zshrc
```

Install Ruby 1.9.3 and ensure RVM has the latest RubyGems.

```sh
rvm install 1.9.3 && rvm use 1.9.3
```
