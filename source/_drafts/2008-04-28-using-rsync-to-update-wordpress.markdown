--- 
layout: post
author: Mark
comments: "false"
title: Using rsync to Update Wordpress
date: 2008-4-28
categories: nerdliness
---
I currently support four public facing sites that use Wordpress as the back-end content management system (CMS).  I also have a Wordpress test platform on my laptop, where I tinker with several different themes, that supports another four sites. So, I've got eight different Wordpress installations to update each time a new release is made available.  Running through the update steps is tedious at best and, with the need to not inadvertently overlay the theme or plugin directory in each installation, there is a fair amount of stress.  Using ftp to accomplish the update isn't difficult, but after doing the same steps four or five or six times, it is easier to make a mistake.

Wordpress does provide <a title="Installing/Updating Wordpress with Subversion" href="http://codex.wordpress.org/Installing/Updating_WordPress_with_Subversion">instructions for how to accomplish site updates using Subversion</a>.  Unfortunately, my host provider doesn't have Subversion installed, nor are they inclined to add it just for me.  As I am comfortable with command line tools, I decided to investigate rsync as a solution for my update tasks.
## Rsync
Rsync is remote synchronization software that allows you to keep files in two locations in sync with each other.  This is not a rsync tutorial, so I high encourage you to read the man page, or visit one of the <a title="rsync - Google Search" href="http://www.google.com/search?q=rsync">numerous sites explaining this powerful tools uses</a>.

For my purpose I want my Wordpress update steps to be the following:
<ol>
	<li>Download and expand the latest Wordpress version.</li>
	<li>Execute one rsync command for each site to be updated.</li>
	<li>Enjoy a beverage.</li>
</ol>
<div>As always, before updating your Wordpress installation you should have a current, complete back up.  I will not be responsible for any lost files resulting from the following command.  </div>
### Basics
<div>The basic format of rsync is</div>
<pre>rsync [options] source_directory target_directory</pre>
Where <em>[options]</em> are the command options, <em>source_directory</em> is the location of the files you want to synchronize, and <em>target_directory</em> is the location of the files to be synchronized.

There are a myriad of options for rsync, but the three (or four) that I used are:
<ul>
	<li><span style="font-family: 'Courier New'; line-height: 18px; white-space: pre; "><span style="font-family: 'Lucida Grande'; line-height: 19px; white-space: normal; ">-</span><span style="font-family: 'Lucida Grande'; line-height: 19px; white-space: normal; ">r : Recursive mode, recurses through all sub-directories contained within the source_directory</span></span></li>
	<li>-a : Archive mode, which is equivalent to setting the -rlptgoD flags, for recursive, preservation of links, permissions, time, group, owner, and Device.</li>
	<li>-v : Verbose mode, to see exactly what the command is doing</li>
	<li>-n : Dry-run mode, shows the effect of the command without actually running it.</li>
</ul>
Running the command with the <em>-n</em> switch is a good idea, if for nothing else to verify your source and target directories. (Once you run the command to your satisfaction using <em>-n</em>, simply edit the command from your shell history, and remove the "<em>n</em>" leaving the rest of the command untouched.)
### Putting It Together
Here then, is the command as I run it to update my remotely hosted sites:
<pre>rsync -rav ~/Desktop/wordpress/ myUserName@myServerName:public_html/siteRoot</pre>
Obviously, you will need to substitute your username and server name.  After responding to a password prompt, the command executes and your Wordpress installation is updated from top to bottom, leaving any theme or plugins behind.  Any modifications you've made to Wordpress code will be overlaid, so you'll have to re-apply those once rsync is finished.

To update my locally hosted test sites, which are built upon <a title="MAMP" href="http://www.mamp.info/">MAMP</a>, the command looks like this:
<pre>rsync -rav ~/Desktop/wordpress/ /Applications/MAMP/htdocs/siteRoot</pre>
The final step would be to encapsulate the rsync commands in a shell script so they can be executed without the need to retype them each time they are needed. Or you could create an alias in your bash profile for each destination and execute the sync that way.

 
