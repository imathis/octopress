---
layout: post
title: "copy all files from a folder into a folder without the confirmation on linux"
date: 2012-07-31 18:17
comments: true
categories: general, devops
---

As a developer, there are things that never mind how many times you'll do them, you will never ever remember how to do it exactly without googling for a couple of minutes or looking through the last executed list of commands on the terminal.

For me, one of those things is how to copy all files and folders from source to destination with automatic reply yes to overwrite requests.

Here's how you do it

```bash
cp -apRv <source_folder>/* <dest_folder>/ --reply=yes
```

Enjoy!

And #notetoself, no need to google anymore, find it on my blog ;)