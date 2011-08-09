--- 
layout: post
title: Using jQuery to Create iGoogle Style Drag-and-Drop
date: "2008-11-12"
comments: false
categories: life
link: false
---
Once upon a time, a long time ago, there was a website called mydogmeg.  One of the features was a sub-domain filled with links to technical sites.  The layout was simple and effective, and when mydogmeg went off the air I grabbed a copy of the geek sub-domain from the Internet Archives.  For a long time I did nothing with the page, but last year after moving to a new host I created my own geek sub-domain, and put a modified version up on my site.

While the layout is pleasing to me, I've always wanted to add drag-and-drop functionality to the blocks of links, something like the iGoogle home page where moving one widget causes the others to get out of the way.  Thanks to a tip from JJ, I've updated the page using <a title="jQuery" href="jquery.com/">jQuery</a> to do just that.  You can go play with <a title="geek.zanshin.net" href="http://geek.zanshin.net">geek.zanshin.net</a> to see for yourself. Click inside any of the boxes on the screen and drag to relocate.
## jQuery Script
I used two jQuery libraries to add the drag-and-drop functionality I wanted.  The base <a title="Downloading jQuery" href="http://docs.jquery.com/Downloading_jQuery">jQuery library</a> and the <a title="UI jQuery" href="http://ui.jquery.com/">jQuery ui library</a>.  The feature that I wanted is called 'sortable' and it works against unordered lists. My page has four columns, called from left to right: left, leftCenter, rightCenter, and right.  Using these ids the script looks like this:

Basically this script does two things.  First is makes each named column sortable, allowing for drag-and-drop functionality, and causing the list items to "scoot" out of the way when the dragged item is dropped. Second it connects each column with the other columns, allowing dragging between the columns.
## Unordered Lists
The HTML and CSS for the page implement each column as an unordered list.  The bullet is suppressed, and the indent eliminated to save horizontal space.  Each column is named through an 'id' tag, and each block of links is also named.  Rather than repeat the source here I'll let the curious among you view the page source to see how the lists are constructed.

With the page constructed, and the jQuery script in place it just works.  Of course, the page has no persistence so any arrangement you make will be lost the next time you load the page.  My next project will be to add a cookie so that your page arrangement will be saved from one visit to the next.
