--- 
layout: post
title: Outlook Rule to Delay Sending Mail
date: 2008-2-21
comments: false
categories: life
link: false
---
If you are like me, you have at least once in your email usage history, accidentally sent a mail that you either didn't mean to send, or immediately wanted to recall to edit or attach or otherwise massage before sending. Wouldn't it be nice if there was a way to hold your outbound emails for a short period of time?

As luck would have it, there is a way.  At least if you are using Outlook.
## Check Messages After Sending
Create a new rule using the "Start from a blank rule" option.  In the Rules Wizard, under the "Step 1: Select when messages should be checked" option, pick "Check messages after sending."

<img src="http://zanshin.net/images/checkMessagesAfterSending.JPG" alt="Check Messages After Sending dialog option" align="middle" border="10" height="476" width="443" />

Click next.
## Which Conditions Do You Want To Check
Unless you want to apply the delay rule to a specific subset of messages you send, click next on the "Which condition(s) do you want to check?" dialog.  Outlook will confirm that you really want to apply this rule to every message you send.  Click yes.

<img src="http://zanshin.net/images/whichConditionsToCheck.JPG" alt="Which Conditions to Check dialog option" align="middle" border="10" height="476" width="443" />
## What Do You Want To Do With The Message
On the "What do you want to do with the message?" dialog select the last option, "defer delivery by a number of minutes."  Once you've selected that, click on the underlined portion of the statement in the edit portion of the dialog and enter the delay you want.  Originally I had 5 minutes but I find this is too long so I've cut that back to 3 recently.

<img src="http://zanshin.net/images/whatToDoWithMessage.JPG" alt="What To Do With The Message option" align="middle" border="10" height="476" width="443" />

Click next again.
## Exceptions
The "Are there any exceptions?" dialog gives you another chance to limit the scope of your new rule.  Unless you want to add some exceptions, click next.

<img src="http://zanshin.net/images/exceptions.JPG" alt="Exceptions dialog" align="middle" border="10" height="476" width="443" />
## Naming the Rule
The final step is to name your new rule.  I called mine "Defer sending."

<img src="http://zanshin.net/images/nameTheRule.JPG" alt="Name the Rule dialog" align="middle" border="10" height="476" width="443" />
## Client-Only
Click Finish to complete the rule.  Outlook will popup a message warning you that this is a client-only rule, that will only run when Outlook is running.  Click on OK.

<img src="http://zanshin.net/images/clientOnlyRule.JPG" alt="Client only rule popup" align="middle" border="10" height="115" width="443" />
## All Done
That's it!  You now have a built-in sending delay or 3 or 5 or whatever minutes.  The next time you hit send without having attached the file, or just before realizing that you didn't spell check the message, you now have a chance to visit the outbox and correct the mail before it is sent.
