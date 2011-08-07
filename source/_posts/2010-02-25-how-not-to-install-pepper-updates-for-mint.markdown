--- 
layout: post
comments: "false"
title: How NOT to Install Pepper Updates for Mint
date: 2010-2-25
link: "false"
categories: nerdliness
---
Since December 2005 I have been using <a title="Mint" href="http://haveamint.com" target="_blank">Mint</a> to track my web site statistics. Out of the box it provides a good look at who is coming to your site, how frequently, and to which pages. Better still, Mint is extensible through plugins called Peppers. Pepper-mint, get it?

Periodically the base package and or some of the Peppers have updates available. Updating isn't too difficult but it does require paying attention to details. Since your site is a live, dynamic thing, you want the outage of your statistics tracking to be as short as possible when updating. The ideal way to accomplish this is to rename the folders you are about to upload to your Mint installation from there real name ("default") to an alternate name ("default-new") so the new stuff can coexist with the old stuff temporarily.

Once you've uploaded all the new pieces (each renamed to end in "-new") then you go through a two step renaming process. "default" to "default-old" and "default-new" to "default" Since renaming is a much faster operation than uploading, the span of downtime is very short. The final step is to remove the "default-old" package as it is no longer needed.

All of this worked perfectly yesterday, except that I was lazy and didn't remover the old package from the last Pepper I updated. This meant that the directory contained both "locationsplus" and "locationsplus-old". Seemingly a minor point. The Mint page loaded and everything seemed to be working. Later I went to my Mint preferences and the page didn't finish loading. After a few minutes of poking around I discovered the Pepper folder with what were essentially two copies of the same Pepper. Once I deleted the "-old" version the Preferences page loaded properly.

The moral of the story is to follow all the steps, and not just the ones you like.
