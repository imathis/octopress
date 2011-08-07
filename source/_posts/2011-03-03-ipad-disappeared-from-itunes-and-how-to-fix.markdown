--- 
layout: post
comments: false
title: iPad Disappeared from iTunes and How to Fix
date: 2011-3-3
link: false
categories: life
---
Over the weekend I needed to charge my iPad as it had gotten down to about 5% battery life. Normally when I plug it into the computer the iPad screen shows that it is syncing, and when I go to iTunes on the computer I can see the device listed in the left-hand sidebar. Not this time. iPhoto started, since there are pictures on the iPad, but iTunes was ignorant of the iPad's presence.

Over the next couple of days I tried several times to sync the iPad with no success. It charged okay, but it wouldn't sync. My iPod Nano synced just fine however. Curious.

Several Google searches lead me to this, <a title="Device Not Recognized by iTunes" href="http://support.apple.com/kb/TS1591" target="_blank">Device Not Recognized</a> knowledge base article on the Apple Support site. After following all of the directions short of completely removing iTunes from my computer the iPad would still not synchronize. Completely removing iTunes seemed like a really drastic step, and one I was reluctant to try.

Today when Software Update indicated there was a new version of iTunes I thought maybe that would fix things. Unfortunately it did not. So this evening I followed all the steps in <a title="Removing iTunes from Mac OS X" href="http://support.apple.com/kb/ht1224" target="_blank">Removing iTunes from Mac OS X</a>. When I got to the second half of the instructions, after restarting and emptying the trash, I discovered that instead of one copy of the com.apple.iTunes.plist, I had about two dozen copies, each with a slightly different number appended to the end of the file name. Obviously this plist had become corrupted and was the root of the problem.

Once all the files had be moved to the trash and then deleted I downloaded the newest version of iTunes and installed it. The moment of truth came when I started iTunes for the first time - would it be smart enough to recognize my existing library, playlists, ratings, and play counts. Yes, it was smart enough.

And even better, my iPad once again synchronizes with iTunes. I have no idea how things got broken, but I am glad they are working once again.
