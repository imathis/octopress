--- 
layout: post
title: A Layered Defense for Email
date: 2007-8-22
comments: true
categories: nerdliness
link: false
---
A couple of years ago I was introduced to a spam filtering technique by a colleague of mine.  The idea has been percolating in the recesses of my mind ever since and I have finally put it into practice.  In short it is a layered defense.

To do this you will need four email addresses.  A public address that you will give out to any and all who ask, a filter email address that you won't share with anyone, your real email address, and an address for online businesses you deal with.

<strong>The Public Email</strong>
This is the address you'll give to people who you don't know.  It's the address you'd put on a business card.  You expect this address to be harvested by spammers and you really don't care since every email sent to this address will be deleted.  For this email address you will need to setup two rules on your mail server.

<u>Rule One</u>
An auto-responder.  Normally this function is used when you are on vacation to tell people that you'll reply to their message when you get back.  In our case we are going to reply to every incoming email with a message saying that in order to reach you they need to re-send their original email to the filter email address.  Since the spammers use software to send their email they aren't going to see, or respond to, the email with the filter address.  Only a human will.

<u>Rule Two</u>
Once the auto-responder is setup, you'll want to create a second rule to delete the mail from your mailbox.  In my case this rules wipes out some 700-900 spams a day.  Make sure the rules execute in the proper order otherwise you'll delete all the mail before sending the auto-response.

<strong>The Filter Email</strong>
The middle layer in this defense is the filter email address.  This can be any address you want; expect to periodically change this as it may become known to spammers over time.  There is a single rule for this account.

<u>Rule One</u>
Create a rule that forwards all email to this account to your real email account.  By using this redirection your real email address is still unpublished and unknown outside of the circle of people you trust.

<strong>Your Real Email</strong>
The last layer in this system is your real email address.  This is the address you'll use with family, friends, and trusted people.  It will receive the automatically forwarded email from the filter address. Be careful to <strong>not</strong> use it online in forms, et cetera, or it will start getting unwanted email traffic.

When you get an email that has been forwarded from your filter address you will have a choice: either give them your real email address and trust them, or continue to use the filter email address with them.  By altering the "reply-to" field on outgoing emails you can continue to hide your real email address should you choose.

<Strong>Dealing with Companies</strong>
Where this system breaks down is in dealing  with online retailers or your bank or other businesses that want to sent you email.  Usually the email notifications you get from Amazon, say, are sent from an account that you can't reply to.  If you use the public email address to sign up for alerts you'll never get them as the auto-response won't be seen and acted upon.  You'll have to give those businesses you deal with online a valid email address.  Create a retail email address for use with your bank, Amazon, et cetera.  If you are like me you likely all ready have an email address associated with the companies you do business with online.  This is okay, but be aware that some merchants will share your email address.

<strong>In Practice</strong>
I've only been using this layered email approach for a couple of days now.  As I said before it has eliminated several hundred spam emails <i>per day</i> from even downloading to my email client.  Most of the people I know already have my real email address so I haven't had the opportunity to hand out the public one as of yet, but I have tested the auto-responder and the forwarding rules on the first two layers of the system successfully.

I expect that over time the filer email address will become known to spammers and that the forwarding rule there will start to pass on spam to me.  When that happens I'll simply increment the address by adding a number to it, update the auto-response and forwarding rules and once again, leave the spam behind.

Perhaps this is easier for me as I have my own domain and can create as many email accounts and rules as I like.  I also can set my domain up such that any email sent to a bogus address at my domain is simply deleted.  If (when) the filter email address is overrun, changing it to a different account will cause the incoming spam to be automatically deleted.

While I haven't tested this idea using GMail I think you could implement this system there with three different GMail accounts.  Yahoo! Mail or Hotmail or any of the other web based providers will probably work too.

If you have any thoughts or ideas about this, or if you want to see my automatic response message, you can email me at <a href="mailto:mnichols@zanshin.net">mnichols@zanshin.net</a>.
