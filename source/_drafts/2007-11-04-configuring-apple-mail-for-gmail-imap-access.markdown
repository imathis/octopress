--- 
layout: post
author: Mark
comments: "false"
title: Configuring Apple Mail for GMail IMAP Access
date: 2007-11-4
categories: nerdliness
---
Like many people I was excited when I learned that Google was adding the IMAP protocol to GMail, and I have been playing with it in various desktop email clients ever since my accounts were all enabled.

By far, Apple Mail handles the fusion of Google Mail and desktop client the best.  The directions Google provides are great as far as they go, but there are some additional steps one can take to tighten the integration between the two platforms.  Once you've added a GMail account to Mail, you will see a [Gmail] folder, and nested inside that will be folders for All Mail, Sent, Drafts, Trash, and Spam.  Unless you take an additional step, these folders on your Mac won't be synchronized with their counterparts on GMail.  (You will also see folders for each label you created on GMail.)

Select [Gmail]/Drafts and then click on the Mailbox|Use This Mailbox For menu option.  In the popup dialog select Drafts.  This will link Mail's drafts folder with Gmails.  Drafts created on your computer will be synchronized with the folder on Googles server.

Repeat these steps for Sent, mating [Gmail]/Sent with Sent, and for Spam, mating [Gmail]/Spam with Junk.  Do not mate [Gmail]/Trash with Trash.  Linking your local trash with Google's trash will cause any mail you delete locally to be deleted forever on the server as well.

If, like me, you have multiple GMail accounts, you'll end up with an entry for each account, nested under Inbox, Sent, Drafts, and Junk.  Clicking on the containing folder, Inbox for example, will show you the aggregation of all your incoming mail.  Clicking on one of the account labels underneath the containing folder will show you just that category of mail for that account.

One of the nice features about GMail on the web is being able to archive mail, which removes it from the inbox, but leaves it in any assigned labels and in the All Mail label.  Apple Mail does not provide an archive button, but you can use the Delete key to get the same functionality.  Since we didn't link the local Trash folder with the [Gmail] folder, selecting an email in an inbox, and pressing the delete key just removes it from the inbox.  The mail is still in the All Mail folder on your machine, which corresponds to the All Mail label on GMail.  I admit that pressing the delete key to archive is uncomfortable; I suggest trying it our for yourself on some test mail.  (A) to convince yourself that it works that way, and (B) as a check that you do not have local Trash linked to [Gmail] trash.

The final step I took was to adjust the Mailbox behaviors for each account.  Drafts, Sent, and Junk I set to store messages on the server.  For Sent I set the "Delete sent messages when:" option to never.  For Junk I set the "Delete Junk messages when:" option to one week.

For the Trash folder I unchecked both "Store deleted messages on the server" option and the "Move deleted message to the Trash mailbox" option.  This allows the delete key to act as an archive function.

I've been up and running under this configuration for several days now and I am very pleased.  I've had less success with Windows Live Mail, and Thunderbird as desktop email clients in general, and with their configuration to use GMail via IMAP in particular.  They are nice enough but neither provides (to my knowledge) any way to neatly synchronize the Drafts, Sent, and Junk folders the way Apple Mail does.  Also, neither Live Mail or Thunderbird handles threaded conversations as neatly.
