---
layout: post
title: "Better TODO comment for your code"
date: 2013-07-26 14:38
comments: true
categories: [general]
---

Usually, when I have to do something in my code, I add a TODO comment (and forget about it).

For example

```ruby
	class UserThank
	  module Scores
	  
	    def _score
	      return Scoring::UserLeaderboard::WEIGHTS[:thanks]
	    end
	
		 # TODO: Should this be the user attached to the activity or should this be the thanked user?
		 # Ask product and change the code
	    def _receiver
	      [self.user]
	    end
	
	  end
	end
```

I have the shortcuts to show all TODO in vim, but it's clearly not in my muscle memory and not in any kind of memory, natural or computerized, I just don't do it enough, so it adds up and I feel bad about it.

Today, while coding I encountered this case, where clearly it's not just a simple thing, it's not just something I as an engineer care about, it's a product related thing and affects core user experience.

So, I think I found a better way to actually make sure I DO my TODO.

I thought to myself, what do I notice every single time, I never overlook…

The answer was clear, tests, if a test fails I will never overlook it, will never deploy if a single test fails, same goes for the rest of the team.

so here's the solution

```ruby
	context "User Thank" do
	  it "should score the user" do
	    pending "This is pending some investigation on the product side, right now I will fail it" do
	      true.should be_true
	    end
	  end
	end
```

I make use of a super useful Rspec feature, where you pass false or an exception into a pending block, it fails the spec.

I just describe the problem in detail, and that's it, this is a piece of code that will be dealt with, before deploy.
