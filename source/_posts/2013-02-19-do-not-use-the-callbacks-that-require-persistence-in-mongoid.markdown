---
layout: post
title: "DO NOT use the callbacks that require persistence in Mongoid"
date: 2013-02-19 22:10
comments: true
categories: ["Ruby", "Ruby on rails", "MongoDB" ]
---

I started using MongoDB at [Gogobot](http://www.gogobot.com) a little while ago.
While using it, I encountered some [problems](http://avi.io/blog/2013/01/30/problems-with-mongoid-and-sidekiq-brainstorming/), but for the most part, things went pretty smooth.

Today, I encountered a bug that surprised me.

While it certainly should not have, I think it can surprise you as well, so I am writing it up here as a fair warning.

For Gogobot, the entire graph is built on top of MongoDB, all the things social are driven by it and for the most parts like I mentioned, we are pretty happy with it.

SO, What was the problem?
-------------------------

The entire graph is a mountable engine, we can decide to turn it on or to turn it off at will.
It acts as a data warehouse and the workflows are being managed by the app.

For example:

When model X is created, app is notified and decides what to do with this notification, and so on and so forth.

Everything peachy so far, nothing we haven't used hundreds of times in the past.

Here's how it works.

We have a model called `VisitedPlace`, it's a representation of a user that visited a certain place

Here's the code

```ruby
	module GraphEngine
	  class FbPlace
	    include Mongoid::Document
	    include Mongoid::Timestamps
	    include GraphEngine::Notifications::NotifiableModel
	    
	    #… rest of code here
	  end
	end
```

As you can see, this model includes a module called `NotifiableModel`, here's the important part from it:

```ruby
	module GraphEngine
	  module Notifications
	    module NotifiableModel
	      extend ActiveSupport::Concern
	
	      included do
	        after_create do
	          send_notification("created")
	        end
	      end
	      
	      def send_notification(verb)
	      	# Notify the app here...
	      end
	    end
	  end
	end
```

Like I said, pretty standard stuff, nothing too fancy, but here's where it's getting tricky.

This model has a unique index on `user_id` and `place_id`. It's a unique index and no two documents can exist in the same collection.

BUT… check this out:

```ruby
  GraphEngine::VisitedPlace.create!(user_id: 1, place_id: 1) => true
  GraphEngine::VisitedPlace.create!(user_id: 1, place_id: 1) => true
```

The second query actually failed in the DB level, but the application still returned true.

Meaning, that `after_create` is actually being called even if the record is **not really persisted**.

How you can fix? / should you fix?
-----------------------------------

For Gogobot, I fixed it using safe mode on those models, I don't mind the performance penalty, since I don't want to trigger Sidekiq workers that will do all sorts of things twice or three times.

Should you do the same? I am not sure, you need to benchmark your app and see if you can fix it in another way.

Would love to hear back from you in comments/discussion