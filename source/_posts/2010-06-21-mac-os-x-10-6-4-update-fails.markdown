--- 
layout: post
title: Mac OS X 10.6.4 Update Fails
date: 2010-6-21
comments: false
categories: life
link: false
---
Usually when Apple pushes out an operating system update I wait a day or so to see if there are any reports of major problems or gotchas, and then I update my system. The release of 10.6.4 recently was no different. After waiting a day I saved all my work, closed all my running applications and started Software Update.

For the first time in the more than seven years I've been running Mac OS X the update failed. It very nicely recovered and rebooted me to 10.6.3. At first I thought the download must have been corrupted so I tried it a second time, with the same unsatisfying result.

Over the weekend I downloaded outside of Software Update the package and tried to install it. Still no luck. This evening I hunted up the combination update package and tried it with no success. I ran Disk Utilities to verify the disk and correct the permissions, and tried the combo updater again. Failed.

Searching for "10.6.4 update fails" on Google lead me to this <a title="Apple Support: 10.6.4 update issues - fixed, sharing the steps" href="http://discussions.apple.com/thread.jspa?threadID=2468522&amp;tstart=0" target="_blank">Apple forum thread</a>, which talks about SmartBoard software as being the potential culprit. Just a couple of weeks ago we installed two SmartBoards at work and I installed the drivers and application on my laptop so I could interact with the boards. The Apple forum linked to a <a title="Smart Technologies: Remove the limit maxfiles 2000 line from a System Preferences file" href="http://smarttech.com/us/Support/Browse+Support/Support+Documents/KB2/146595.aspx" target="_blank">thread at Smart Technologies that explained the issue and how to resolve it</a>.

It seems in a fit of incredibly poor software citizenship, the Smart installer sets a limit on the number of open files - <em>for the entire operating system and all programs running on it</em>. This file handle limit not only prevented my update from running, it caused me to get some fairly vague messages that had me thinking something was corrupted.

Once I deleted the /etc/launchd.conf file that Smart Technologies saw fit to spam onto my computer the update ran smoothly and completed without a hitch.

Bad Smart Technologies, bad!
