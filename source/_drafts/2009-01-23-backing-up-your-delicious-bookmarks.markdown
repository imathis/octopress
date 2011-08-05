--- 
layout: post
author: Mark
comments: "false"
title: Backing Up Your Delicious Bookmarks
date: 2009-1-23
categories: life
---
Recently I have become a big user of the social bookmarking site Delicious.  Nearly everyday I add several new bookmarks to my list on the site, the most recent ten of which appear in my sidebar.

Delicious is owned by <a title="Yahoo!" href="http://yahoo.com" target="_blank">Yahoo</a>, which means the data there is likely safe for a long time. However, I don't have any other record of these sites, so I was interested to see this <a title="Terminal Tip: Backing Up Delicious" href="http://lifehacker.com/5136845/backup-delicious-bookmarks-from-the-shell" target="_blank">Lifehacker tip</a> on backing up your Delicious bookmarks using curl or wget. Admittedly this is a fairly nerdy solution, but that is where the attraction lies for me.
<ol>
	<li>Open up a terminal (in Mac OS X, Terminal.app lives in Applications/Utilities)</li>
	<li>Type the following command:</li>
</ol>
<pre>curl -k --user username:password -o delicious.bakup.xml -O 'https://api.del.icio.us/v1/posts/all'</pre>
substituting your username and password for username:password.

That's it.  You could schedule this via cron, but that's the subject of another posting.
