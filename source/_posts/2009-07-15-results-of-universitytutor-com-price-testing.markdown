---
date: '2009-07-15 03:29:41'
layout: post
comments: true
slug: results-of-universitytutor-com-price-testing
status: publish
title: Results Of UniversityTutor.com Price Testing
wordpress_id: '1003'
---

About a month ago I wrote about how I was going to split test the prices on [UniversityTutor.com](http://www.universitytutor.com).

I thought I'd share some results with you.  As you recall, I was split testing two price points.

The way it works is that tutors sign up on the site and get three free job requests.  After that they get an email asking them to upgrade and become a paying member.  I've recorded the number of emails sent out, and the number that actually subscribed.

**Test Group 1:** $9.95/month or $79.95/year

**Test Group 2: **$5/month or $45/year

Just a quick reminder: both price points had a monthly and yearly option.  I was NOT testing the monthly price vs. the yearly price.  I was testing a lower price (both monthly and yearly) vs. a higher price (both monthly and yearly).

Here are the results:

![Picture 2](http://s3.amazonaws.com/oldbloguploads/2009/07/Picture-2.png)

There isn't quite enough data yet to be super precise, but we can paint some broad strokes...



	
  * The conversion rate was about double for the lower price.  That means I could make the service affordable to twice as many people with no loss in revenue (one option).

	
  * Very few people chose the yearly option.  After thinking about this a bit I realized that most tutors are college students and will be moving during the summer.  They probably don't plan on tutoring year round necessarily.  I've since added a line to the email saying "you can move or change cities and keep the same tutor account active".  This may help, we'll see.

	
  * Revenue was higher in Group 2 because one person chose the yearly option.  Without this, revenue would have been $60, and revenue per email $0.42 - just barely lower.  The only reason you might want to look at it like this is that with so few people choosing the yearly option, we don't have statistically significant data there.


The 4% or 8% conversion rate might sound low, but from what I've seen of other major sites this is actually quite good.

Also, just a quick note on HOW I actually did this test.  I unfortunately had to program it by hand.  Basically I setup a piece of code which recorded whenever an interesting "event" took place, such as an email going out or someone subscribing and saved it to the database.  I wish there was an easier way to run tests like this.  The closest thing I've seen is Google Website Optimizer, but I've found it very difficult to use when running tests like this, and that's why I coded it by hand.  Not an ideal solution for everyone I know, but I thought I should mention it.

**Next steps?**

I haven't completely decided yet, but the option I'm leaning to here is to go with the lower price.  It seems worth it to get more tutors signed up at the lower price (who can evangelize the product and tell others about it - not to mention having more tutors available in searches on the site).

What do you think?  Also, if you have any other suggested split tests you'd like to see, let me know in the comments and I can try running them.
