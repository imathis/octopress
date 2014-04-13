---
layout: post
title: "Puppet Design Patterns"
date: 2013-01-10 20:48
comments: true
categories: [puppet, design patterns]
---
Programming and software engineering have never been areas where I would consider myself strong. Quite frankly, it is the exact opposite. Digging into code and troubleshooting is fine, but writing code from scratch is still something I struggle with. As I have jumped onto a team with a dev guy turned ops guy, discussions about how we write puppet code have come up. 

Starting with a discussion about where ancillary services get instantiated (I'll cover that in a separate blog post), I started looking for more details about design patterns in puppet. The more I looked and asked questions, the more I realized there is not much out there. At this point, the only real reference I have found was [Simple Puppet Module Structure Redux by R.I. Pienaar](http://www.devco.net/archives/2012/12/13/simple-puppet-module-structure-redux.php). This article does a good job covering a self contained module that sets up a self contained service, but it really lacks some of the more advanced use cases.

My plan at this point is to start the conversation. Below is a list of issues that I think could be well served by design patterns and discussions of anti-patterns. As time goes by my goal is to start writing posts that help to better shed light on what I see as the issue and ways I understand that we can solve it. My hope is that this will start the discussion, because I am definitely not the one to suggest the right way of doing things.

### Design Pattern Areas

* Ancillary Service Configuration (Post is about 50% done)
* Distinguishing between types of modules. (i.e. Type and Provider, Building Blocks, Roles, etc.)
* Interaction with environments

Just incase it wasn't clear, I am lost when it comes time to all of this stuff. My hope is that those that have been there and done that can help shed some light on the right ways to move forward.

## Update

So the first response I got to this post in IRC was to take a look at a [Designing Puppet - Roles and Profiles by Craig Dunn](http://www.craigdunn.org/2012/05/239/). This is a great starting point for a lot of the thoughts I have had.