---
layout: post
title: "Using MongoDB aggregation framework #1"
date: 2013-01-16 21:09
comments: true
categories: [Ruby on Rails, General, Ruby, MongoDB]
---

A little while ago, I started implementing the graph behind [Gogobot](http://gogobot.com).

When you see any page on the site (Logged in), all of what you see is completely personalized to you and is based on what your friends are doing/done before.

Whether your friends are on Gogobot or not, if you connect to Facebook/Foursquare we will calculate the score for all places based on your friends.

Unlike other sites, we will promote what your friends are doing and not what random users are doing, this way, when you see a review written by a face you recognize, the likelihood for fraudulent reviews is slim.

We had this graph since day one, but as we scaled up and started taking more and more things into account while calculating the score, we needed a different solution.

A few months ago, I sat down to plan this solution and the architecture behind it basically from scratch.

I will not get into the details here, posts on this subject are probably coming soon, just wanted to lay out a few examples of how I'm using the new [MongoDB aggregation framework](http://docs.mongodb.org/manual/applications/aggregation/).

The MongoDB aggregation framework is a new way to aggregate data from MongoDB without actually using MapReduce or needing to export the data and using [Amazon ElasticMapReduce](http://aws.amazon.com/elasticmapreduce/).

While we do use those solutions for more complex stuff, for a lot of things, we use the Aggregation framework and it's proven to be a pretty powerful solution.

OK, so here's a nice example of the power of the Aggregation Framework (including benchmarks)

