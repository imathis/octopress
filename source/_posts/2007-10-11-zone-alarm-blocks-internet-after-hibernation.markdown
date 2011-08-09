--- 
layout: post
title: Zone Alarm Blocks Internet After Hibernation
date: "2007-10-11"
comments: true
categories: nerdliness
link: false
---
I have a love-hate relationship with Zone Alarm.  Operating a Windows XP machine without virus and adware/spyware protection is foolhardy at best, so I appreciate having it on my laptop as a software barrier.  However, it often times gets in the way of normal operations making wish I could operate safely without it.

Recently, upon waking the ThinkPad from sleep or hibernation, I was unable to access the Internet.  Email, IM, and Web browsing all refused to work.  Eventually I discovered that if I stopped Zone Alarm and restarted it my connectivity would be restored.

Searching the Zone Alarm forums I discovered I wasn't the only person with this issue.  The fix (I hope) is fairly easy:  add the IP addresses for your DHCP and DNS.  In my case the DHCP source is my LinkSys router, and the only DNS entry I have is the DSL modem upstream from the router.  Here are the steps I followed, for future reference:

1.  Open a command prompt and type <strong>ipconfig /all</strong>.  In the output of this command will be the DHCP server address, and any DNS IP addresses.  Copy these.

2. Open Zone Alarm's control center and go to the <strong>Firewall</strong> page.  Once there open the <strong>Zones</strong> tab.  At the bottom of that page click on the <strong>Add</strong> button.  In the dialog that appears add the one of the IP addresses you copied in step 1.

3. Repeat for all the IP addresses you copied in step 1.

4. Apply your changes and, hopefully, in the future Zone Alarm won't interfere with your connectivity upon waking the machine.
