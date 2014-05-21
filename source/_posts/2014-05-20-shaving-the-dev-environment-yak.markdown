---
layout: post
title: "Shaving The Dev/Working Environment Yak"
date: 2014-05-20 15:02:33 -0700
comments: true
categories: chef ruby rvm
---
So one of the more interesting things about starting to work at a new company is getting the development environment right. What gets really interesting is understanding all of the things that this involves. I am going to skip discussing things like iTerm2 and my tmux config ante really focus in on what I have been doing to work with Chef and adapt to the way we do things as we deal with Cookbooks.

## Starting with Chef DK

I lucked out that [Chef DK](http://www.getchef.com/downloads/chef-dk/) was released right before I started at Chef. So that is what I have used as my starting point. I have to say, one of the things that has impressed me the most since moving to do Chef regularly is all the various extension points. As I worked on things with [Supermarket](http://www.getchef.com/blog/2014/03/24/chef-supermarket-the-new-community-site/), the ability to quickly build something like [knife-supermarket](https://github.com/cwebberOps/knife-supermarket) was a huge win. 

So to that end, one of the first things I learned how to use as part of Chef DK was `chef gem install`. In general, I have installed things as I have needed them. The biggest thing I have started with is installing the [stove](https://github.com/sethvargo/stove) gem by Seth Vargo. In addition to that, I am a huge fan of guard, so I have installed the following guard plugins:

* guard-foodcritic 
* guard-rubocop 
* guard-rspec 

All of these were installed by running `chef gem install` to make sure they were installed into the same world that my Chef DK environment uses.

## To The Cloud

So one of the more interesting parts of my job at this point is that multi-platform support is not only a nice to have, it is a basic necessity for many of the cookbooks we support. While this is insanely cool, it does make for an interesting adventure trying to get setup to test across the gamut of operating systems. For starters, there isn't really a single cloud provider that you can test all the OS variants against so you have to use more than one provider. Second, it is actually beneficial for us to use all of the major cloud providers to make sure we see when things change and break for our users.

What that translates to is a lot of stuff to install and setup to get going. In many, hopefully most very soon, of the Chef supported cookbooks you will find a `.kitchen.cloud.yml` that is setup to do testing across cloud platforms and OS distributions. If you take a look at a typical [.kitchen.cloud.yml](https://github.com/opscode-cookbooks/mysql/blob/master/.kitchen.cloud.yml) file like the one found in the [opscode-cookbooks/mysql](https://github.com/opscode-cookbooks/mysql) repo on GitHub, you will see a myriad of different providers and environment variables. For now, I am going to gloss over the environment variables. Please hit me up on freenode, if you have any questions about a particular env variable. The test-kitchen plugins I have installed are:

* [kitchen-digitalocean](https://github.com/test-kitchen/kitchen-digitalocean)
* [kitchen-ec2](https://github.com/test-kitchen/kitchen-ec2)
* [kitchen-gce](https://github.com/anl/kitchen-gce)
* [kitchen-joyent](https://github.com/test-kitchen/kitchen-joyent)

As mentioned before, I installed the above using the `chef gem install` command to ensure that all of those kitchen plugins work with the test-kitchen install that comes with Chef DK. The icing on the cake that makes it all work is that I set `KITCHEN_YAML=.kitchen.cloud.yml` so that test-kitchen takes advantage of the awesome config that we have setup.

## Rub a Little RVM on It

