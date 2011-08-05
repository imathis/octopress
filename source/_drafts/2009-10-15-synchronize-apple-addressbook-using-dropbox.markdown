--- 
layout: post
author: Mark
comments: "false"
title: Synchronize Apple AddressBook Using Dropbox
date: "2009-10-15"
categories: life
---
<address>Updated: 10.16.2009 </address>While this appears to work I am noticing problems with Adium, which can be configured to use address book cards for information about chat buddies. Also, each of the various groups I had created in my address book was replicated three and sometimes four times. Finally, Dropbox was continually refreshing and updating files associated with the address book stored there. I suspect these updates were a result of emails sent and or accesses by Adium. As a result, I have deleted the symbolic links to Dropbox on each machine and restored each address book using the combined one I had made earlier.

Proceed with this how-to with caution and a good backup...

In order to synchronize your Apple AddressBook using Dropbox you need to have <a title="Dropbox" href="http://dropbox.com" target="_blank">Dropbox</a> installed on all the computers you wish to sync, and you need to have some comfort running commands in Terminal. This synchronization is relatively easy to accomplish, but missing a step or mistyping a command could leave you without ready access to your address book. Make backups and follow the steps carefully and you should be okay.
# First Step
Get a copy of Dropbox if you haven't already. It's an amazingly useful tool that gives you 2 GB of storage on the "cloud" for free. With clients for Linux, Windows, and Mac operating systems, I use it every day. The installation and setup is well explained on the Dropbox site so I won't cover that here.
# Second Step
With Dropbox installed on each machine you wish to sync you need to prepare and backup your AddressBook. To prepare my Address Book I combined all my addresses into a single address book. This combined address book is the one I pushed to Dropbox. But before that I made backups of all my address books. Under File | Export you'll find the <strong>Address Book Archive...</strong> option.
<p style="text-align: center;"><img class="aligncenter size-full wp-image-2014" title="addressBookBackup" src="http://zanshin.net/wp-content/uploads/2009/10/addressBookBackup.jpg" alt="addressBookBackup" width="491" height="231" /></p>

# Third Step
Once your backups are completed, you are ready to move the combined Address Book to Dropbox. To do this you will use the <strong>Terminal</strong> application located in the <strong>Applications | Utilities</strong> folder. Make sure that you have quit Address Book before doing these commands. Also, these commands assume your Dropbox is located in your home folder. If you placed it elsewhere, you'll have to adjust the Dropbox path accordingly.

This will move your AddressBook directory to Dropbox. Next create a symbolic link on your machine to point to the new location for the AddressBook directory. Like this:

Now when you start AddressBook it will use the symbolic link in ~/Library/Application \Support to find the actual AddressBook in ~/Dropbox. Start AddressBook to make sure you've typed everything correctly to this point.
# Forth Step
With AddressBook working on the first machine it is time to setup the other machine or machines. Since you combined the AddressBook already, all you need to do is move the AddressBook directory from ~/Library/Application \Support and add a symbolic link to the Dropbox location. Again use the Terminal to issue these commands:

The <strong>cd</strong> moves you to your home directory. <strong>mkdir backups</strong> creates a backups directory. <strong>mv ~/Library/Application \Support/AddressBook/ ~/backups</strong> moves the existing AddressBook directory to the backups directory. This is perhaps safer than outright deleting the directory. The <strong>ln</strong> command creates the symbolic link necessary for the Address Book application to find the data now located in Dropbox.

Repeat the Forth step for each machine you want to share your Address Book with.
# Caveat
Address Book wasn't written with multiple copies accessing a single, shared set of data in mind. I haven't experimented with having the Address Book application open on more than one machine at the same time. I would expect this to cause errors and possible data corruption. I rarely have Address Book open at all, usually only to update an address or add or remove people. If your usage paradigm is different than mine and you have Address Book open all the time, you may need to be prepared to restore from the backups you made.
