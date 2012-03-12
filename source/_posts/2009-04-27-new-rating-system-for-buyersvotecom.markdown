---
date: '2009-04-27 03:18:54'
layout: post
comments: true
slug: new-rating-system-for-buyersvotecom
status: publish
title: New Rating System For BuyersVote.com
wordpress_id: '897'
categories:
- Business Ideas
- Updates
---

Well last week I launched [BuyersVote.com](http://brianarmstrong.org/posts/big-announcement-buyersvotecom/) and the response was good. Lots of people sent me their feedback and I was able to watch people use it (a very valuable experience).

I also put it through the "parent test" where I watched people who weren't SUPER tech savvy (my parents :) use it.

By far the biggest piece of feedback I got was the rating system didn't make sense.

Here is the old rating system:

![rating_before2.gif](http://s3.amazonaws.com/oldbloguploads/2009/04/rating-before21.gif)

Every user got 1 vote per page - either yes or no (up or down arrow). Then the idea was to display the AVERAGE of everyone's votes at the top (the "10 out of 10") as a summary.

The problem was that the arrows seemed like they would add or subtract one to the number and people assumed they could click it multiple times. In reality, however another click would remove your previous review because you only got one (it was more like a button that toggled on or off but the design didn't suggest this).

Obviously it was not making sense.

I went through a lot of ideas for a better design, and this [UI Patterns gallery](http://ui-patterns.com/collection/rate-content) of a bunch of different rating system was helpful.

I contemplated...



	
  * changing it to a percent so 6 out of 10 would become "60% of people liked this"

	
  * Doing a 5 star rating system

	
  * A variety of others things


A couple factors I was considering as well:

	
  * The more options you give someone, the less likely they are to act - so it would be ideal to keep the number of possible ratings fairly small (Digg is the master of this with just one option - up!)

	
  * There is also the problem of "false accuracy" where a lot of review systems say "this one has a rating of 62% and this one has 63%" but there are only a dozen or so votes, and the statistical significance is not there to make a claim of "better" down to percent. Google does a good job of this with their PageRank which simply gives a number between 1 and 10. Basically they are implying - this is an estimate, and it's not more accurate than about 10 different levels of distinction.


After messing around for a bit, here is the new rating system I setup:

[![rating_before.gif](http://s3.amazonaws.com/oldbloguploads/2009/04/rating-before1.gif)](http://buyersvote.com/pages/blackberry-pearl-8100-reviews)



You can mouse over the different levels and it updates the text below it with words like "Perfect", "Good", or "Abysmal". The effect is pretty neat and you can [see it in action here](http://buyersvote.com/pages/blackberry-pearl-8100-reviews).

After you click it your rating stays in place.

The biggest benefit is that the metaphors match now between your rating and the overall score: both are on a 1 to 10 scale.

The only drawback to it that I can see is that it's a bit more complicated (there are probably too many choices, I'd have preferred to go with a maybe 5 choices, but I didn't make the neat little CSS that does it all, I got it for free from [here](http://www.robarov.be/rate/) and didn't have time to change it).

What do you think?

I'm sort of undecided still. A 5 star rating system might be better since it is so common and people understand it instantly, but for some reason I'm hesitant on it and this one looked cool.

**Other BuyersVote.com Q&A**

Here are a few other items I said I'd follow up on about BuyersVote.com:



	
  * **How was it developed so quickly?**
It was pretty neat to build the whole thing in one week. Ruby on rails made this possible because there are so many good plugins for it now. For example I'm using built in plugins to handle the following functionality: user authentication/password resets, OpenID authentication, tags/categories, ratings, searching, auto completion in text fields, seo optimized urls, versioning and the "diff" view which shows changes in revisions, and captchas.

	
  * **How did you get the web hosting for free?**
I'm using [Heroku](http://heroku.com/) which offers a free rails hosting platform for small simple apps. Once it gets bigger or has more traffic I will hopefully be able to monetize it a bit and then move it to SliceHost.com for hosting.

	
  * **Who did the design?**
I am not a very good designer by trade, so I like to borrow other designs. The design I'm using actually comes from a free wordpress theme that is in the public domain. It was released by [Design Disease](http://designdisease.com/portfolio/blogging-pro-theme/) to showcase their talent. Personally, I think that most people spend too much time on the design when launching a small test project like this. The design (as long as it is not terrible) is really not that important in the beginning (sorry designers reading this!). It's more the idea and functionality you want to test. I just googled "free wordpress themes" and looked at a bunch until I found one I liked. Then I adapted it to what I needed. Since it's released under the GPL this is perfectly legal.

	
  * **How did you setup the login thing where people can sign-in with their Google, Yahoo, Aol, Facebook, etc account?**
The technology underneath it is called OpenID but only super geeks know about this or have an OpenID login. So what I used was the widget from [RPXNow.com](https://rpxnow.com/) which makes the signin process much easier for people to understand. Making the account creation process SUPER easy (2 clicks and no typing) or in some cases not even necessary (like to create a new page) was really important to me because I wanted to LOWER ANY BARRIERS to people participating in the site. There are lots of review/forum sites where I come across it one day and want to leave a quick comment but because of the signin process (a half dozen fields to fill out, then verify the email, then worry about getting spam, etc...) makes it just not worth it. This, in my opinion, is a big part of why epinions.com isn't more successful - they tried to lock it down instead of trusting people and opening it up (like a wiki). I would have even preferred to making the login optional for voting, but after much research couldn't find any way to do this and still prevent duplicate voting. So for now voting requires a login, but you can create an account with literally [two clicks](http://buyersvote.com/user_session/new) in most cases.


That's about it for now...let me know what you think about the new rating feature and feel free to [login](http://buyersvote.com/user_session/new) and [try it out](http://buyersvote.com/pages/blackberry-pearl-8100-reviews)!

Brian Armstrong
