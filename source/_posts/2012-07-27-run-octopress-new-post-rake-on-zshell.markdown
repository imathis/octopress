a--
layout: post
title: "run octopress new_post rake on zshell"
date: 2012-07-27 22:53
comments: true
categories: general
---

This blog is running on [Octopress](https://github.com/imathis/octopress), which is an awesome implementation of a blogging engine in Ruby.

To create a new post, you need to run a rake task like so:

```bash
rake new_post["some awesome post title"]
```

The problem is, that in zsh, those are escaped and you get an error.

I used to do `new_post` without anything and then edit the file name and the title inside the file BUT there's actually a better way.

You can either run `noglob rake` or you can run the rake like this:

```bash
rake "new_post[some awesome post title]"
```

Enjoy!
