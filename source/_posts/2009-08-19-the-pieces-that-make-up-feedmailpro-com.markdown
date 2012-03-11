---
date: '2009-08-19 18:03:27'
layout: post
comments: true
slug: the-pieces-that-make-up-feedmailpro-com
status: publish
title: The Pieces That Make Up FeedmailPro.com
wordpress_id: '1070'
categories:
- Education
- FeedmailPro.com
---

Here is an interesting list of the open source pieces that went into making [FeedmailPro.com](http://feedmailpro.com), in no particular order.  Remarkably, they are all free.  Perhaps what's even more remarkable is that I can't think of a paid alternative that I'd rather use in any of these cases, even if it was free.  Open source is great at making reliable code because so many eyeballs get to look at it, tear it apart, and fix weaknesses.  It general, I find it much more reliable than proprietary code.

This list can be a bit intimidating if you're new to this stuff.  Don't worry, you don't need to be an expert in any of these, and in fact [Slicehost](http://www.startbreakingfree.com/go/slicehost/) (where I'm hosting the app) has a great bunch of tutorials to help you get through installing the first five or so.  For non-technical people...this may only be interesting as a overview of what goes on behind the scenes, but I thought I'd post it just the same.

[![98857402_14e9645ed8](http://s3.amazonaws.com/oldbloguploads/2009/08/98857402_14e9645ed8.jpg)](http://s3.amazonaws.com/oldbloguploads/2009/08/98857402_14e9645ed8.jpg)
Photo of the linux penguin in an IBM add - [source](http://www.flickr.com/photos/phauly/98857402/).

**The components:**



	
  * [Ruby on Rails](http://www.rubyonrails.org)
The is the "web framework" that I used to make the site.  It provides you with a lot of functionality like creating models (subscribers, feeds, etc) and connecting it all to the database.  Many of the tools listed toward the end are "plugins" for Ruby on Rails.

	
  * [MySQL](http://www.mysql.com/)
This is the database running underneath which stores all the data and makes it permanent.

	
  * [Ubuntu Linux](http://www.ubuntu.com)
This is the operating system for the server hosted with [Slicehost.com](http://www.startbreakingfree.com/go/slicehost/).  It's stable, fast, and memory efficient.

	
  * [Nginx](http://nginx.net/)
This is the webserver which takes incoming requests from people's web browsers and routes them to my application.  You may have heard of Apache which is a more popular web server.  Nginx is newer on the scene, but I prefer it...faster and less memory intensive.

	
  * [Passenger mod_rails](http://www.modrails.com/)
Keeps lots of "worker" processes busy on the server processing requests, and spawns new ones if the existing ones can't keep up.

	
  * [Postfix](http://www.postfix.org/)
This is the mail server which handles all sending and receiving of email.  It's pretty much the standard in the linux world now and is known for being able to handle extremely high volumes of email.  I'm not sure what capacity I could get up to on my current server before needing to upgrade, but it's probably at least in the millions of emails per day.

	
  * [Courier](http://www.courier-mta.org/)
Handles logins and accounts on the mail server.  I've got accounts for bounces, complaints, unsubscribes, support, etc.

	
  * [DKIM-Milter](http://sourceforge.net/projects/dkim-milter/)
This plugin to Postfix "signs" outgoing emails to verify they originated from my domain.  This helps them get through some spam filters.

	
  * [GIT](http://git-scm.com/)
This is a "source control" system where I keep the code I'm writing.  It keeps track of versions and history of the files.

	
  * [Capistrano](http://www.capify.org/index.php/Capistrano)
This is used to "deploy" code from my development machine to the production server.  There are a number of steps each time you change the code to get it on the server, like shutting down what's currently running, cleaning up log files, moving over stuff you want to keep from the last version, starting up the new code, etc.  This lets you do all the steps with one command.

	
  * [Netbeans](http://www.netbeans.org/)
A text editor (and a whole lot more -the fancy word for it is "integrated development environment" or IDE) to write the code on my laptop.


**The rest are all plugins for Ruby on Rails:**





	
  * [Will_Paginate](http://wiki.github.com/mislav/will_paginate)
This helps you create "pages" - just like on google where there is a "next", "previous", 1, 2, 3....etc links at the bottom.

	
  * [AuthLogic](http://github.com/binarylogic/authlogic/tree/master)
Handles the logins, email activation, lost passwords, etc for creating new user accounts.

	
  * [Ruby-OpenID](http://rubyforge.org/projects/ruby-openid/)
Let's people login with OpenID instead of a email/password.

	
  * [rpx_now](http://github.com/grosser/rpx_now/tree/master)
Similar to above but also lets people use the fancy RPXNow.com widget with the big buttons for Google, Yahoo, etc.

	
  * [Feedzirra](http://github.com/pauldix/feedzirra/tree/master)
Library to quickly parse a lot of RSS or ATOM feeds.

	
  * [columbus](http://github.com/jnunemaker/columbus/tree/master)
Detects RSS feeds on a website.  This lets people type either the RSS feed directly or their blog URL (in which case columbus will "discover" the feed URL for them).

	
  * [Uniquify](http://github.com/ryanb/uniquify/tree/master)
Library to generate those unique "tokens" you see on the end of URL's.  Like when you click a confirmation link or unsubscribe link, sometimes you'll see a list of random characters on the end of it.  This generates those and makes sure there are no duplicates across your system.

	
  * [Chronic](http://chronic.rubyforge.org/)
This helps with some of the scheduling where I let people send out emails one per day, or week, or several times per week, etc.  More specifically it converts human readable time (like "next Thursday") into time that a computer can understand.

	
  * [Whenever](http://github.com/javan/whenever/tree/master)
This helps schedule recurring tasks that happen in the background, like parsing feeds, sending emails, checking for bounced emails, etc.

	
  * [delayed_job](http://github.com/tobi/delayed_job/tree/master)
This queues tasks to be processed at a later date, such as importing subscribers, or sending mailings.

	
  * [daemon_spawn](http://github.com/alexvollmer/daemon-spawn/tree/master)
This tool launches delayed_job in the background (or several of them to run at once if there is high volume).

	
  * [fastercsv](http://fastercsv.rubyforge.org/)
Handles importing and exporting csv files.

	
  * [paypal](http://dist.leetsoft.com/api/paypal/) and [money](http://rubyforge.org/projects/money/) gems
Handles processing of notifications when something happens over at Paypal, like someone subscribes, unsubscribes, sends a payment, etc.

	
  * [active_merchant](http://www.activemerchant.org/)
Communicates with Paypal to send affiliate payments.

	
  * [exception notifier](http://github.com/rails/exception_notification/tree/master)
Lets me know when errors occur on the website.


So those are all the pieces (might have missed a few but 27 listed here).  There's at least 100,000 lines of code above that I was able to use.  And what did I write?  About 4,000 lines of ruby code that ties it all together.  The user interface is completely new, the models and the logic, but as you can see many of the pieces underneath are modular and can be plugged in to to get the benefit without having to write them from scratch.

If you haven't seen the final product yet, take a second to [check it out](http://feedmailpro.com).

Until next time, keep breaking free!
Brian Armstrong
