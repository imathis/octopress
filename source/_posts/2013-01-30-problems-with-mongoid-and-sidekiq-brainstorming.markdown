---
layout: post
title: "Problems with Mongoid and Sidekiq- Brainstorming"
date: 2013-01-30 20:13
comments: true
categories: ["Ruby", "Ruby on rails", "MongoDB"]
---

A few weeks back, we started slowly upgrading all of our queues at [Gogobot](http://www.gogobot.com) to work with [Sidekiq](https://github.com/mperham/sidekiq).

Posts on how awesome the experience was and how much better Sidekiq is from [Resque](http://github.com/defunkt/sidekiq) coming soon, though with all the good came some bad.

Summary of the solution
-----------------------

With Sidekiq, we are processing around **25X more** jobs than what we were doing with Resque, processing around 15,000,000 jobs per day, at paces of over 1K per second at times (at peak we go up well past that)

This is how many jobs we processed today…

![Sidekiq history graph for today](http://d.pr/i/O9aU+)

And this is a snapshot of our realtime graph

![Realtime graph snapshot](http://d.pr/i/7Fkr+)

On the MongoDB side we are working with Mongoid and we have a shared environment, 9 shards with 3 replicas in each shard, all running through 2 routers.

Our production mongoid config looks like this

```yaml
production:
  op_timeout: 3
  connection_timeout: 3
  sessions:
    default:
      hosts:
        - HOST_NAME:27017 #Single router R0
      username: USER_NAME
      password: PASSWORD
      database: DATABASE_NAME
      options:
        consistency: :eventual
```

We are using latest versions of all relevant gems (Sidekiq, Mongoid, Moped, Redis)

All seems fine right? What's the problem?
-----------------------------------------

The problem is that we have too many connections opening and closing to our mongo instances. (~25-40 new connections per second).

Each time a job is picked up, a connection to Mongo is opened and when the job is done, this connection is closed (using Kiqstand middleware).

This is causing huge loads on our router server, and causing mongo to run out of file descriptors at times.

SO?
---
More then anything, this post is a callout for discussion with anyone using similar solution with similar scale and can assist, I know I would love to brainstorm on how to solve this problem.