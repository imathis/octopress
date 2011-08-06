---
layout: post
title: "Fully Baked"
date: 2011-07-31 21:33
comments: true
categories: "this site"
---
For some time now I have been less enthusiastic about using WordPress for my primary website. WordPress is fantastic; it does an amazing job of making blogging easy, and it was a good follow on to the MoveableType system I had before. However I want to fiddle with the bits and bytes more, and I'm not at all interested in learning PHP or the template system.

I had read several articles about "fully baked" sites - basically site that are generated on the author's computer and then copied to their host and served statically from there. And I had looked into Jekyll and Nanoc and some other static site generators. While intrigued I wasn't quite ready to take the plunge.

A few days ago I saw something about Octopress on YCombinator's Hacker News, and then on MinimalMac. My interest was peaked and so this weekend I sat down to explore the thing. Having just spent some time delving into the Ruby programming language, exploring a Ruby-based static site generator seemed like a good fit.

Getting Octopress installed and working hasn't been without some issues. Compiling Ruby versions on OS X Lion isn't straight forward thanks to a compiler change in Xcode. And my having switched to zsh from bash also threw things for a loop. Turns out that zsh has some globbing issues. A quick alias in my .zshrc file (rake="unglob rake") solved that problem.

Getting 1700 odd entries from WordPress into markdown format without losing too much of their metadata was a bit of work too. Fortunately I discovered a Ruby script that parses the WordPress export XML file and produces Jekyll formatted markdown files with the appropriate YAML headers. Running a rake command to generate the HTML from 1772 markdown files gives my MacBook Pro a workout. While debugging several changes I made to the original Ruby conversion script, I ran the process several times. The CPU temperature reached 64º C. Wow.

Next up is sorting out the theme. The single biggest reason for switching away from WordPress was wanting to take control over my sites look and feel, and getting away from being reliant upon various themes to meet my aesthetic needs. I'll need to learn SASS in order to fully control the styling options in Octopress, but that is something I look forward too.
