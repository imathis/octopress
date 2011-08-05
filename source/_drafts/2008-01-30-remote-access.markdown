--- 
layout: post
author: Mark
comments: "false"
title: Remote Access
date: 2008-1-30
categories: life
---
From time to time it would be convenient to access one or more of the computers at home remotely.  One of the projects I have going presently is to create a version control repository of all my code on the iMac, so that I can work on our hand-coded web sites from any machine in the house.  Since the other two machines I use on a regular basis are laptops, it would be ideal to open a port on my router to allow an inbound connection to the version repository on the iMac.

When I was a cable broadband customer this was relatively easy to accomplish.  I simply went to the routers configuration page and mapped a port to the IP address of the machine hosting the repository and I was done.  By inputting the IP address of my cable modem followed by the port number I'd assigned, I could remotely connect to the machine at home.

Today we are DSL subscribers and, as I discovered last evening, remote access isn't really feasible with DSL.  Inbound connections (from the wild and woolly Internet to your LAN) are blocked by the modem.  In order to configure the modem for remote access you must first unlock it using a 10-digit code stuck to the bottom of the modem on a bright yellow sticker.  Repeated attempts to enter the code failed, and so I started a support chat session with AT&amp;T.

The online chat support representative was friendly, but ultimately unable to help.  (As an aside, both Sibylle and I have noted that online chat support makes heavy use of pre-programmed or canned messages, which make for a rather stilted conversation.)  Once I was connected with a technical support person over the telephone, I was instructed to reset the modem.  As the universe tends toward the ironic,  this is when my phone connection with technical support died.  Oh, and the modem was no longer talking to the Internet.  And, I couldn't log onto the modem.

The next technical support person I was connected to was able to show me how to re-apply the user id and password necessary for the modem to resolve it's connection to AT&amp;T.  Our Internet connection was restored.

Revisiting the remote access configuration, the original problem, I discovered that resetting the modem had updated the configuration page.  Inputting the remote access code worked!  Yay!

Unfortunately, AT&amp;T thinks we shouldn't have continuous remote access to our home network.  Remote access only lasts for 20 minutes of inactivity and then it automatically resets. Boo!  Perhaps I'll call them again to see if there is a way to open that access window permanently; otherwise DSL is useless for remote access, at least as I define it.
