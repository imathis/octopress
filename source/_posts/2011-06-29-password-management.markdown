--- 
layout: post
comments: false
title: Password Management
date: 2011-6-29
link: false
categories: nerdliness
---
Shortly after buying my first Macintosh computers in January 2003 (a 17" G4 iMac and a 15" Titanium PowerBook G4), I downloaded a password management application called PasswordMaster by <a title="Maury McCown" href="http://www.maurymccown.com/" target="_blank">Maury McCown</a> of RAILhead Design. PasswordMaster created a simple database on my computer which has grown over the years to hold some  286 accounts, serial numbers, and passwords. I've always like that it was local to my machine, and never minded that I had to copy and paste or retype passwords it stored into various web forms over the years.

When I switched from the PowerBook to the MacBook Pro nearly two years I migrated this PowerPC app along with the rest of my stuff. It runs well enough inside of Rosetta that I have kept on using it. However, it appears that Mac OS X Lion (10.7) will no longer provide Rosetta support thereby ending my ability to run PasswordMaster.

Losing PasswordMaster (which hasn't been supported in years to my knowledge), coupled with an increasing awareness of the fragility of my password process (one really good password that gets used in far too many places) has prompted me to start looking at some modern password managers.

The two password management solutions that I was aware of are <a title="1Password" href="http://agilebits.com/products/1Password">1Password</a> and <a title="LastPass" href="https://lastpass.com/">LastPast</a>. The two accomplish the same task in different manners. LastPass uses browser add-ons or plugins to facilitate capturing and managing passwords. That the application is free is a plus in its favor. However, I found the ribbon that appeared at the top of pages with logon forms to be annoying rather than helpful. I typically sign out of Facebook at the end of using it, which results in the sign in page being displayed. LastPass interprets this re-display of the sign in page as a trigger to display the "do you want to sign in?" banner. I'm sure this behavior is configurable, but I didn't take the time to figure it out.

My other, larger, beef with LastPass is having my, albeit encrypted, information stored in the cloud. Just as switching from programs stored on punch cards to programs stored in disk drives was unsettling in the early 1980s, switching from having a database on my machine to one stored in the cloud is unsettling.

1Password is an application that works with your browsers and is far less obtrusive. It isn't free ($39.99), but it is more to my liking. Within minutes of installing the 30-day free trial I had captured several of my frequently visited accounts, and changed the password on Facebook from a fairly weak 7-character string to a 14-character string with lots of entropy. That I no longer know my Facebook password is a bit unsettling, but I like that the odds of someone cracking it just got much, much longer.

The 1Password name refers to the one password you have to remember -- the master password needed to unlock your 1Password repository. The default configuration locks the repository after only 20 minutes of no activity; meaning that since I only check Facebook two or three times a day, that my effective password length for Facebook is 23 characters, as my master password has 9 all by itself. Facebook, and indeed any other account I add to 1Password, is very safe.

There is a free (for now) 1Password app that works on my Android phone. By storing the 1Password repository in my Dropbox account, the phone app can give me the same security I have on my laptop. Of course this exposes my repository to the cloud. However, it somehow feels more under my control that having it stored at LastPass. Yes I know that Dropbox has had some security gaffes lately, but not every Dropbox account will contain a 1Password repository to be potentially attacked. Every LastPass account is guaranteed to have a password repository. (Actually I doubt anyone today has the resources to break the encryption on either of these repositories. But I don't know that we can say that will still be true in 10 or 20 years.)

I'm still getting used to having this new wrinkle in my sign on processes, but I am slowly growing to like it. And I am ready to start updating my venerable (and vulnerable) passwords to something more substantial cryptologically. I am not, however, looking forward to the potentially tedious process of capturing all the information in PasswordMaster before I lose the ability to run it.
