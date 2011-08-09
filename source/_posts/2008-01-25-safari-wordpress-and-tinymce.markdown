--- 
layout: post
title: Safari, Wordpress, and TinyMCE
date: 2008-1-25
comments: true
categories: life
link: false
---
The visual editor provided with Wordpress is actually an implementation of <a href="http://tinymce.moxiecode.com/" target="_blank" title="TinyMCE">TinyMCE</a>.  Contained in the Wordpress implementation is coding that checks the browser type.  The coding following at least one of the Safari checks strips out all paragraph tags (&lt;p&gt;).  This means that any entry you either edit or create using Safari turns in to one huge block of text the instant you save or publish.  Not what you want, believe me.

There are at least two Trac entries on the Wordpress development site <a href="http://trac.wordpress.org/ticket/4521" target="_blank" title="#4521">detailing this problem</a>, each with a chain of comments about the criticalness of the problem.  There are also a <a href="http://wordpress.org/support/topic/142789" target="_blank" title="Wordpress &gt; Suuport &gt;&gt; Lost Paragraphs">couple of threads</a> on the Wordpress forum regarding the issue.  It appears that you could edit the tinyMCE code within your Wordpress installation, to remove the offending Safari conditional.  The group consensus was uncertain as to any side effects of this hack.  Also, you would have to re-apply the hack each time you updated Wordpress.

Hoping to avoid surgery on my installations, I opted to install the <a href="http://www.mkbergman.com//?page_id=383" target="_blank" title="Advanced TinyMCE Editor">Advanced TinyMCE plugin</a> (not the simplest of operations), wondering if it would fix the problem.  No such luck.

So I am still forced to edit postings using any browser except Safari 3.
