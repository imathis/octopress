---
layout: page
title: "Installing Ruby with RVM"
date: July 31 2012
sidebar: false
footer: false
---


RVM (Ruby Version Manager) handles the installation and management of multiple Ruby environments. Ruby 1.9.3 is required for Octopress and using RVM you can install it with ease.

## Install RVM

Run the following command from your terminal.

```sh
curl -L https://get.rvm.io | bash -s stable --ruby
```

Be sure to follow any subsequent instructions as guided by the installation process.

## Install Ruby 1.9.3

Next install Ruby 1.9.3 and you'll be all set.

```sh
rvm install 1.9.3
rvm use 1.9.3
rvm rubygems latest
```

Run `ruby --version` to be sure you're using Ruby 1.9.3. If you're having trouble, [seek help here](https://rvm.io/support).

[&larr; Return to setup](/docs/setup)
