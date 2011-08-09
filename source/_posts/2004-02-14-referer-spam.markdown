--- 
layout: post
title: Referer Spam
date: 2004-2-14
comments: false
categories: nerdliness
link: false
---
For some time now I have been using the excellent referer logging tool, <a href="http://www.textism.com/tools/refer/" title="Refer">Refer</a> from <a href="http://www.textism.com/" title="Textism">Textism</a>. It's pure vanity and ego gratification served up in HTML.

It is also, it appears, a new place for the scum that are spam purveyors to ply their, ah, trade. I have been getting increasing amounts of "referrals" from adult sites that point only to my referer log. And today I got a couple of dozens hits from John Kerry's blog.

Enough is enough. I edited the logfunctions.php file and added a line to not record any referers to the referer index page itself. Spot testing from various search engines shows it appears to be working. Now I'll have to wait a few days to see if my fix actually eliminates the unwanted parasites from my site.
