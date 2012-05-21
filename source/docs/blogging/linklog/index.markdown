---
layout: page
title: "Writing a Linklog"
date: 2012-02-05 17:18
sidebar: false
comments: false
sharing: false
footer: false
---

A linklog is a blogging format where the post titles link directly to an external site and the content of the post offers commentary on the linked piece. This is commonly referred to as a "linked list" like the [The Daring Fireball Linked List](http://daringfireball.net/linked/) which helped popularize the format.

To publish linked posts with Octopress simply add the url for the item you want to write about to the `external-url` variable in the yaml front matter of a blog post.

``` yml Sample Yaml Front Matter
---
layout: post
title: "Someone on the Internet is Wrong"
date: 2012-02-05 17:18
comments: true
external-url: http://opinionguy.com/post/uninformed-rant-vs-straw-man/
---
```

When you generate your blog, the title link will point to the external url. Also, each post will show it's own permalink, and in the feed there will be a permalink at the end of linklog posts.

## Customizing titles

In the `_config.yml` there are some configurations you can change if you like.

``` yml Permalink and Linklog settings
permalink_label: "&infin;"
permalink_label_feed: "&infin; Permalink"
linklog_marker: "&rarr;"
linklog_marker_position: after
linklog_marker_position_feed: after
standard_post_marker:
```

The default settings were inspired by [Marco Arment](http://marco.org) with one exception, in his RSS feed the linklog marker comes before the title to help readers better distinguish linked posts from normal posts. To use that style simply change `linklog_marker_position_feed` to `before`.

John Gruber's [Daring Fireball](http://daringfireball.net) takes a different approach than Marco. Rather than mark his linked posts, he adds &#9733; to the beginning of each of his standard posts. If you wanted to copy that style, you'd set it up like this.

``` yml Linklog settings like Daring Fireball
permalink_label: "&#9733;"
permalink_label_feed: "&#9733;"
linklog_marker:
linklog_marker_position:
linklog_marker_position_feed:
standard_post_marker: "&#9733; "
```

## Styling

To help distinguish them from standard posts, linked posts have a smaller font size in addition to the linklog marker. When an article is a linked post it is marked with the html5 attribute `data-linklog` to give you a hook to customize styles if you like. If you wanted to set a different color for linked post titles you could add this css to your `sass/custom/styles.scss`.

``` scss Customized linked post title
.linklog .entry-title a {
  color: lime;
}
```

Styles for linklog markers and permalinks can also be customized.

``` scss Customize permalink styles
.entry-title:hover .linklog-marker {
  color: $link-color-hover;
}

article a[rel=bookmark] {
  font-size: 1.2em;
}
```
