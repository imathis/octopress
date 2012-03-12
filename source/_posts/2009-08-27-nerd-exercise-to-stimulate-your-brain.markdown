---
date: '2009-08-27 16:24:26'
layout: post
comments: true
slug: nerd-exercise-to-stimulate-your-brain
status: publish
title: Nerd Exercise To Stimulate Your Brain
wordpress_id: '1083'
categories:
- Education
---

This isn't specifically related to starting a business but I thought some people might find it interesting.  It gives you a little insight into computer science and will make you feel smarter.

You know those weird bunch of characters you see on the end of some URL's?  You might have seen something like this:


> Please confirm your subscription by clicking here:
http://feedmailpro.com/confirm/dSrMq7Z2


In case you don't know, those random characters on the end are simply a code to identify you so that only YOU can confirm it and nobody else could guess it and sign you up without your consent.  Kind of like a password.

**But here is a more interesting question: how many characters is "enough" to make sure it's secure?**

Well, to start with we know that everyone needs their own unique code, and there can't be any duplicates.  Otherwise, you might accidentally confirm theirs instead of your own.  So let's think for a minute about how many total subscribers could be in our system as sort of an "upper limit".

For FeedmailPro let's say we're thinking big and want to have a million customers one day.  And on average each of those customers had 10,000 subscribers on their list (some more, some less).  That would be a pretty good business and we'd need enough codes for 1,000,000 * 10,000 = 10 billion subscribers.

10 billion sounds like a lot.  How many digits would the code need to be to make sure we had 10 billion of them?  For that we'll do a little math...(easier than you probably think).

Well what if the code was only one digit long? It could be one of 26 lower case letters, 26 upper case letters, and 10 number digits (assume we can't use any other special characters).  So that is 26 + 26 + 10 = 62 possibilities for a one digit code.  Interesting.

What if it was two digits?  (you can imagine aa, ab, ac.....ba, bb, bc....Aa, Ab, Ac....)  There are 62 possibilities for the first digit of the code, and 62 possibilities for the second digit.  So it turns out it's just 62 * 62 = 3,844 posibilites.  That was a big jump.

After a minute you might start to see a pattern: that we really just have to multiply 62 by itself once for every digit that we have.   Even if we have 3, or 4 or 100 digits...there are really 62 possible characters for each position so we just multiple 62 * 62 * 62 * 62 .... once for each digit.  (Or as an exponent we'd say 62x where x is the number of digits.)

So getting back to our 10 billion subscribers, how long does the code have to be?  We whip out our calculator and see that...

623 = 238,328
624 = 14,776,336
625 = 916,132,832
626 = 56,800,235,584

Woah!  That was fast.  I don't know about you, but this always surprises me.  Just 6 digits (a simple code like "abcdef") and we're already up to 56 billion!  That's enough for every man, woman, and child on the entire planet to be subscribed to about 10 different email lists on FeedmailPro!

**Ok, but don't break out the champagne yet.  We've got one more thing to worry about: what about the bad guys?**

It's actually not quite enough to just have one code for everybody, because there are also bad people out there.  What if someone REALLY wanted to mess with your service?  They could start guessing random codes and trying them hoping to subscribe random people and generally wreak havoc on your system...causing it to go down or lose credibility!

That's not good.  So we have to ensure that not only does everyone have a unique code, but if you randomly try to guess one there is a VERY good chance you won't get one.

Let's try a 10 digit code:

6210 = 8.39299365868e+17  (it's big!)

Now we have a lot of possibilities.  In fact, lets say we had all 10 billion subscribers signed up.  How likely is it that someone guessing codes would get a code that belonged to one of them?

6210 / 10 billion = 84 million guesses!

Yep...they'd have to guess 84 million times on average before they could guess a valid code.  This is a worst case scenario also because in reality, I probably will never have 10 billion subscribers on FeedmailPro and many of those people will already be subscribed (in which case guessing the code is worthless) etc.  So the real chances of guessing a useful code would actually be much lower.

Still it's useful to think about such things.  In today's world, it's actually conceivable that someone could use a bunch of computers to guess 84 million codes in a reasonably short amount of time.  If I was guarding the keys to a nuclear missile silo, 84 million probably wouldn't be enough.  But In this case, subscribing some random person against their will is hardly the end of the world...and after all, they'd have to do another 84 million guesses to subscribe the next person (in which case you are hardly wreaking havoc...you are just a very lonely hacker wasting time in your Mom's basement by subscribing 2 people to a newsletter they didn't want).

**Conclusion**

So I hope you found this interesting as a thought exercise!  Now you know a little more about computer science than you probably wanted to.  And the next time you're wondering how many different combinations of outfits you can make with 4 shirts, 4 pants, and 4 pairs of shoes...you will know it's 4 * 4 * 4 or 64.

Until next time, keep breaking free!
Brian Armstrong
