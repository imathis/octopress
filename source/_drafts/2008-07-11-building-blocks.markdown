--- 
layout: post
author: Mark
comments: "false"
title: Building Blocks
date: 2008-7-11
categories: life
---
When I was a child I was given a large set of wooden blocks.  The set included a huge variety of sizes and shapes, and I spent many happy hours building any number of things with them.  My favorite activity was to build large towers; some required that I stand on a chair to add the upper layers.  Once the tower was complete I'd tie several newspaper rubber bands together and start attacking various supporting structures, until the whole thing came crashing down.  Followed shortly by my mother calling downstairs, "What was that?!  Are you alright?"

Today, as a software developer, I play with different blocks, but the underlying idea is the same: build useful structures that can withstand unexpected outside pressures.  Developing applications in Java, with or without HTML front-ends, requires an amazing number of blocks just to get started.

Assuming that your operating system is stable (a dangerous assumption to make, perhaps), the first block necessary is a JDK, or Java Development Kit.  <a title="Sun Developer Network" href="http://developers.sun.com/downloads/">Sun provides these</a>, and a nifty installer to put it on your machine.  Of course there are various flavors of Java (SE, ME, EE) and versions within those families; choosing the right block is important.

With a JDK installed, and a simple text editor you are ready to go.  Two, maybe three blocks - low and stable.  Unfortunately, while simple, this basic arrangement forces you to do most development chores by hand.  Automation is the key to success here.  Or at least the key to the appearance of success.

Oh, and calling Java "a block" is a bit disingenuous.  Java is a vast collection of libraries, concepts, and intricate dependencies.  Abstracting Java to just one block is useful in polite conversation; the reality is that it represents an incredibly complex array of blocks.

After laying down the Java block, or blocks, the next piece is a good IDE, or integrated development environment.  There are several major players in this market segment, however the one I am most familiar with is <a title="Eclipse" href="http://eclipse.org">Eclipse</a>, so I'll use it for our discussion.  As with Java, Eclipse (or any other IDE) is usually thought of as one block, when it is really a complex collection of blocks.  Adding to the fun are plugins; small (or not so small) blocks that get inserted into Eclipse to add or augment existing functionality.  

Hm.  Actually it isn't fair to call Eclipse a block.  It is truly a framework that other blocks are hung off, creating a platform for building software.  That the framework itself is a collection of hundreds of blocks is interesting in a recursive, turtles all the way down sort of way.  It also adds to the sense of instability building applications with the vast sea of blocks that is Java has already created.

Imagine standing on one box to reach a high shelf.  Not too bad, huh?  Now image that instead of a nice sturdy crate of a box, you are standing on a platform made of dozens and dozens of tiny blocks, neatly fitted together, but not required or restrained into a coherent assembly.  Not a comfortable sensation.  Now imagine that you are standing on not one, but two such platforms.  That is building Java applications with Eclipse, or any other large IDE.

There are one or two other significant pieces to this puzzle.  There is a plugin to manage the versioning of the code between my workspace and the central repository.  Also, there is a plugin that resolves dependencies - finds additional code libraries for when your application needs more than base Java provides.

When all the blocks are neatly lined up, and the weight of your development is properly supported, you can build great things.  When one or more of the blocks gets out of position, however, disaster can (and does) strike.

I spent the day yesterday building a new service, a simple data access object (DAO) to read data from a table and build an single object containing all the information about an entity.  Just a handful of code, really.  In order to vet my code I used a feature in Eclipse to generate a unit test.  This new piece of code is specially designed to exercise all the limits of the original code.  Of course, the test mechanism requires still more blocks to be shoehorned into our every-growing tower.  And when I tried to run the test all I got were nonsense errors.  

The errors seem to be saying that some piece of the Java, Eclipse, unit test framework, was out of whack.  So now, instead of debugging my application code, I get to debug the platform on which I am trying to build it.  Is there something wrong with Eclipse?  Or, more likely, one of the plugins currently employed?  Maybe the workspace is somehow corrupted.  Did I miss a small, but critical configuration setting?  

Somewhere, in the tower of blocks that extends from the operating system up through the Java JDK, the Eclipse IDE, with all its plugins, the version control system, and dependency resolution process, somewhere in that vast mass of blocks, one or more is out of place.  With no easy way to find it and realign it, the path forward is to knock the rest of the tower over, clean up the mess, and start over fresh.

Today I am rebuilding my environment, fresh copy of Eclipse, re-installing the necessary plugins, re-configuring the variables, and hopefully, eventually, testing my application.
