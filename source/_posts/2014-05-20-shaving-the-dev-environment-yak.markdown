---
layout: post
title: "Shaving The Dev/Working Environment Yak"
date: 2014-05-21 10:34:33 -0700
comments: true
categories: chef ruby rvm
---
So one of the more interesting things about starting to work at a new company is getting the development environment right. For me, what gets really interesting is understanding all of the things that this involves. I am going to skip discussing things like iTerm2 and my tmux config and really focus in on what I have been doing to work with Chef and adapt to the way we do things as we deal with Cookbooks.

## Starting with Chef DK

I lucked out that [Chef DK](http://www.getchef.com/downloads/chef-dk/) was released right before I started at Chef. As you can probably guess, that is what I decided to use as my starting point. I have to say, one of the things that has impressed me the most since moving to doing Chef regularly is all the various extension points. As I started work on things with [Supermarket](http://www.getchef.com/blog/2014/03/24/chef-supermarket-the-new-community-site/), the ability to quickly build something like [knife-supermarket](https://github.com/cwebberOps/knife-supermarket) was a huge win. 

So to that end, one of the first things I learned how to use as part of Chef DK was `chef gem install`. In general, I have installed things as I have needed them. The biggest thing I have started with is installing the [stove](https://github.com/sethvargo/stove) gem by Seth Vargo. This gem gives me an easy way to setup all the things around publishing new versions of cookbooks to the community site. In addition to that, I am a huge fan of guard. I use guard to watch for changes to files and run my tests automatically. To that end, I have installed the following guard plugins:

* guard-foodcritic 
* guard-rubocop 
* guard-rspec 

All of these were installed by running `chef gem install` to make sure they were installed into the same world that my Chef DK environment uses.

## To The Cloud

So one of the more interesting parts of my job at this point is that multi-platform support is not only a nice to have, it is a basic necessity for many of the cookbooks we support. While this is insanely cool, it does make for an interesting adventure trying to get setup to test across the gamut of operating systems. For starters, there isn't really a single cloud provider that you can test all the OS variants against so you have to use more than one provider. Second, it is actually beneficial for us to use all of the major cloud providers to make sure we see when things change and break for our users.

What that translates to is a lot of stuff to install and setup to get going. In many, hopefully most very soon, of the Chef supported cookbooks you will find a `.kitchen.cloud.yml` that is setup to do testing across cloud platforms and OS distributions. If you take a look at a typical [.kitchen.cloud.yml](https://github.com/opscode-cookbooks/mysql/blob/master/.kitchen.cloud.yml) file like the one found in the [opscode-cookbooks/mysql](https://github.com/opscode-cookbooks/mysql) repo on GitHub, you will see a myriad of different providers and environment variables. For now, I am going to gloss over the environment variables. It is enough to say that there are a lot of them and not always intuitive so please hit me up on freenode, if you have any questions about a particular env variable. To enable all the different providers, I have installed a number of test-kitchen plugins. You can't even run a `kitchen list` until they exist when using the cloud yaml file. The test-kitchen plugins I have installed are:

* [kitchen-digitalocean](https://github.com/test-kitchen/kitchen-digitalocean)
* [kitchen-ec2](https://github.com/test-kitchen/kitchen-ec2)
* [kitchen-gce](https://github.com/anl/kitchen-gce)
* [kitchen-joyent](https://github.com/test-kitchen/kitchen-joyent)

As mentioned before, I installed the above using the `chef gem install` command to ensure that all of those kitchen plugins work with the test-kitchen install that comes with Chef DK. The icing on the cake that makes it all work is that I set `KITCHEN_YAML=.kitchen.cloud.yml` so that test-kitchen takes advantage of the awesome config that we have setup.

## Rub a Little RVM on It

So... I have a little confession to make. While I still don't consider myself a developer, I have found that over the years writing ruby has been a lot of fun for those pesky web interfaces and complicated scripts that I write. Most of my ruby code would make a good dev cry, but it is still an easy language to get work done in. To that end, having a sane ruby dev environment has also been important for various reasons. Even in the time I have worked at Chef I have found myself writing code to automate things. (For example, I wrote a tool to grab all the neat things going on with Supermarket. That code is on GitHub as [cwebberOps/supermarket-report](https://github.com/cwebberOps/supermarket-report).) While I get that bundler is awesome, I still like to be able to separate out my ruby and my gemsets.

So I looked at chruby and chgems and a little at rbenv. Both left me wanting to go back to rvm, so that is what I did. The interesting thing is that if you have a ruby selected via rvm you lose out on the awesome that is Chef DK. So to get things the way I want them, I have set my default ruby to the system ruby in rvm by running `rvm use system --default`. For whatever reason, I then have to load a new shell for my prompt to not complain about `rvm-prompt` being missing. This setup has worked well. My general workflow is to open a new session in tmux and when I switch into a project have the `.rvmrc` change me to the right ruby. An alternative approach can be found over on [Joshua Timberman's blog](http://jtimberman.housepub.org/blog/2014/04/30/chefdk-and-ruby/) about how he uses Chef DK.

All things equal, the setup of the software has been smooth. The only real places I have run into issues is getting all the environment variables setup and accounts created. While having two workstations I use regularly has added to the confusion at times, as I have gotten things squared away, things just tend to work. A huge shout out to the folks working hard on Chef DK, it has for sure made my experience delightful.