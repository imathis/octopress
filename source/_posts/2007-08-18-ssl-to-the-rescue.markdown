--- 
layout: post
title: SSL To The Rescue
date: 2007-8-18
comments: false
categories: nerdliness
link: false
---
Upon setting up the office in our new home this afternoon I tried to send an email only to get a "No Socket" error.  I fiddled around with the firewalls (Windows and Zone Alarms) to no avail, and rebooted a couple of times in a faint hope that magic would happen and my mail would be outbound again.

After a chat with Ernesto, a Microsoft consultant buddy of mine, I tried to telnet the Google SMTP port I was using for my mail, only to see a message stating, "Could not open connection on host...."  Access to port 25, the standard SMTP is blocked through our DSL connection.  (Thanks AT&T!)

A Google search on "AT&T DSL port 25 blocked" revealed several links from institutions explaining how to submit a form to AT&T to get the port block lifted on our account.  Then one commenter suggested that we all just try the SSL (secure socket layer) port of 465.  I quickly changed my account settings in the Live Mail beta I'm using and, viola!, my mail is outbound once again.

Best of all, its now fully secure on the outbound leg of its journey from my computer to the Google relay.
