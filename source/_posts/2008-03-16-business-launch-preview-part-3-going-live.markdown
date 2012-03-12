---
date: '2008-03-16 15:48:19'
layout: post
comments: true
slug: business-launch-preview-part-3-going-live
status: publish
title: 'Business Launch Preview Part 3: Going Live!'
wordpress_id: '254'
categories:
- Business Ideas
- How To
- UniversityTutor.com
---

Hey Folks,

Well the website has launched and you can go check it out here [UniversityTutor.com](http://www.universitytutor.com/)

I'm going to show you a few more cool features that went into it, the results of some user testing, and what the next steps are to get my first sale.

**Making a UI to Input "Availability"**
One of the things I knew from running an existing tutoring business is how hard it was to match people's availability.  If I was going to automate the matching process I had to spend some serious time thinking about it.

There is both availability in terms of time and location.  Plus the added challenge of being compensated for driving time, which some tutors want.

The simplest solution is just to make a generic text field where people can write in anything they want for their availability.  This is not the best answer, because you will get an inconsistent look to the site and your customers are then forced to understand and compare all sorts of different things that sort of mean the same thing.  Its also unclear from this how detailed people should get.

Here is an example of generic inputs you can get from a text field which all mean pretty much the same thing:

"I am available Monday Wednesday and Friday after 3PM and Tuesday and Thursday After 5PM"
"WEEKDAYS AFTER 4"
"Mon/Wed/Fri afternoons Tues/Thurs after 5"
"MWF after three o'clock I am availabe and T/TH in the evening"

This just deals with time, not driving or compensation, plus you get the problem of spelling errors, etc.  It makes the site less usable.

Another option is to put in a full blown calendar system sort of like Outlook or Google Calendar which allows people to mark blocks of time.  This is a lot of code and testing, and more importantly its probably overkill for such simple scheduling needs.

In the end I found something that worked for me, and it wasn't overly complicated.

**Time**
For scheduling I made two drop down menus.  The first drop down shows days, and the second shows time.  The choices force the results to be consistent and gives them some flexibility in how detailed they want to get.  It also doesn't let them get TOO detailed.  This is good and intentional.
![Availability Time Scheduling](http://s3.amazonaws.com/oldbloguploads/2008/03/time-availability1.gif)


**Location**
Again two drop downs.  One for distance, one for extra charge.  Notice I put the travel times in minutes, not miles.  This has to work in various cities and the travel time in New York for 1 mile is not the same as the travel time for 1 mile in Houston.  It also gives the user the flexibility to charge a flat fee for driving or at an hourly rate, while (again) keeping it simple enough by limiting their options.
![Locations Availability](http://s3.amazonaws.com/oldbloguploads/2008/03/locations-availability1.gif)

The end result is a Google maps type page that looks like this:
[![Google Maps Locations](http://s3.amazonaws.com/oldbloguploads/2008/03/google-maps-locations2.png)](http://s3.amazonaws.com/oldbloguploads/2008/03/google-maps-locations2.png)

Not perfect, but good enough for now and people seem to be getting it.

**User Testing**

Before launching, I sent the website link to some people and asked for feedback.  I asked them to put themselves in the mindset of my ideal customer (told them what that was) and told them to be brutally honest (otherwise people don't want to hurt your feelings and will just say it looks good).  I also gave them the following questions:


> 1. When were you unsure what to click on next?
2. What did you see that didn't apply to you and was unimportant?
3. What questions did you have that weren't answered?
4. What reservations would you have about signing up or what did you see that made you hesitate?
5. What spelling/grammar mistakes did you see?


I also sat down with some people and just watched them use the website, while keeping my mouth shut (this is important, you can't help them at all!).  You'll be amazed what you find when you do this.  Some things you thought would be obvious turn out not to be.

By the way, this is why Google's web apps are so easy to use.  They do extensive user testing.

I won't get into the details too much, but just an example.  Remember the super cool feature I talked about at the end of the [first preview](http://brianarmstrong.org/posts/from-new-idea-to-business-launch-in-two-weeks-with-pictures/), "auto completion"?  Maybe it wasn't so cool.

Turns out that it was confusing to people.  They didn't understand to type a subject there like "algebra or chemistry" and people tried putting all sorts of things like city names only to get zero results.  Not ideal.  So one change I made there was to use a drop down of subjects.  Again, limiting the number of choices.  Seems to be a pattern there.

[![Using A Drop Down To Limit Choices](http://s3.amazonaws.com/oldbloguploads/2008/03/subject-choices1-150x150.png)](http://s3.amazonaws.com/oldbloguploads/2008/03/subject-choices1.png)

There were a bunch of other changes made too as a result of user testing that I don't have time to get into (pricing structure, clarifying how it works to first time visitors, etc).  Suffice to say that user testing is awesome and important and I'll be doing a lot more of it.  There are some cool tools out there to watch what users on your website are doing in real time which I'll be using in the future, and may write more about.

**Getting The First Sale, and Next Steps**

Once I have about 25 tutors signed up at a given school, I'll be ready to start sending some traffic to the site and seeing how people react.  The best way to do this that I know of is Google Adwords.  It is probably the single most important advertising tool developed in the last 100 years, because it allows you to get targeted prospects looking at your product in about 10 minutes.

Compare this to a magazine or TV ad for example which takes months to develop and get published and is very "un-targeted".  What percent of people reading Parenting Magazine need a tutor at that particular moment?  Maybe 10% if you're lucky.  But what percent of people who type "chemistry tutor" into a search engine need a tutor right now?  Close to 100%.

Anyway, I will probably start with just a few highly targeted keywords, like "chemistry tutor" or "algebra tutor" and get all the tracking code in place to see if those convert.  Then I'll slowly ad more keywords in more geographic areas as I expand.

Just as a rough calculation, suppose that the average sale on the website goes for $15 (there are several different pricing points, but say this is the average value per customer), and each click that I drive to the website costs $0.50.  That would mean for every 30 people who visit the website, one of them would have to buy to break even.  30 clicks times 50 cents = $15, the price of one sale.

1 out of 30 turns out to be about a 3% conversion rate.  Is this doable?  Yes I think so, although it may not be easy.

Some other factors to consider:



	
  * Google rewards good ads by charging you less per click.  So if I can get my click through rate up there, I could end up paying less than $0.50 per click.  I've been studying [Perry Marshall's stuff](http://www.perrymarshall.com/google/) for a while now to learn all sorts of things on writing good adwords ads.

	
  * Is the real value of a visitor $15?  Hard to say.  They could end up having a larger life time value if they become a repeat customer, tell some friends, etc.  Many companies are ok with breaking even on the first sale in terms of marketing dollars, for the long term benefit.

	
  * What percent of people who use the free trial will end up buying down the road?  Again, remains to be seen and could drastically alter the 3% conversion figure..


**Conclusion**
Anyway, I hope that gives you a good idea of how to think about launching a business quickly.  Its been almost exactly one month since I first started this project (originally I thought it would be closer to two weeks, but still one month isn't bad to launch an entire business!).  I hope to have my first sale on the site in the next month.

This is the speed and low cost that is possible when you know how to have an idea, and go for it.  Whether it works or not remains to be seen, but I'm excited to say the least, and will keep you updated here.

If you haven't checked out the site yet, please do so now: [UniversityTutor.com](http://www.universitytutor.com/)

And as additional user testing, please tell me what you think about it in the comments below if you have any suggestions for improvement or if anything on the site is confusing.

If you need a tutor and live in one of those markets around Austin, Cambridge, or Manhattan, please sign up for a free account and try contacting some tutors.

Thanks!
Brian Armstrong
