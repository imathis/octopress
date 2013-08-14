---
layout: post
title: "Move jobs from one queue to another - Sidekiq"
date: 2013-08-14 17:36
comments: true
categories: ['Ruby', 'Rails', 'General']
---

I have been working with Sidekiq for quite a while now, having many jobs per day working (multiple millions of jobs.)

Sometimes, I queue up tasks to a queue called `#{queue_name}_pending`, I do this so I can manage the load on the servers. (For example: Stop writing to Mongo, Stop importing contact etc...)

This way, I can queue up many jobs, and I can move it to the real queue whenever I feel like it or whenever the problem is solved.

I was looking for a way to move tasks from one queue to another.

There's nothing built into Sidekiq for this, but obviously, you can just use redis built in commands to do it.

Here's the code to do it

```ruby
	count_block = proc{ Sidekiq.redis do |conn|
	  conn.llen("queue:#{queue_name}")  
	end }
	
	while count_block.call > 0
	  Sidekiq.redis do |conn|
	    conn.rpoplpush "queue:#{queue_name}_pending", "queue:#{queue_name}"
	  end
	end
```

This will move all the items from one queue to another until there are no more jobs.

b.t.w
Obviously, the `_pending` queues don't have any workers assigned to them, the purpose of it is a place holder so the jobs won't go to waste and we can resume work when we can.