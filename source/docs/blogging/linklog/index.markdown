---
layout: page
title: "Writing a Linklog"
date: 2012-02-05 17:18
sidebar: false
comments: false
sharing: false
footer: false
---

A linklog is a blogging format where the post titles link directly to an external site and the content of the post offers commentary on the linked piece. This is commonly referred to as a "linked list" because of the [The Daring Fireball Linked List](http://daringfireball.net/linked/) which helped to popularize the format.

Writing a linklog in Octopress is quite easy (as of [2.1](link-needed)). Simply add an `external-url` to the yaml front matter of a blog post and Octopress does the rest.

``` yml Sample Yaml Front Matter
---
layout: post
title: "Someone on the Internet is Wrong"
date: 2012-02-05 17:18
comments: true
external-url: http://opinionguy.com/post/uninformed-rant-vs-straw-man/
---
```


