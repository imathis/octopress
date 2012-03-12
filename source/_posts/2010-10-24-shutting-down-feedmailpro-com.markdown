---
date: '2010-10-24 05:19:04'
layout: post
comments: true
slug: shutting-down-feedmailpro-com
status: publish
title: Shutting Down FeedmailPro.com
wordpress_id: '1663'
categories:
- Advice
- FeedmailPro.com
---

Had a bit of a sad moment today as I finally shut down FeedmailPro (or at least began the transition process to do so).

I'd been contemplating this move for a while, and finally bit the bullet.  Why?  Well the short answer is that I don't have enough time to work on it, and it never took off the way I'd hoped.  Actually, Email Service Providers have gotten a lot better since I created FeedmailPro (the narcissist in me would like to think I had something to do with that - pushing the competition in the right direction - but it's probably totally unrelated).

Since I created it, 800 blogs have come to depend on it (albeit only 20 were paying customers) so clearly, communicating this news to the users of FeedmailPro is no small task.  I fully expect to upset some people in doing this, but there is definitely a right and wrong way to go about doing it.  Probably the biggest thing I was able to do was setup an excellent transition process for all the users to move over to MailChimp.  So hopefully this will be a step in the right direciton.  Below I've included some excerpts from [the page I created on FeedmailPro](http://feedmailpro.com/mailchimp) to explain the transition to all the users.

I also made an effort give as much transparency as possible on the page.  I spoke in the first person and used the words "I'm sorry" (as opposed to "[we apologize for any inconvenience](http://37signals.com/svn/posts/1528-the-bullshit-of-outage-language)" or hedging language like that).

The transition page is displayed below.

Until next time, keep breaking free (even when it means making difficult decisions),
Brian Armstrong

P.S. If you are ever facing a similar dilema on sticking with a project or dropping it, one of my favorite books on the subject is Seth Godin's [The Dip: A Little Book That Teaches You When to Quit (and When to Stick)](http://www.amazon.com/gp/product/1591841666?ie=UTF8&tag=httpwwwstartb-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1591841666)![](http://www.assoc-amazon.com/e/ir?t=httpwwwstartb-20&l=as2&o=1&a=1591841666).

=================================================================


# FeedmailPro Is Closing!


On December 1st, 2010, FeedmailPro will permanently shutdown and stop sending email.

It's recommended for all current FeedmailPro customers to export their data and transition their email lists over to [MailChimp](http://www.mailchimp.com/signup/h?pid=feedmailpro&source=website), who we are working with to handle this transition.

This page will try to answer any questions you may have about the change, and assist you in the transition process.

![](http://s3.amazonaws.com/oldbloguploads/2010/10/transfer-500x97.png)


### Why is FeedmailPro closing?






First just let me say: I'm sorry.  I realize closing FeedmailPro will inconvenience a large number of people, so I want to be as candid as possible in explaining the sudden closure.

The main reason is that as a sole developer, I no longer have time to work on the site.  It started as a side project to meet my own needs, and has since grown beyond my ability.  With a full time job and another larger startup to run, I was lucky to work even a few hours a month on FeedmailPro.

Although over 800 blogs are now using FeedmailPro, only about 20 of those ever reached the threshold of needing to pay for the service.  Therefore, with a total revenue of around $200 per month I can't justify the amount of time it takes to maintain and run the site.  This may have been a miscalculation on my part in the business model (this whole thing has been a learning experience business wise, and I've certainly made some errors along the way).

Bottom line, I was trying to do too many projects at once, and if I didn't consolidate them a bit I was in danger of doing them all poorly.  Something had to give, and after weighing my options that turned out to be FeedmailPro.






### Can't you leave the site running even if you don't have time to work on it?






I'd like to do this but unfortunately it is somewhat dangerous to leave a large email server operating entirely on it's own.  There are now over half a million emails in the FeedmailPro database which makes it a target for hackers and spammers.  And mail server reputation fluctuates over time.  If for some reason the server were to be blacklisted I'd have a fairly big emergency on my hands (and potentially lawsuits) that would require lots of work to get fixed (especially with so many people depending on it).  I can't afford to have that liability waiting to strike at any moment given my other responsibilities.






### Could you sell or donate FeedmailPro to someone else to keep it running?






I contemplated this as well but ultimately decided against it because the internals of FeedmailPro are complex enough that it would be time consuming to bring someone else up to speed.  It's also not a very forgiving system (a small bug could accidentally email millions of people) so it's not a good candidate to pass on to someone who only understood it at a high level.

In addition, the functionality offered by FeedmailPro is now provided by more established service providers (like MailChimp) so there isn't much reason to duplicate the functionality (granted the low cost of FeedmailPro was an important difference, but some steps have been taken to mitigate this - see the question on cost below).






### Why MailChimp?






I've been tracking their service for a while and simply put, they know what they are doing.  They also have a large team and infrastructure that is capable of handling the sort of volume and potential emergencies that come from running a service like this.  They are a world class Email Service Provider, and they aren't going anywhere.

In fact, with the features they've been adding over the past few years (especially the same 1000 subscribers for free accounts) their service is quite a bit better than FeedmailPro (certainly more full featured), so there is really no reason not to use them.  I suspect their deliverability is also better than FeedmailPro, so this will be a nice bonus when switching over.

I reached out to MailChimp about a month ago when I realized the predicament I was in, and they agreed to assist in the transition of all FeedmailPro customers (even with the large number of free users). They've been great to work with so far which only gives me more confidence in transferring FeedmailPro users to their service.






### What is the schedule for shutting down?













**10/23/2010**


- notice to current FeedmailPro customers of upcoming changes, new accounts no longer accepted on FeedmailPro, service continues for existing customers as usual






**11/1/2010**


- second notice goes out to all customers about upcoming shutdown






**11/23/2010**


- final notice of upcoming shutdown






**12/1/2010**


- no more emails will be sent from FeedmailPro, website will still be accessible to export data






**1/1/2011**


- last day to access website and export data




They key date to remember is **December 1st, 2010**.  You should have your list migrated over to MailChimp by this date to avoid any interruption in service.






### What does MailChimp cost compared to FeedmailPro?






If you're a free user of FeedmailPro then MailChimp will also be free.  They have the same 1,000 subscriber limit on free accounts.

If you're a paying customer of FeedmailPro (as of 10/22/2010), MailChimp has graciously agreed to "grandfather" you in at the same rate you were paying at FeedmailPro.  This means your price won't change.  Be sure to sign up using the link on this page and try to use the same email address (from your FeedmailPro account) when signing up with MailChimp to make this process as easy as possible.  Note that you may need to sign up with MailChimp at the regular price to get started since the special discount may not be applied right away.  You can email FeedmailPro Support if it still hasn't changed after a few weeks.

All paying customers of FeedmailPro will have their Paypal subscriptions canceled as of 10/23/2010 so you won't be charged again by FeedmailPro after that date.






## Ready to start the transition?


Head over to [MailChimp](http://www.mailchimp.com/signup/h?pid=feedmailpro&source=website) to create your account.

You will need to complete this process **before December 1st, 2010** to ensure there is no interruption in delivery to your subscribers.

Note: if you don't already have a MailChimp account you should sign up using the MailChimp link on this page so they know you are a former FeedmailPro customer.

If possible, please use the same email address to create your account at MailChimp that you used at FeedmailPro.


## Detailed [video walkthrough](http://www.youtube.com/watch?v=geqF5B1il9c) of the transition process:




Tip: set to fullscreen and 720p resolution for best viewing experience.
