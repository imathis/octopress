---
date: '2009-07-27 21:13:54'
layout: post
comments: true
slug: my-next-project
status: publish
title: My Next Project, And Why Aweber Sucks
wordpress_id: '1043'
categories:
- Business Ideas
- FeedmailPro.com
---

WARNING: this post gets a little geeky talking about a tool for bloggers.  Some of you might not have an interest in it but I thought I'd post it regardless.

About a week ago I was sitting around with nothing super urgent to do.

[UniversityTutor.com](http://www.universitytutor.com/) has been running on auto-pilot almost 100% with new tutors signing up every day.  I only need to answer about 1 or 2 emails per week on it, especially as the [FAQ](http://www.universitytutor.com/faq) page has grown and becomes more complete.  Sure there are a few little things on my list to add for it (for example, about 1 in every 500 tutors who signs up managed to enter an address which doesn't come up in Google maps correctly, and it breaks some stuff.)  But I couldn't get excited about fixing it.  It just didn't affect enough people.

Similarly, [BuyersVote.com](http://buyersvote.com/) is in a holding pattern as I wait for Google to index some stuff.  I've been using it quite a bit myself and finding it much easier/faster now to fit into my workflow if I want to add something quickly.  There are actually a bunch of things I'd like to eventually add there too (a demo video for the home page, make the vote-up and vote-down buttons more responsive, maybe a press release to get some PR for it).  People are actually able to [vote](http://buyersvote.uservoice.com) on what features they'd like to see next, so I can prioritize them.  But nothing really struck me that day.

So I turned my attention to something that had been bothering me for a while: Aweber.  Aweber is an email newsletter service that lots of bloggers use to offer email subscriptions.  Aweber had been annoying me for a bit.  I use it on [HomeworkHelpBlog.com](http://homeworkhelpblog.com/) (the blog for UniversityTutor) and every month it had been costing me more and more.  It was about to reach the point where I was paying $70/month for it, and this was just ridiculous.  That was more than my web hosting, credit card processing, etc combined.  For a simple email newsletter!

![homeworkhelpblog](http://s3.amazonaws.com/oldbloguploads/2009/07/homeworkhelpblog1.png)

Worse still, the user interface to manage your Aweber is horrible and I could never get it to do what I wanted.  The whole site was clearly designed by some very technical people who had no concept of how people would actually use it (and then threw a pretty coat of paint over it).  For example, let's say you were designing an HTML email and you saved some changes on Aweber.  You might want to see how those changes looked before it got sent out to your entire list of thousands of people right?  Well Aweber didn't let you do this (for a blog broadcast).  You have to wait until your next blog post and just hope it looked right.  Or what if you wanted to send out your entire blog posts to people by email (and not just summaries which would piss them off by making them click through to your site).  Well, Aweber didn't offer this and provided an embarrassing hack in their "help" pages which would require you to do extra work on every single future blog post you made.

There were other little things.  Aweber pulls the feed in a way that Adsense for feeds doesn't show up.  They charge you for subscribers who have UNSUBSCRIBED from your feed.

Aweber also prides itself on how there are "real human" beings there to answer customer support calls and brags about this on its site.  This bugged me too - you do realize I don't actually want to EVER call your tech support.  Do you think I enjoy waiting on hold, answering phone prompts, and speaking with people who have no authority to actually fix the problem?  Here is a tip for web businesses: If I ever have to actually pick up a phone to call you for tech support, you've already failed.  If I'm calling it's because you messed up, and your site is broken.  Instead of paying for a huge phone center of support reps - why not just FIX your website.  Look at Gmail, millions of users and not a phone number in sight.

Anyway, so how were they getting away with charging this much for a crappy service?  The answer I think lies in their tiered business model, and the fact that it's very difficult to move your email list.  You can start out with them at a very low price.  And once they have you locked in it keeps going up.  The kicker is that if you ever want to try a different service they make it very difficult for you because all the newsletter companies out there require you to send another "opt-in" email to all your subscribers if you move.  This annoying and confusing email basically ensures you will lose about half your subscribers if you ever move.  So they've got you, and they know it.

A while back I wrote an [article for ProBlogger](http://www.problogger.net/archives/2007/07/03/rss-to-email-comparison-review-feedburner-feedblitz-zookoda-aweber/) on this exact topic, and complained about the lack of options out there for bloggers.

So I was sitting there thinking about how I could probably code up my own newsletter service really quickly, and save myself $70/month.  And if I wrote it myself, I wouldn't have to mess with this silly "extra opt-in" business.  Then I started thinking that if I wanted this for myself, maybe other people would want it too.  But then...wouldn't it be a big hassle to open it up to the public, if people started trying to game the system etc and use it for spam or something like that.

So I let it marinate in my brain for a few days until I eventually came up with (what I think is) a great solution to this problem.

Let's say some new user signs up and wants to import their list of 10,000 subscribers from Aweber.  Why not trust them (by default) and test out the list in a programmatic way which doesn't require a manual, human review process (which would never be 100% effective by the way - people can fake credentials if they want).  Why not send the next email to say...10 of those subscribers on the list, and see how many (if any) come back as bounces, complaints, unsubscribes, etc.  If all is well, send the next email to 100, and the next to 1000, and eventually you could be quite confident that the list is valid and start sending to the whole thing.  If flags went up after you first few tests (in the form of lots of unsubscribes, complaints, or bounce) then the person is probably a spammer and you just close their account.  If would be worth it for them to send out 10 or even 100 emails, when they deal in millions of emails.  The whole process would take less than a week or two (however fast they sent out 4 blog posts) and the cool part is that none of the subscribers would actually have to "miss" an email.  The ones who got later emails would just have more posts in those emails until the "import" process was done.

If that worked...then the rest wouldn't be too hard.  Make a user interface that actually, worked.  Let people test their emails, import their list from whatever crappy provider their using now.  Get rid f tired pricing and make the service a flat $10/month with the first 1000 subscribers free (the real cost to run this is almost nothing if you don't have huge phone support centers and a broken site).  It would be a freemium business model that would save people a ton of money over Aweber.

Then if I built it, I'm pretty sure I could get Darren to let me do another post on ProBlogger (which has over 100,000 readers - all bloggers, many of whom use Aweber).  This would be an easy to launch the product to a ton of people.  I could also set up a nice affiliate program so every blogger who tried it would probably blog about it to others...and wow, this could turn into a nice little business.  Maybe a week or two of work to build it.

So anyway, that's what I've been working on the last week or so.  I should have a prototype out for you to look at later this week (you'll hear about it first here if you want to be a beta tester).  Some of the technical issues involved with running a mail server and the Can Spam Act are quite technical, but I don't think it's anything I can't handle.  I'm already running my own mail server for UniversityTutor and it hasn't been too bad.

I could probably do an entire other post on the technical aspects I've gotten into actually.  One cool part is that I'm modularizing the server which actually is going to do the mass mailing.  The reason why this is cool is that if a problem ever does happen and the mail server does get black listed due to a bug in the code or malicious users, etc, I can literally just spawn a new server with a new IP in 5 minutes and have a clean server.  I can also clone/spawn new mail servers on the fly to keep up with demand if this thing gets huge overnight.  In this sense they are like worker processes, totally separate from the main server with the database and serving up the homepage, etc.  Workers can get killed off without the whole machine coming down.

Suffice to say I think it's gonna be awesome.  I'll send you link to try it out later this week!

Hopefully it will be a nice addition to my "portfolio" of sites out there, running on auto-pilot.

Until next time, keep breaking free!
Brian Armstrong
