---
layout: post
title: "Picdrip, and getting more out of sharing your photos online"
date: 2011-10-06 08:44
comments: true
categories: picdrip pet-project ruby
publish: true
---

### Background

Last December I found myself setting off for a month-or-so-long sojourn of Western Europe, and visited some amazing cities over the course of the following 5 weeks. I spent time in the beautiful cities of London, Paris, Barcelona, Venice, Prague and Berlin, among others.

When I returned home I found myself faced with a not-so-unfamiliar dilemma: after whittling down my photos to a list of just over 100, how do I incrementally upload them to Flickr? It was the same problem I faced after processing photos from a model shoot or a photowalk.

### Solution

This time, though, I was determined to automate my problem away. I spent a day or two working on a very basic version of an application that would take all of my photos and then "trickle" them into Flickr at the rate of one photo per day.

The result was Picdrip, which you can find online at [http://picdrip.com](http://picdrip.com) in its largely unpolished state.

### Picdrip Overview

My goals for the application were to write as little code as possible, and to leverage cheap or free hosting options. This led me to develop a Rails web application, hosted on Heroku which uses Amazon S3 to store the photos until they are uploaded to Flickr.

Rails was a good choice due to my ability to leverage the great library of gems to handle everything from authentication and authorisation to S3 and Flickr integration. Heroku presented me with the opportunity to host the application entirely for free which was a big win, and S3 has only ever sent me bills for between $0.01 and $0.03.

After a day I had a working application that I began to use, and I spent another few days adding other small features.

### Gems

My aim of writing as little code as possible was made easy through a few specific gems, namely Devise, CanCan, Dragonfly and FlickRaw.

[Devise](https://github.com/plataformatec/devise) is one of the best authentication gems for Ruby web apps. After pulling it into my project, a simple `rails generate devise:install` had everything up and running. Restricting access meant including `before_filter :authenticate_user!` in the relevant controllers, and wiring the registration, login and other Devise-based interfaces into the application simply meant throwing the line `devise_for :users` into my `routes.rb`.

[CanCan](https://github.com/ryanb/cancan) is an amazing gem from Ryan Bates which makes authorisation as simple as running `rails generate cancan:ability`. The result is a file named `ability.rb` in your `models` directory which uses a very simple DSL to explain how to determine what permission a user should be given. My logic started out as just `can :manage, Photo, :user_id => user.id` which means that a user can manage (ie. view, modify, delete, etc.) a photo only if the Photo's `user_id` attribute matches a given user's `id`.

[Dragonfly](https://github.com/markevans/dragonfly) was my choice for both managing photo uploads and for rendering them back to user. It has a nice advantage over the very popular Paperclip in that it renders thumbnails of varying sizes on the fly using Imagemagick, giving the obvious benefit of being able to easily change the thumbnail sizes I use without any hassle. It does this by assigning unique identifiers to each thumbnail it generates and expects you to use a cache to store these generated copies, which works perfectly with the fact that Heroku uses Varnish in their platform to perform caching functions.

The final gem I leveraged was [FlickRaw](https://github.com/hanklords/flickraw), which is a wrapper around the Flickr API. It works by querying the the `flickr.reflection.getMethods` API call when you instantiate the `FlickRaw::Flickr` class. It then lets you call methods exactly as they appear in the Flickr API documentation, transparently handles passing your API key (which nearly all calls require), and both accepts arguments and returns responses as simple Ruby hashes.

Overall there was little required other than some simple glue code to wire these gems together to do exactly what I wanted.

### Next?

There are still some obvious features to implement, such as bulk uploading, as well as some serious work to be done on the visual design as well as the usability of the application. You can find the [source on GitHub](https://github.com/jamesottaway/picdrip) and you can see the application in action at [http://picdrip.com](http://picdrip.com). I have also written a lightning talk on Picdrip featuring some more detailed code examples, which you can see at [http://lightning.picdrip.com](http://lightning.picdrip.com).
