---
layout: post
title: "Finding the Edge"
date: 2014-05-07 16:26:49 -0700
comments: true
categories:  chef supermarket knife ruby
---
As part of some of the work I am doing with [Supermarket](https://github.com/opscode/supermarket), Chef's new community site, we needed to make some updates to the way `knife` worked, specifically giving it the ability to talk to more than one site. So... I set about contacting the folks that do dev work on `knife` to figure out how the functionality would get added.

Just as soon as I asked in the Dev room on HipChat who I should contact from the Dev team, my boss hit me up. A few lines of chat later and he suggested I open a pull request with the code that adds the needed functionality. Holy crap. What did I just get myself into? My gut reaction was something along the lines of, "Really, me, write Ruby? Have you seen my code?" Well, a few minutes later I had snapped out of it and realized I just needed to level up and, as Opbeat would put it, ["Fuck it, Ship it"](http://blog.opbeat.com/posts/fuck-it-ship-it/). After a few more lines of discussion in HipChat, we decided that a knife plugin was the easiest way to get things out and usable quickly.

## Digging In

So off I went to create my first knife plugin. Having dabbled in Ruby a bit over the years, I recognized pretty quickly that I could just inherit the functionality from the current `knife cookbook site` commands and make the few changes that were needed to get a new option setup. Between the following two docs, I was able to get the download command extended to do what I wanted:

* [http://docs.opscode.com/plugin_knife_custom.html](http://docs.opscode.com/plugin_knife_custom.html)
* [http://rubylearning.com/satishtalim/ruby_inheritance.html](http://rubylearning.com/satishtalim/ruby_inheritance.html)

So cool, I had code. For testing I just symlinked each file into `~/.chef/plugins/knife/`. By doing this I was able to just run `knife` and test that everything worked. Interesting note for those that go look at the code, to verify things worked, I pointed at the staging site for Supermarket which is located at [http://supermarket-staging.getchef.com](http://supermarket-staging.getchef.com). Once I did that, I pointed at the current place knife is set to look, [http://cookbooks.opscode.com](http://cookbooks.opscode.com). From there, It didn't take much to override each of the various methods that mentioned the current cookbooks site. I was off to the races pretty quickly.

Interestingly enough, the most confusing part of the whole adventure was dealing with copyright. More specifically, who to assign authorship to was a bit confusing. The license was already chosen for me which made it easy, but deciding how to handle who to list as authors was kind of weird. In reality, most of the code was copy-pasta, so did that mean I should do a `git blame` and figure out who was responsible for the lines of code that came from the other subcommands? If I was doing that, should I update their email addresses since we were now Chef and not Opscode? In the end, I decided that I would remove the other authors because of the amount of code and really, I didn't want them to get random questions about a project they had likely never heard of.

Not only was this my first knife plugin, this was my first Ruby Gem. After some boilerplate borrowed from the [knife-openstack](https://github.com/opscode/knife-openstack) plugin, and creating an account on [rubygems.org](http://rubygems.org), it was super simple to get a gem uploaded and working. A quick `chef gem install knife-supermarket` and I was able to find my first bug. The gem process was super smooth and pretty quickly I was able to get a few fixes in place and out the door.

The real take away from all of this was the reminder that I enjoy life the most when living out on the edge of my comfort zone. As I approach that edge, it means that I am learning more and able to experience new things. As my time at Chef begins, I am looking forward to more opportunities to get pushed to the edge and over the edge of my comfort zone. 

## The Results
If you are running [Chef-DK](http://www.getchef.com/downloads/chef-dk/) you can install the plugin by running:
    $ chef gem install knife-supermarket
Otherwise, you can install the gem but running:
    $ gem install knife-supermarket

The code can be found at:

* [https://github.com/cwebberOps/knife-supermarket](https://github.com/cwebberOps/knife-supermarket)

Finally, the gem can be found at:

* [http://rubygems.org/gems/knife-supermarket](http://rubygems.org/gems/knife-supermarket)
