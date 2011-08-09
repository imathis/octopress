--- 
layout: post
title: More Email Nerdery
date: 2007-9-10
comments: true
categories: nerdliness
link: false
---
<strong>The Goal</strong>
I want to be able to read all my email, including my GMail accounts, via the OS-based client on the laptop I am currently using.  I have two primary computers, a Powerbook running Mac OS X (10.4.10) and a ThinkPad running Windows XP SP2.  On the Mac I use Apple Mail, and on the ThinkPad I am currently using Windows Live Mail (beta).

<strong>The Accounts</strong>
I have five email address I want to consolidate into one, easy to access solution.  Three domain accounts, A, B, and C; and two GMail accounts, my primary email address G' and a secondary GMail account, G''.

<strong>The Setup</strong>
Following the directions on GMail's account tab, I configured GMail to read my domain accounts (A, B, and C) via POP3.  Using the mail forwarding tab on GMail, I configured the secondary GMail account (G'') to automatically forward all incoming email to the primary GMail account (G').

Now, if I was satisfied to use the web interface, I could access all my mail in one place: GMail.

However I want to use the richer text editing features of an OS-based client for my mail.  Furthermore, I want to use two different email clients on two different machines.  Oh, and I want to download all the messages to either machine so they are in sync all the time.  IMAP is the protocol to allow this type of access, unfortunately GMail doesn't allow for IMAP access.  You can configure your desktop client to read your GMail account via POP3, with an option to leave the read messages behind on the server.  If you wanted to use a single computer for email, this would be the solution for you.

<strong>IMAP to the Rescue</strong>
Using IMAP is the answer, but not obviously so.  I created a new domain email account, call it "I" for IMAP.  This account will be the only account my laptops access.  Since it is IMAP, each machine will be able to synchronize its list of message regardless of how long it has been since that machine was used for email.

Using the email forwarding tab on GMail again, I created a rule to forward all incoming email from my primary Gmail account (G') to my new domain account. Furthermore, I configured each OS-based email client (Apple Mail or Windows Live Mail) it to use the Google smtp server for sending mail. Within each client, I also checked the "save sent mail on server" option. By using the GMail smtp server all mail I send, from either laptop, appears to come from my primary Gmail account, and is saved in the primary GMail account sent folder on the server.

<strong>What This All Means</strong>
Any mail sent to one of my five email addresses ends up in the primary GMail account inbox.  Mail sent to my domain accounts is ready by GMail, and mail sent to my secondary GMail address is forwarded there.

Any mail in my primary Gmail inbox is forwarded to the IMAP account ("I") on my domain.

Both of my laptops are configured to read the domain IMAP account, and to use GMail as the outbound smtp server.  Any mail I send goes through GMail, gets saved on the Gmail server, and has my GMail address as the reply-to value.

I can now read my mail via the GMail web interface (handy when I'm not at one of my computers), through Apple Mail, or through Windows Live Mail.  I see all my mail in either of those places, and all my mail is synchronized regardless of where and how I access it.  As an added bonus my mail is filtered through the GMail spam filter before being filtered through my OS based email filters a second time.
