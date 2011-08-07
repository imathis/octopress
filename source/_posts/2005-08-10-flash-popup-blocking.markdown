--- 
layout: post
comments: false
title: Flash Popup Blocking
date: 2005-8-10
link: false
categories: nerdliness
---
One of the reasons I use Firefox when I am web browsing on a Windows OS machine is the ability to block popup advertising. Imagine my dismay to learn of a new exploit that allows the spawning of popup windows even with popup blocking enabled. It seems that using the Flash plugin we all have installed in our browsers it is possible to launch popup windows. The blocker doesn't prevent this since it is aimed at preventing javascript launched windows.

Fortunately, you can get around this in Firefox. (Thanks to <a href="http://www.petebevin.com/archives/2005/03/10/firefox_popups.html" title="Pete Bevin">Pete Bevin</a> for the original posting.)

1. Type about:config into the Firefox location bar.
2. Right-click on the page and select New and then Integer.
3. Name it privacy.popups.disable_from_plugins
4. Set the value to 2.

The possible values are:

* 0: Allow all popups from plugins.
* 1: Allow popups, but limit them to dom.popup_maximum.
* 2: Block popups from plugins.
* 3: Block popups from plugins, even on whitelisted sites.

