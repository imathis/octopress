--- 
layout: post
title: Installing PostgreSQL with brew on Mac OS X
date: 2011-2-17
comments: true
categories: life
link: false
---
In September 2009 I wrote a lengthy how-to describing the process I followed <a title="Installing PostgreSQL on Snow Leopard (Mac OS x 10.6)" href="http://zanshin.net/2009/09/07/installing-postgresql-on-mac-10-6-snow-leopard/" target="_self">installing PostgreSQL 8.x</a> on my Mac running Snow Leopard. It was an interesting experience figuring out solutions to all the obstacles along the way. The posting is one of the most popular on my site, and it has generated several emails from people looking for help with their PostgreSQL installation.

As much fun as all of this has been I have wanted an easier way to set PostgreSQL up, particularly a way that avoided the entire dscl process of creating a new user id. With brew I think I've found a much easier process.
## Brew
<a title="Homebrew" href="http://mxcl.github.com/homebrew/" target="_blank">Homebrew</a>, or brew for short, is billed as the missing package manager for Mac OS X. MacPorts and Fink are the other two, perhaps more established, players in this space. Go visit their site for more information and instructions on how to get brew up and running on your system.
## Warning
As with any software installation process, you are proceeding at your own risk. Mucking around with package installers and things that live in the bowels of your file system are fine activities, but not for the uninitiated. Make a good backup and proceed with caution.
## Steps
With brew installed it is simple to install PostgreSQL:

That's it, you're done.
## Sysctl
When I went to initialize my first database using the new PostgreSQL installation I received an error saying the the memory request could not be satisfied. After some Googling I found out I needed to change the settings on a couple for sysctl managed attributes. Specifically kern.sysv.shmmax and kern.sysv.shmall. Here's what I changed mine to:

Changing sysctl managed attributes in this fashion only lasts until you restart the machine. If you don't want to repeatedly reset these values, create <strong>/etc/sysctl.conf</strong> and put the following 5 lines there and save the file.

If you follow these directions, please leave a comment and let me know how they worked for you.
