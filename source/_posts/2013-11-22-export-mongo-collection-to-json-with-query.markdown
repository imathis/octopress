---
layout: post
title: "Export mongo collection to json with query (and a bonus)"
date: 2013-11-22 16:39
comments: true
categories: MongoDB, Ruby 
---

I work a lot with MongoDB, and this is not the "Why not MongoDB" or "Why MongoDB" type of post, I know it's popular to trash Mongo lately.

Anyway, while working with Mongo, from time to time I need to export a collection, or a subset of the collection based on a query.

I love using `mongoexport` because you basically get JSON file out of it (or CSV) and from there on you can pretty much do anything you want with it.

You can use Amazon's MapReduce or any other solution you may want.

For example, when I do usually is export a list I need, load it into Rails console and work with the output, queue it up to the worker list etc...

Let's cover some scenarios I use the most

## Export Collection To JSON

Actually, I never use it, since the collections are too big for the disk to handle at once, we have a sharded collection, so no one-disk solution can hold the data.

That been said, I think for most people this can be very useful.

```
mongoexport --host HOST --port PORT --db DB_NAME -u USERNAME -p PASSWORD --collection COLLECTION_NANE -q '{}' --out YOUR_FILENAME.json
```

## Export part of the collection to JSON (using a query)

```
mongoexport --host HOST --port PORT --db DB_NAME -u USERNAME -p PASSWORD --collection COLLECTION_NANE -q '{ "some_numeric_field": { "$gte": 100 } }' --out YOUR_FILENAME.json
```

The most important part here is that the -q options needs to be a valid JSON format query that Mongo knows how to handle `{ "some_numeric_field": { "$gte": 100 } }`. You can of course use far more complicated queries, but for most cases I don't need to.

## Bonus

I use [Dash](http://kapeli.com/dash) every day, multiple times a day, so it was only natural to have a dash snippet that I can use

Dash snippets are basically a way to paste some code using a shortcode, so typing `mongoexport` in the console pops up a window where I can complete the rest of the command easily without remembering the options.

Here's the Dash snippets

```
mongoexport --host __host__ --port __port__ --db __db-name__ -u __username__ -p __pass__ --collection __collection__ -q '__query__' --out __filename__.json
```

And this is what the window looks like when I type the shortcode, I tab through the place holders and there's a no-brainer way to remember the command and the options.

![dash snippet window](https://www.evernote.com/shard/s54/sh/12b3d1f2-1db6-4263-9776-0b6e209f9be6/d8a1a1191a075b3d2c71262b70e2b86b/res/8d37de67-11a7-4708-a79a-e59b7a278bef/skitch.png?resizeSmall&width=832)