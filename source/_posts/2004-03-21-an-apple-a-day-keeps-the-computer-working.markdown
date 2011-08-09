--- 
layout: post
title: An Apple a Day Keeps the Computer Working
date: 2004-3-21
comments: false
categories: life
link: false
---
Several days ago my PowerBook started exhibiting some rather odd symptoms. Typing in any of the Cocoa applications (Safari, TextEdit, X-Pad, et cetera) produced doubled punctuation and double spaces between words. And just for variety, icons in the toolbar of Mail refused to work. Click on the compose icon and no window appeared. Quit Mail and restart it and then you'd get the window. Not a useful feature.

Some google searching reveled one or two postings about a third party spelling library (cocoAspell) that had caused similar problems. Having once had that library installed I did a seek and destroy on my hard drive and got rid of all traces of it. Still no luck typing.

Another post suggested removing an obscure plist in the ~/Library/Caches folder; again no change in the typing situation.

So I broke down and called Apple Support. My PowerBook is over a year old, and I didn't opt for the extended service contract. At $350 for PowerBooks I thought it was too expensive. Per-incident costs are only $49. So I'm still ahead $300.

To make a long story somewhat shorter, trashing the contents of the ~/Library/Caches folder, and the ~/Library/ByHost folder didn't solve the problem. Nor did moving the Preferences, Preference Panes, Fonts, and Application Support folders to the desktop and logging off and back on.

What finally did the trick was renaming the ~/Library folder to ~/Library.old and  relogging into the computer. Copying the four orphaned folders from the desktop to the new ~/Library folder did not recreate the problem.

So somewhere in the ~/Library.old folder is the problem. If after a few weeks I haven't needed anything from that folder, it'll be headed into the trash too.

Thanks to Kevin from Apple for patiently walking me through all the steps to sort this bug out.
