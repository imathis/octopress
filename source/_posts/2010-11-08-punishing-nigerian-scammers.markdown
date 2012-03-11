---
date: '2010-11-08 02:52:07'
layout: post
comments: true
slug: punishing-nigerian-scammers
status: publish
title: Punishing Nigerian Scammers
wordpress_id: '1668'
categories:
- Advice
- Business Ideas
- Technology
- UniversityTutor.com
---

I started getting complaints recently from some tutors on [UniversityTutor.com](http://www.UniversityTutor.com) that they were receiving scam emails.

I looked into it and the scam is the same one you commonly see on Craigslist and numerous other sites.  It usually goes like this:



	
  * Someone contacts you pretending to be interested in your services (tutoring in this case)

	
  * They offer to pre-pay a large amount up front and send you a money order

	
  * Next, they say they've changed their mind and would like a refund (minus some small fee for your trouble)

	
  * You refund them with real money before realizing the money order is fake


These scams all have some common themes which make them fairly easy to spot, but they can still catch you unaware if you haven't seen it before.  There are some red flags.  For example, the "buyer"...

	
  * Usually resides in a foreign country

	
  * Doesn't write/speak English very well

	
  * Wants to be refunded via Western Union

	
  * Is reluctant or unwilling to meet in person or talk on the phone


Western Union seems to be used in most of these scams because the person can pick up the money in any country with just a confirmation code.  And since they're in a foreign country **you have ZERO legal recourse to go after them**.  The U.S. isn't going to be extraditing anybody for for less than probably $100,000 and most of these scams are for $1,000 or less.

I would be curious to know what percent of Western Union's business is from people caught up in these scams (and people laundering money).  It wouldn't surprise me at all if it's 25% or 50%.  Their fee seems to be high enough that you're unlikely to use it unless anonymity was essential to you.  If that is true, then Western Union is a prime target for a class action lawsuit - and I hope somebody does take them down.  They're enabling a worldwide network of criminals, and profiting from it, which makes them very uncool in my book.

[![](http://s3.amazonaws.com/oldbloguploads/2010/11/Screen-shot-2010-11-07-at-5.19.39-PM-500x305.png)](http://s3.amazonaws.com/oldbloguploads/2010/11/Screen-shot-2010-11-07-at-5.19.39-PM.png)

Anyway, I checked out my Google Analytics stats and 1,759 people from Nigeria visited the site last month, which is a little strange given that I have no tutors listed there.

There could be scammers residing elsewhere too, but this jumped out at me as new and probably one source of the problem.


## How To Get Scammers Off Your Site


So here are some steps I've taken (or looked into) for blocking these guys - and how scammers can get around them.  You're never going to make it completely impossible for them - the goal is just to make it difficult enough so they'll spend their time elsewhere.  They are listed roughly in order of difficulty to implement.


## 1. Captchas


[![](http://s3.amazonaws.com/oldbloguploads/2010/11/captchas.jpg)](http://s3.amazonaws.com/oldbloguploads/2010/11/captchas.jpg)

These are everywhere online now and a great first start.  They don't prevent humans from messing with your site, but they do block computers (bots or automated scripts that people write).  And this is important because bots can spam hundreds of thousands of users in a few hours on your site before you catch it, whereas a human can only spam a few dozen people in an hour.  Captchas are your first line of defense.

**How they can beat it**: hire dumb people to fill out captchas all day.  I think the going rate for this is maybe $0.05 to fill out a captcha, which isn't much - but at least it's costing them _something_ now and they can't just automate the whole thing.  This one step alone will reduce probably 90% of the spam on your site.


## 2. Rate Limiting


The next step is to setup some checks to limit the number of messages any given user can send in a day.  Right now if a client tries to contact more than 15 tutors in a day, they'll get a message saying they are sending too many messages and need to slow down.

**How they can beat it:** they can create new accounts.  If a new email address is needed for this (which it should be), then this takes them another few minutes to setup a new email address at Gmail or Hotmail (who use their own captchas).  Not a huge deal, but remember - the goal is just to waste enough of their time so they eventually give up and go somewhere else.


## 3. Tell All Your Users What To Watch Out For


Low tech, but effective.  Every time a student contacts a tutor through the site, I've included a note in the email warning them about these scams and linking them to [this information page](http://www.universitytutor.com/about/scams) if they want to read more.

If you use Craigslist, you've probably seen similar warnings all over their site.  An educated user base is a great defense.  The only downside is that it uglies up your website and your users still have to read the stupid emails, so it wastes their time even if they don't actually fall for the scam.

**How they can beat it:** they can't really prevent you from educating your user base - it just means they now have to contact 10x as many people to find one who will fall for it.


## 4. Geocode Their IP Addresses


You can map an IP address to a country, and block entire countries from using your site.  This worked well in my case because I could block Nigeria (I have no real tutors listed there so no loss).  However, this doesn't work as well if your scammers are mixed in the same countries with your real users.  IP address geocoding isn't exact, so you could accidentally block your real users along with the scammers.  It's important to remember that an IP address does not correspond to one person or one computer (in fact thousands of people can share the same IP address behind a university or corporate firewall) so it's not an all encompassing solution.

**How they can beat it: **if they find out you're doing it, they can proxy their IP address through another country or spoof it (which again, takes a little more time and possibly money).


> This brings me to an important point: if you are going to block them, **don't TELL them you are blocking them**.  Try to make it totally transparent to the user.  For example, if they come to your site and see a warning message saying "UniversityTutor is not available in your country" or "you are sending messages too fast", then they know they've been caught and will start trying the above mentioned solutions.  Once they see the error message go away, they know their solution has worked and they'll continue spamming.  Don't give them any information to test solutions!

So if I detect the user is spamming, I still show the exact same success message back to them (your message has been sent!).  I just don't actually send the message in the background.  This way they happily go on their way, wasting their time filling out forms on my site all day long (which do nothing).

For some reason I really like this idea that spammers are like mice on a treadmill, working away on my site all day without realizing they are going nowhere.  I even thought about starting a dashboard showing how many spammers I've tricked into filling out completely useless forms on my site, but I haven't yet.




## 5. Hidden Cookies


In addition to the rate limiting mentioned above, you can also set another random cookie which survives the user's session on your site.  This way if they logout and log back in with a new account they've created (creating lots of new accounts to get around your rate limiting) you can still track how many messages they are sending overall and not send more messages.  As mentioned above, don't tell them when their message isn't sent.

**How they can beat it:** they can simply clear their browser cookies.  The key here is that if they don't know something is wrong, they may not think to do it.  Even if they do, it adds one more step to they process.


## 6. [Evercookie](http://samy.pl/evercookie/)


This is a neat little hack that a programmer put together.  It uses about 7 different methods to store cookie data all over the user's browser and computer.  Some of them are very clever and hard to detect.  If one or more of the storage mechanisms gets deleted, Evercookie recreates all of them the next time it runs.  The result is a persistent browser cookie that is VERY difficult to get rid of (you can't just clear your cookies).  As with many tools, this one could potentially be abused - but here is a case where it ends up working for good (blocking scammers).

**How they can beat it:** they'd have to spend quite a bit of time figuring out how to prevent it.  I've heard some reports that Google Chrome's incognito mode is safe from it, but I've never tested it.  I suppose they could just boot up a new virtualized operating system every time, but in general, this is probably beyond what most scammers would be willing to do.


## 7. [Panopticlick](http://panopticlick.eff.org/)


Panopticlick attempts to identify an individual user of a website based on a hash of all their public user data.  Surprisingly, it claims to work about 85% of the time.  This could accidentally block a few of your legitimate users (false positives) in the worst case, but it could be worth it depending on how bad your spam problem is.

**How they can beat it: **they'd have to adjust something in their browser settings before each message to keep trying to get a unique identifier.  They could run out of settings after a while.  If anyone knows of this being used in production anywhere, please let me know in the comments.


## 8. Bayesian Filters


Currently the nuclear weapon in the fight against spam (the most technically sophisticated, but also the most powerful) - this applies equally well to blocking scam messages.  This is what Gmail uses for their spam filter, and it works quite well.

You'll need a decent sample size of data (scam messages and real messages separated) and it will improve/learn over time.  You don't even need to write the whole thing from scratch.  There are some nice [open source libraries](https://github.com/search?q=bayesian&type=Everything&repo=&langOverride=&start_value=1) that you can drop right in, depending on what language you are using.

**How they can beat it: **they'd have to start changing the messages they send to not get caught in the filter.  This might include learning to speak English correctly, not using the word "money order" etc - which are non-trivial.  The algorithm would learn over time so they'd have to continually change it up.  Their weak point is their message: they are always going to have to say something slightly different than legitimate users.


## Conclusion


The war against scammers is an ongoing game of cat and mouse that is never going to be completely over.  They might be annoying, but luckily they are just that - annoying - and rarely actually trick people out of money now days.  As people become more internet savvy (and start to recognize the words "Western Union" as a red flag), scammers will become less and less important.

Did I miss any other techniques?  Please let me know in the comments!

Brian Armstrong
