--- 
layout: post
title: How to See Your Mailing List Postings Using Gmail
date: 2007-11-7
comments: false
categories: nerdliness
link: false
---
Recently I joined a very active mailing list for the Ubuntu operating system.  In doing so I discovered a "feature" of Gmail.  By default (and a setting that you can't change), any mail you post to a mailing list isn't reflected in your inbox.  Instead the mail is shown only in <b>Sent Mail</b> and <b>All Mail</b> on your account.  If you search the Gmail help pages you will find that this is done "<a href="https://mail.google.com/support/bin/answer.py?answer=6588" title="save time and prevent clutter">to save you time and prevent clutter</a>."

Normally when you post a message to a mailing list, you see your message and (hopefully) some responses to it.  If you thread your messages the responses are all neatly tied back to the original message, allowing you to read entire topics of discussion easily.  The problem with Google's approach to mailing list is that you can't find your thread in the conversation, even if it is the originating post.

<strong>Apple Mail Smart Mailboxes To The Rescue</strong>
Apple Mail provides a feature called "smart mailboxes."  These are folders that have a filter or set of rules that determine their contents.  To see your postings in a mailing list create a new smart mailbox with these rules:

+ Message is in mailbox [inbox]
+ Message is in mailbox [sent]

Make sure you select the "meets any" condition and not the "meets all" condition, and tick the "Include messages from Sent" for good measure.

The new folder will now contain the messages you sent as well as the messages you received; and they will be properly threaded.

<strong>NB</strong>: In my case I have a separate email address for the mail list, so the <i>only</i> messages in sent are ones I've posted to the list.  I'm not sure how this would work if your primary sent folder was included in the rules for the smart mailbox.
