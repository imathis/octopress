---
date: '2009-03-22 23:20:54'
layout: post
comments: true
slug: progress-on-universitytutorcom
status: publish
title: Progress On UniversityTutor.com
wordpress_id: '857'
categories:
- Business Ideas
- UniversityTutor.com
---

Ok so this week I've been working on the new business model for UniversityTutor.com that I discussed in the second half of [this post](http://brianarmstrong.org/posts/new-features-and-tests-on-my-passive-income-business/). Basically, charging a percent of each transaction instead of a monthly fee for tutors.

I'm hoping this will be better in the long run as most people prefer to avoid monthly recurring fees, and it's more fair to only pay for what you really use (instead of a month going by where you got no real jobs but still had to pay).

How it will work though I'm not really sure - so this is a test.

**Designing The Process**

Part of the challenge in designing something like this is to make it easy and convenient so people will actually use it. It has to help them more than it annoys them. A lot of this comes down to good user interface design and choosing the right words to explain things succinctly and clearly.

Here is the basic process I have in mind:



	
  * Tutor and student meet through website and do some tutoring

	
  * Afterwards, the tutor logs into their account and sends student an invoice

	
  * Student pays with credit card, tutor receive funds via direct deposit or paypal


**Who Should Pay The Service Fee?**



Let's say you are going to do a markup of 10% just as an example. Should the tutor pay this fee or the student?

When trying to figure something out I like to see what other people are already doing that is working, and copy it (trying to reinvent the wheel when you first learning a topic is often a mistake - only innovate once you are an expert).

Sites like eLance.com and guru.com both have the service provider (tutor in my case) pay. If the service provider sets a price of $100, the tutor actually only receives $90.

Sites like odesk.com and crowdspring.com do the opposite and have the buyer (student in my case) pay the fee. If the service provider sets a price of $100, the website charges the client $110 and sends the provider their $100.

The difference is really one of semantics - if the service provider wanted to get $100 in the first example, he could just set his price to $110 - but perception can often make a big difference in how people use a service.

I guess it comes down to who has a bigger incentive to circumvent the system and pay offline (which means I'd get zero fee). For right now I think I'm going to try the second method used by odesk.com and crowdspring.com. Buyers will simply see the tutoring price as $110 and won't be reminded of the breakdown. This information will be available on the website of course (probably in an FAQ) if they really wanted it, but there is no reason to advertise the fact you are taking 10% in every bill they get - I think this would just reinforce a negative in their mind.

Tutors on the other hand will be told that "the client pays the fee, not you" so hopefully this will minimize their incentive to get paid offline.

Some further incentives:



	
  * The only way for the tutor to get positive reviews from students is if the student completes the transaction online.

	
  * The number of hours that the tutor has worked will be publicly displayed on their profile as an indicator of how experienced they are. Only when completing the transaction online will their experience go up.


**Processing Payments**

Probably the toughest part of this so far has been figuring out how to setup direct deposit with my web app. For some reason the online payment processing industry hasn't figured out how to make this easy yet. And in general the industry is overly complicated and full of shady companies.

It's common to setup credit card processing on a website and there are tons of tools for this.

The less common part is also being able to SEND payments into people's bank accounts.

This is known as a "marketplace" app in some circles - think the iPhone app store or ebay where you have buyers and sellers of some service. You need something called a payment gateway which your website can talk to and do everything (bill credit cards, send direct deposits, etc).

The terminology for this whole thing is just nuts and I've had a lot of conversations with people over the last few weeks who sounded very confused. Just as an example, there are about 4 different names just for direct deposit: ACH, EFT (electronic funds transfers), eCheck, and direct deposit itself. These all means slightly different things but are often used interchangeably and most people don't know the difference.

There are also payroll processing companies who provide this service manually - but when I tell them I want my server to be able to connect to theirs (an API) to automate this process of sending out payments each night they don't really get it (you mean like Quickbooks? no, not like Quickbooks).

It's really surprising to me that this is actually this difficult - I'm sure I'm not the first one who has needed something like this?

Anyway, here are a few folks with the capability: [BrainTree](http://www.braintreepaymentsolutions.com/), [Ach-Payments.com](http://www.ach-payments.com/), and [TrustCommerce](http://www.trustcommerce.com/). Can't say for sure who (if any) of these I'd recommend, but I'm talking to all of them now.

Amazon.com also came out with a brilliant payment service designed for marketplace apps that you can read about [here](http://aws.amazon.com/fps/). The one downer? It requires both buyer and seller to have or create an Amazon account. This is a deal breaker for me since it won't fully integrate with my website and will confuse people. I really hope they find a way to change this in the future though.

If all else fails I may get up and running with just Paypal. They have a decent API to send people money, but I would prefer to offer direct deposit as well if possible since it will be cheaper and more professional.

**Designing The User Interface**

So while waiting to hear back from these payment processors (they have a long application process and underwriting - believe it or not) I started sketching out and implementing the screens where tutors will get paid and students will make payments.

The best way to do it? Take out a pen and blank sheet of paper. To me this is still the best form of website design because it frees you up creatively. If you start trying to design it in photoshop, or heaven forbid, just starting to code it up - the technology gets in your way and really limits your creativity.

If you are having someone else do your web development - just send them the drawings.

For any larger block of text though (say a few sentences or paragraphs explaining how something works) I prefer to type in a text editor instead of writing it by hand. It's important to get the wording right on these sort of things and that means lots of scratching out, moving words around, etc. It becomes a jumbled mess by hand.

Here are a few of my drawings for the new screens so you can get an idea:

![screen1.jpg](http://s3.amazonaws.com/oldbloguploads/2009/03/screen11.jpg)

![screen2.jpg](http://s3.amazonaws.com/oldbloguploads/2009/03/screen21.jpg)

![screen3.jpg](http://s3.amazonaws.com/oldbloguploads/2009/03/screen31.jpg)

I'll keep you updated on progress - especially how it changes the revenue once I launch it! Right now I have about 50 subscribers so the site is making about $500/month in profit. With current traffic I'm hoping this percentage based model will push it over $2,000/month almost immediately. Of course it should grow pretty much on it's own from there with little additional work. We'll see how it goes!
