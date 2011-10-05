---
layout: post
title: "Picdrip, and getting more out of sharing your photos online"
date: 2011-10-05 16:47
comments: true
categories: picdrip pet-project
publish: false
---

### Background

Last December I found myself setting off for a month-or-so-long sojourn of Western Europe, and visited some amazing cities over the course of the following 5 weeks. I spent time in the beautiful cities of London, Paris, Barcelona, Venice, Prague and Berlin, among others.

When I returned home I found myself faced with a not-so-unfamiliar dilemma: after whittling down my photos to a list of just over 100, how do I incrementally upload them to Flickr? It was the same problem I faced after processing photos from a model shoot or a photowalk.

### Solution

This time, though, I was determined to automate my problem away. This time, I spent a day or two working on a very basic version of an online application that would allow me to upload all of my photos, which would then "trickle" my photos into Flickr at the rate of one photo per day.

The result was Picdrip, which lives at [http://picdrip.com](http://picdrip.com) in its largely unpolished state.

### Picdrip Overview

My goals for the application were to write as little code as possible, and to leverage cheap or free hosting options. This led me to develop a Rails web application, hosted on Heroku which uses Amazon S3 to store the photos that are yet to be uploaded to Flickr.

Rails was a good choice due to my ability to leverage the great library of gems to handle everything from authentication and authorisation to S3 and Flickr integration.

Heroku presented me with the opportunity to host the application entirely for free which was a big win, and S3 has only ever sent me bills for between $0.01 and $0.03, which they are smart enough not to bill for given how much it would cost them.

After a day I had a working application that I began to use, and I spent another day or two adding some other small features.
