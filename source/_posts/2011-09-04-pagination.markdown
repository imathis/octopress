---
layout: post
title: "Pagination"
date: 2011-09-04 13:34
comments: true
categories: nerdliness
link: false
---
One of the risks when changing how your site is published is breaking
links. Links from external sources and links internally from post to
post. Toward that end I've been making great use of
[Mint](http://haveaminst.com "MInt") and it's many Peppers to track
visitors and any errors they may be experiencing.

After a recent source code update from [Octopress](http://octopress.org
"Octopress") I started seeing some errors referencing URLs that looked
like "page/#/". Last night I discovered pagination on my site was well
and truly broken. Whoops.

Pagination is the process of taken all my many posts (1793 counting this
one) and spliting them up into pages containing 10 or fewer posts. Since
weblogs are published in reverse chronological order, each new posting
causes a ripple through all the pages of a site. In my case there are
180 pages of prior posts to re-create. Each one linked to it's nearest
siblings via "older" and "newer" links.

There are many ways to structure a website. In my case I've choosen to
have my primary page at the root of my domain. Others choose to house
their site in a **/blog** subdirectory. By default Octopress assumes you
fall into the later cateory, and want all your postings to live in a
**/blogs** subdirectory. Since I don't want that I've had to tinker with
settings in the **_config.yml** file and also with the Liquid tags that
render the primary index page.

By default the primary index page for an Octopress site wants to build
an archives link that leads you to **/blogs/page/#**. It was easy enough
to remove the **/blogs** portion of that link. The same piece of code
was also creating pagination links that were incorrect, by embedding an
extra **/page** in each and by adding an extraneous **/** at the end of
the URL. After some debugging and testing on my site this morning, I
produced the following code, which renders the three pagination links
properly for my site structure.

{% codeblock index.html %}
    <nav role="pagination">
      <div>
        \{\% if paginator.next_page \%\}
          <a class="prev" href="\{\{paginator.next_page\}\}">&larr; Older</a>
        \{\% endif \%\}
        <a href="/archives">Blog Archives</a>
        \{\% if paginator.previous_page and paginator.page > 1 \%\}
          <a class="next" href="\{\{paginator.previous_page\}\}">Newer &rarr;</a>
        \{\% elsif paginator.previous_page \%\}
          <a class="next" href="/">Newer &rarr;</a>
        \{\% endif \%\}
      </div>
    </nav>
{% endcodeblock %}

(The Liquid tags are escaped in the above example to prevent them from rendering. In using this code you will need to strip the "\" from the code. )

This code also addresses a Liquid error I was seeing where the "Newer"
pagination link wasn't getting rendered at all. The original code was
testing **paginator.previous_page** to see if it was greater than 1 and
causing a "comparison of String with 1" error to be thrown. By changing
the code to use **paginator.page** the comparison works properly.

