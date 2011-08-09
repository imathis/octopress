--- 
layout: post
title: How to Disable System Tray Popups
date: 2007-7-17
comments: false
categories: nerdliness
link: false
---
I get tired of endless popup notifications from the various denizens of the system tray telling me well-meaning but generally useless bits of information.  One aspect of the Mac OS X interface that I truly like is that you are only notified when there is some action you need to take, not for every minor change in your operating system's landscape.

The Wireless connectivity icon, and the Ethernet connectivity icon are the worst offenders in my book.  I use a wireless broadband card to connect while I am at work, so both of these system tray features are constantly telling me that there is no connection.  First the wireless connectivity monitor spouts off, and then the Ethernet one.  It's annoying to me.

So.

Thanks to Google, and this <a href="http://www.winbookcorp.com/_technote/WBTA20000902.htm" title="How to Disable Notification Area Balloon Tips in Windows XP">page</a>, I give you these steps, recorded here so I don't have to find them again.

1. Click on Start and then on Run.
2. In the open box type regedit and then click OK.
3. Click on the plus (+) next to HKEY_CURRENT_USER.
4. Click on the plus (+) next to Software.
5. Click on the plus (+) next to Microsoft.
6. Click on the plus (+) next to Windows.
7. Click on the plus (+) next to CurrentVersion.
8. Click on the plus (+) next to Explorer.
9. Click on the folder that says Advanced. This should give you a long list of items on the right window pane.
10. Click on Edit, select New, and choose DWORD Value.
11. Name the new DWORD Value EnableBalloonTips.
12. Double-click this new entry, set the value to 0.
13. Fill in the dot next to Hexadecimal.
14. Close the Registry Editor and reboot the computer normally.
15. You have now disabled the balloon tips in the system tray.

Enjoy your notification free world.
