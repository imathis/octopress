---
layout: post
title: "Data is King"
date: 2012-01-16 08:46
comments: true
categories: data business software
---

Businesses have long appreciated the applications of data to the process of decision making. Marketing departments know which campaign will be more effective, and the accountants have their fingers on the financial pulse of the company. Your friends in HR know whether everyone is being fairly compensated, and those suits in the boardroom know what to make of it all.

Data is just as important to software, both in companies and projects. It tells you how many registered users you have, and how many of those have frequented your website recently. It shows you how many unique visitors you had on a given day and warns you when your conversion rates begin to fall, and can even show you which pieces of inventory have been sitting on your shelves for a little too long.

Some more interesting applications of data in software are around feature breakdowns across your userbase, which show you which components of your system are the most or least popular. You likely even have data to support the decision on when to automate certain processes and when you need to scale your application or database servers.

So why aren't software teams and software businesses more addicted to the data they have at their fingertips?

When I talk about being addicted to data, I don't mean manually digging through your databases, nor do I mean trawling through a periodic report that you're sent.

The only form of useful data I can think of is the kind that is "radiated" rather than "refridgerated". All it takes is a large PC monitor or a small TV, a spare PC that no one uses and a little bit of determination. Position it in a common area, point the browser at one of the many excellent web-based dashboard tools, such as Geckoboard, and then sit back and bask in your data. For those that don't want to expose their data externally, why not plug your data into your internal monitoring tool. You are running Nagios or Munin, right?

Before you think that you don't have any interesting data to throw up on that screen, I beg to differ. Software doesn't exist in a vacuum, and every software project I have worked on has been backed by at least one datastore. It can be as simple as a flat text file or a rolling log file on your production server, or could be more along the lines of a distributed, replicated NoSQL datastore like MongoDB or Redis.

Even short of data extracted from your application, there are usually a few peripheral choices, such as your Google Analytics stats, your Pingdom uptime numbers or your New Relic graphs. To abuse an old expression, the sky is the limit!

The only barrier between you and your data is the lack of a bridge. I've already pointed out that you have interesting data available, and that there are online tools which will lovingly display your data, so why not expose a small API which links to a few interesting queries against your datastore? And when it comes to peripheral data such as Google Analytics and New Relic, a lot of the online dashboard tools have already built the bridge for you.

It seems as though many companies overlook the power that can be harnessed from simply making the data within their software more readily available. If the trend seen in startups and Silicon Valley companies is anything to go by, leveraging data is yet another competitive advantage up their sleeves.

Instagram is a great example of this trend. They have been in business for a little over a year, employ merely 3 engineers and yet have scaled their system to support over 14 million users and over 300 million photos with what can only be described as an impressively complex architecture.

{% blockquote Instagram Engineers http://instagram-engineering.tumblr.com/post/13649370142/what-powers-instagram-hundreds-of-instances-dozens-of What Powers Instagram: Hundreds of Instances, Dozens of Technologies %}

With 100+ instances, it’s important to keep on top of what’s going on across the board. We use Munin to graph metrics across all of our system, and also alert us if anything is outside of its normal range. We write a lot of custom Munin plugins, building on top of Python-Munin, to graph metrics that aren’t system-level (for example, signups per minute, photos posted per second, etc).

{% endblockquote %}

The other great example of a software company leveraging data for decision making is Facebook. Whilst exact details are scarce, Facebook's system architecture would be one of the largest in the world, and hence one of the most difficult to deploy to. This hasn't stopped the brilliant engineers at Facebook from designing their deployment process to watch various metrics related to incoming revenue during, which will alert them when a feature goes live and negatively impacts their bottom line.

I encourage you to think about how this could benefit your team or company, and to talk it over with your colleagues.
