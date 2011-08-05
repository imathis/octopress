--- 
layout: post
author: Mark
comments: "false"
title: Domino Effect
date: 2003-8-8
categories: nerdliness
---
My wife uses <a href="http://www.mozilla.org/projects/camino/">Camino</a> as her browser of choice. She likes to use the sidebar and the way Camino's works is pleasing to her.

Last night she tried to visit the Thomas Kinkade web site (http://www.thomaskinkade.com) and her browser crashed as a result. This was the first browser crash I had seen with Camino, and I was pleased to see they have a talkback feature that collects information about the crash and sends it off to the developers so they can identify and address the issue.

I suggested that she click through the process and send them a note. I didn't know that she had already seen this feature and ignored it in the past by clicking cancel. I should have listened to her.

The talkback process worked fine, but after it ran we were unable to relaunch Camino. The splash screen would appear and then the process would freeze. We tried downloading a new copy of version 0.7 and installing it only to get the same freeze.

After reading the Camino web site I discovered that there is a known problem with talkback preventing Camino from launching. D'oh! The error reporting software itself has errors, and they are major enough to basically destroy your application.

Sigh.

We did download the latest nightly build as the site indicated the talkback error had been addressed since the 0.7 release was made. And yes, the nightly build ran, but every so slowly. Far too slowly to be of any use as a daily use browser.

And, they've taken away the sidebar and made it a page overlay much like Safari. She wasn't happy with the speed or the lack of sidebar. We did use the nightly build to export her bookmarks.

So we loaded <a href="http://www.mozilla.org/products/firebird/">Mozilla Firebird</a> for her to use. Once the bookmarks were imported she was all set again.

All of this took about 90 minutes to accomplish. All she wanted to do was visit the Kinkade site to see information about 3 of his prints we have framed and hanging in the living room. Because that site is very poorly coded her browser crashed, the error reporting software then trashed the application itself, and she is now forced to use a completely different browser. It just shouldn't be this hard.
