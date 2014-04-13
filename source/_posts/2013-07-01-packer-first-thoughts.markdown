---
layout: post
title: "Packer - First Thoughts"
date: 2013-07-01 13:12
comments: true
categories: ops
---

As I spent the weekend eagerly awaiting the arrival of my 2nd daughter and avoiding the heat, I got a chance to play with [Packer](http://packer.io) quite a bit. It has been a blast getting it bootstrapped and spinning up VMs. 

While there are still a few bugs to be worked out, packer seems very stable and well thought out. Everything from Ctrl-C doing what you would want by cleaning up after itself, to insightful error messages it is top notch software. A huge shout out goes to [@patrickdebois](https://twitter.com/patrickdebois) whose [veewee](https://github.com/jedi4ever/veewee) project made it trivial to get going with Packer. The veewee-to-packer gem, written by [@mitchellh](https://twitter.com/mitchellh) made it a snap to take my veewee definitions and turn them into Packer templates.

## Why Packer?

For anyone that has been a long time user of [Vagrant](http://vagrantup.com) the first question that probably comes to mind is, "Why should I switch to Packer from veewee?" The simple answer is that Packer already does 90% of what veewee does, but it can build in parallel. Plus, Packer will handle the automagical building of VMware Vagrant boxes. In addition to those things, For me, the biggest reasons to use Packer are the lack of a need for a ruby environment, and the longer term extensibility that the foundation has already been laid for.

On the lack of a need for a ruby environment… Of all the things I have struggled with as an Ops guy is getting other members of my team to jump through the hoops that is getting a modern ruby environment setup. Between the version crap, bundler, etc. removing the need for ruby will be a huge win for me as I evangelize the use of Vagrant.

## My Experience So Far

For being software that was at version 0.1.0 when I installed it, Packer is amazingly well documented. The community is already developing quickly and fixes for the bugs are rolling in super fast. I have hit a few problems here and there but almost all of them have already been addressed in version 0.1.3. I just want to say a huge, thank you, to [@smerrill](https://github.com/smerrill) for all the work he done as it has made my life tremendously easier.

## Getting Started

So then, where to start? If you are using veewee, I would suggest starting with the [veewee-to-packer](http://www.packer.io/docs/templates/veewee-to-packer.html) gem. If you haven't played much with veewee and just want to start with Packer, @smerril has put up a great starter template for CentOS 6.4 at [https://github.com/smerrill/packer-templates](https://github.com/smerrill/packer-templates). My goal is to get some templates up in the next week or so depending on how things go.

## The Future

Personally, I will be paying a lot of attention to Packer as things move forward. It make it a lot easier to duplicate what our corporate kickstart servers are doing, and will make creation of Vagrant boxes much easier and more accessible than it has been in the past.