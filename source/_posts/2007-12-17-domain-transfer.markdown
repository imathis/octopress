--- 
layout: post
comments: false
title: Domain Transfer
date: "2007-12-17"
link: false
categories: nerdliness
---
After waiting a week for the "losing" domain registrar to relinquish their hold on a domain I am transferring, I was able to take the next step in migrating from my old host to my new one.

Domain fraud is apparently a real issue, as all the registrars have elaborate safety checks and balances built in to almost any transaction.  While this a good it is a bit cumbersome at times.  In order to move the <a href="http://andifyoudidknow.com" title="And If You Did Know?">And If You Did Know?</a> domain I had to request a password from the old registrar and provide that to the new registrar as a way of establishing my <i>bona fides</i>.  What I didn't anticipate, although in hindsight this made perfect sense, was that I would be prevented from altering the name server information once the transfer process was underway.  Had I added the new name servers to the list <strong>before</strong> initiating the transfer, I would have been done.  By initiating the transfer I was locked out from updating the name servers.

The losing registrar held the transfer in limbo for a five days before actually releasing the domain.  I was contacted and given a chance to refute the transfer request on the off chance that someone was trying to steal my domain registration.  While I appreciated the care being taken to protect me, I found myself chaffing a bit as I had to wait.

This morning a quick dig of the domain showed that the old name server information was gone.  I was able to complete the transfer process at the new registrar, and now am in the process of linking that domain to the source folder on my new server.  Hopefully the site will be up and running by the time you read this posting.

Only two tasks remain to complete the migration: moving zanshin.net to its new home and establishing a domain for Sibylle's profession site and transferring her site to its new home.  With a long weekend coming up I am hoping to have everything moved and on the new server by early next week.
