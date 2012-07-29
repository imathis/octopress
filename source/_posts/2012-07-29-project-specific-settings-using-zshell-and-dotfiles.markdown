---
layout: post
title: "project specific settings using zshell and dotfiles"
date: 2012-07-29 13:54
comments: true
categories: general
---

I have been working with ZHell pretty much since the first day that I have been using a Mac.

The use I make of to grew with time and definitely the biggest switch was that I moved to using dotfiles for settings in a single location.

I forked [Zach Holman](http://zachholman.com/) dot files [here](http://github.com/kensodev/dotfiles), and I have been adjusting and customizing it ever since.

I am using Ruby/Rails for my everyday work, both for consulting and open source projects, the one thing that I see people do and I don't like is committing configuration files with password and sensitive information into source control.

When I can, I try to avoid it, so I developed a very easy way to manage my per-project environment variable without going through a huge file.

All of my zsh files are located in a single folder in my dotfiles.

```
├── aliases.zsh
├── completion.zsh
├── config.zsh
├── functions
│   ├── _boom
│   ├── _brew
│   ├── _c
│   ├── _git-rm
│   ├── _h
│   ├── _rake
│   ├── c
│   ├── gf
│   ├── gitdays
│   ├── h
│   ├── last_modified
│   ├── newtab
│   ├── savepath
│   ├── smartextract
│   ├── start_project
│   ├── verbose_completion
│   └── zgitinit
├── hidden_aliases.zsh
├── projects
│   ├── boto_project.zsh
│   └── octopus_project.zsh
├── prompt.zsh
├── window.zsh
└── zshrc.symlink
```

As you can see, there's a special folder there called `projects`, in which I put a lll of my project specific setting like tokens, passwords and other things.

For example, here's what a project file might look like:

```bash
export OCTOPUS_POSTGRES_USER=postgres
export OCTOPUS_POSTGRES_PASSWORD=some_password
```

One thing that is very easy to forget, is that if you open source your dot files (and you should) don't forget to ignore those files and don't commit them.
