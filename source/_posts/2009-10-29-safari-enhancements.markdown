--- 
layout: post
comments: false
title: Safari Enhancements
date: "2009-10-29"
link: false
categories: life
---
From the first time I used my PowerBook nearly seven years ago until today, Safari has been my browser of choice. I dabble with all the major players, and a few of the minor ones, but I always come back to Safari.

It isn't perfect however. There are two "enhancements" I make to my copy to better suit my browsing style.
## Force Links to Open in New Tab Instead of a New Window
By default, any time a web site uses the target="_blank" attribute on a link, Safari will open that link in a new window. I prefer it to open in a new tab in the current window. Open a Terminal window (<strong>Applicaitons -&gt; Utilities -&gt; Terminal</strong>) and enter the following command:
<pre>defaults write com.apple.Safari TargetedClicksCreateTabs -bool true</pre>
<img class="aligncenter size-full wp-image-2123" title="createTabs" src="http://zanshin.net/wp-content/uploads/2009/10/createTabs.png" alt="createTabs" width="505" height="213" />

You'll need to re-start Safari for the change to take effect.
## ClickToFlash
Ads and auto-loading Flash are annoying. The wonderful <a title="ClickToFlash" href="http://rentzsch.github.com/clicktoflash/" target="_blank">ClicktoFlash</a> plug-in gives you control over what Flash plays and what doesn't. I'm running the latest beta version without any difficulties at all. Download the plug-in, quit Safari, and install. Re-start Safari and after you visit a page with embedded Flash you'll see a new Safari menu item: ClickToFlash.... The Preferences option there will let you configure the plug-in to your tastes. Here is how I have my plug-in configured:

<img class="aligncenter size-full wp-image-2124" title="clickToFlashPreferences" src="http://zanshin.net/wp-content/uploads/2009/10/clickToFlashPreferences.png" alt="clickToFlashPreferences" width="446" height="522" />

I allow sIFR text replacement to work automatically, and I opted to have YouTube play videos encoded for H.264 with QuickTime instead of Flash.
