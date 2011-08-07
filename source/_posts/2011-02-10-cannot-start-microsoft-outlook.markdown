--- 
layout: post
comments: false
title: Cannot Start Microsoft Outlook
date: 2011-2-10
link: false
categories: life
---
Less than a week after we installed Microsoft Office 2010 on my wife's new Toshiba laptop it stopped working. Any time you tried to start Outlook and error dialog saying, "Cannot start Microsoft Outlook" would be displayed. No reason, no helpful hint, just cannot start.

After several days and many Google searches here is how I fixed the problem.

If you are having a similar problem, please proceed with caution. I give no guarantee that these steps will work for you. Make sure you have a good back up of your computer before proceeding as your computer may explode.
## TL;DR
The short version is this - find the .pst file and remove it. This file contains the profile that Outlook uses and it has somehow become corrupted. Be warned that removing this file will wipe out your email if you are using POP instead of IMAP.
## Find the PST file
In my case, finding the location of the PST file used by Outlook was the hardest part of the ordeal. All of the knowledge base articles I found, and forum entries, et cetera, indicated I would find this file in the AppData directory under my wife's user account. Only it wasn't there. At first I didn't even see the AppData directory; it wasn't until someone at work clued me into Microsoft's practice of hiding some files and directories from users to protect them from themselves that I was able to find it.

With the AppData directory visible I still couldn't find the PST file. Nuts.

One forum entry suggested running the Mail applet from the Control Panel, which would allow me to switch to a new profile. Only the Mail applet produced a "Your system needs more memory or system resources. Close some windows and try again." message. Unfortunately the only window open at the time was the Control Panel. Clearly something was broken.

Searching for that last message lead me to a page the explained how to run the Mail applet from Safe Mode. Once I did that I was able to see the location of the profile that was corrupted. Instead of being in AppData it was in Documents\Outlook Files. Rebooting to leave safe mode I was able move the offending PST file to the desktop and finally start Outlook.

Outlook objected to not having a profile, but once I created a new one (still in Documents\Outlook Files, and still called Outlook.pst) every thing was working again.

There has to be an easier way to make all of this work - especially when it stops working. The average home computer user is going to be utterly defeated by a dialog that only says, "Cannot start Microsoft Outlook."
## Steps
1. Reboot into Safe Mode. Do this by holding the F8 key down while the machine restarts.

2. Open the Run dialog by using the Windows-R keystroke combination.

3. Type "C:\Program Files (x86)\Microsoft Office\Office14\MLCFG32.CPL" (without the quotes). It is worth noting that I had to try both Program Files and Program Files (x86) to find the MLCFG32.CPL file.

4. In the resulting Mail control panel applet, look to see where your PST file is located.

5. Reboot to leave Safe Mode

6. Make a copy of the corrupted PST file, this is critical if you are using POP3 to get your mail. The PST locates your mail on your machine. If you delete this file you'll lose all your mail.

7. Delete the corrupted PST file.

8. Start Outlook and when prompted, create a new profile. If you are using IMAP your account information should be there and your mail should start working again. If you are using POP you'll have to import mail from the old profile that you copied in step 6.

9. Have a beverage.
