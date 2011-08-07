--- 
layout: post
comments: false
title: Wordpress Automatic Update
date: 2008-7-17
link: false
categories: nerdliness
---
With the release of <a title="Wordpress.org" href="http://wordpress.org">Wordpress</a> 2.6 this week I was preparing to update both my test sites and our public sites <a title="Using rsync to Update Wordpress" href="http://zanshin.net/2008/04/28/using-rsync-to-update-wordpress/">using the rsync method</a> I wrote about in April.  Quite by happenstance I read an article on Download Squad about the <a title="Wordpress Automatic Updater plugin" href="http://wordpress.org/extend/plugins/wordpress-automatic-upgrade/">Wordpress Automatic Updater plugin</a>, and decided to give that a try instead.  In short it worked perfectly.

After downloading the plugin and installing it, I was able to upgrade each site from version 2.5.1 to 2.6 in a matter of minutes.  I opted to use the manual progression through the upgrade process, which is nicely laid out.  After verifying that my server would allow the plugin to work, backups were made of my Wordpress installation and content database.  The database backup allowed for dumps of add-on tables, which was very thoughtful.  After turning maintenance mode on, and disabling all the active plugins, except for itself, the plugin downloaded a copy of the latest release from Wordpress, unzipped it, and then installed it.  Wordpress Automatic Updater even allowed for the possibility that the underlying database structure would change as a result of a new version, and provided a link to a new browser page that let me trigger a database update.

At the end of the process a log file was displayed with a complete record of all the activities completed, and the I was given a option to clean up the temporary files created by the process.

Except for some mildly stilted (English as a second language?) phrasing in some of the prompts and informational messages, I found nothing about the plugin not to like.  An excellent addition to Wordpress, and one I highly recommend.
