--- 
layout: post
title: Using CRON to Control TimeMachine Backups
date: 2009-9-2
comments: true
categories: nerdliness
link: false
---
My office setup includes two Macintosh computers, a Mac Pro and a MacBook Pro. I have a 500 GB FireWire drive attached to the Mac Pro that I use for TimeMachine backups. Through the power of a DNS entry for the Mac Pro, and this article on <a title="Network TimeMachine backups to another Mac" href="http://opensoul.org/2009/1/15/network-time-machine-backups-to-another-mac">Network Time Machine backups to another Mac</a>, I am able to backup the MacBook Pro, wirelessly, to the TimeMachine drive on the Mac Pro.

The only problem with this arrangement is that the MacBook Pro attempts to back itself up regardless of my location. When I'm at home at it is connected to our home network it can locate my work computer (via the DNS entry) and it tries to use our less-than-significant upload bandwidth to backup once an hour. The simple solution is to turn TimeMachine off when I am at home. Of course that means remembering to turn it back on again the next day I'm at work. On occasion the simple solution has meant the MacBook Pros backups are a week or more behind.

A better solution would be a script or automated action that would turn TimeMachine on or off. Since I work relatively stable hours a cron job coupled with code to activate or deactivate TimeMachine would suffice.

You can turn TimeMachine on or off via Terminal using this defaults command:

I created two bash scripts, one to turn TimeMachine on:

And another to turn it off:

The final step is to create two cron entries, one for 8 am Monday through Friday to run the "on" script from above. And the second for 5 pm Monday through Friday to run the "off" script from above. Crontab entries are in this order: minute hour day-of-month month day-of-week what-to-do. The day-of-week entry uses either 0 or 7 for Sunday, with Monday as 1, Tuesday as 2, and so forth. So the "on" script entry would look like this: <strong>0 8 * * 1-5 ~/bin/timeMachineon.sh</strong> and the "off" script entry would look like this: <strong>0 8 * * 1-5 ~/bin/timeMachineoff.sh</strong>.

Here's my completed crontab:

Now TimeMachine only runs during working hours when I am (presumably) on the work network.

<strong>Update 1:</strong> The evening cron job fails to run when the laptop is closed, i.e., sleeping, when 5 pm rolls around. Cron is a useful tool but it has to be awake to run. I've changed the evening cron time to 4 pm, a time I am almost always still at work. I am considering adding a second evening crontab entry, say for 7 or 8 pm in case the 4 o'clock instance is missed for some reason. A better solution would be a network aware triggering of the scripts, running the on script only when the work network is detected, and the off script for all other networks.

<strong>Update 2:</strong> Here's the latest solution, based on Josh's comments.

I created a script called login-hook.sh, which is the target of:

This script tests to see if a TimeMachine control script is running at every login, and starts it if necessary:

And tm-control.sh runs the Python script Josh supplied every 30 minutes (1800 seconds), in effect simulating a cron job, but leveraging the network awareness of the Python script. Here's tm-control.sh:

<strong>Update 3:</strong> Getting LoginHook to work is a bit finicky. By using <strong><em>defaults read com.apple.loginwindow LoginHook</em></strong>, you can display the current setting, if any, this attribute has. <strong><em>defaults delete com.apple.loginwindow LoginHook</em></strong> will allow you to remove the setting. Make sure you have your login-hook.sh, and the script it calls in place prior to establishing the hook and you should be okay.
