---
date: '2009-03-08 20:19:45'
layout: post
comments: true
slug: how-to-watch-any-tv-show-or-movie-for-free-without-commercials
status: publish
title: How To Watch Any TV Show Or Movie For Free Without Commercials
wordpress_id: '826'
categories:
- How To
tags:
- boxee
- home media center
- home theater
- miro
- ubuntu
- xbmc
---

For a while now I've been watching less and less actual television and turning to the internet to get around old fashioned media distribution methods.

In this article I'm going to show you how I have finally gotten the right home theater system setup that I am 95% happy with, which will allow you to...



	
  * Get any TV or movie that you want to see for free, automatically downloaded for you in some cases

	
  * Watch them whenever you'd like, no more tuning in at a specific time

	
  * Skip any commercials

	
  * Watch it on your television as it should be (instead of a computer monitor)



Full disclosure: depending on what content you download you may be breaking copyright law.  It doesn't bother me much if you do since the industry is so backwards, but I figured I should mention it.  The irony is that this setup is a better user experience than anything you could buy.

As a side note/rant on movie theaters, why do people even go to these any more?  You have to listen to other people talk and make stupid comments during the movie, you have to sit through 20 minutes of forced advertising at the beginning, you can't drink wine/beer, you can't cuddle with a significant other, you can't pause it to take a leak, you can't pay anything less than a 300% markup on candy.  The list goes on and on.  And perhaps the last remaining reason to go (larger screen/better sound) is largely disappearing with today's home theater systems.

Anyway, moving on...

**What You'll Need**



	
  1. An old computer you don't use (doesn't matter if it's slow, the one I'm using has an 800Mhz processor and a pitiful 384MB RAM, but it does have to have an [s-video out port](http://static.commentcamarche.net/en.kioskea.net/faq/images/0-rwyU11bT-edoc3114-s-.png))

	
  2. A TV that accepts S-video input (most modern flat screens support this)

	
  3. An S-video cable

	
  4. An audio cable [like this](http://lindy-computer-connection-technology-in.amazonwebstore.com/Audio-Cable-Stereo-3m/M/B000I2JVZA.htm?traffic_src=froogle&utm_medium=organic&utm_source=froogle) which takes your computer audio and splits it into two cables for your TV

	
  5. A wireless mouse/keyboard (not absolutely necessary but makes it a lot nicer so you can do everything from the couch, I have [this logitech one](http://www.amazon.com/gp/redirect.html?ie=UTF8&location=http%3A%2F%2Fwww.amazon.com%2FLogitech-Cordless-Desktop-EX110-967561-0403%2Fdp%2FB0009V6TL4%3Fie%3DUTF8%26s%3Delectronics%26qid%3D1236555510%26sr%3D8-1&tag=httpwwwstartb-20&linkCode=ur2&camp=1789&creative=9325) and it works pretty well).



You might be able to find both of those cables laying around the house by the way, they are commonly included with various electronic devices like camcorders, etc.

**Step 1: Install Ubuntu Linux**

While you could do this with an old Windows machine also, it uses more memory and crashes more often.  This is very doable on Mac as well if you have an old Mac around (I use Mac for my day to day work and love it).  However Ubuntu is a free operating system, uses very little memory, and is actually much better than Windows so that's the option I chose.

Visit the [Ubuntu download page](http://www.ubuntu.com/getubuntu/download) and get the latest version (8.10 at the time of this writing).  Burn the file to a blank cd and pop it into the CD drive on your old pc.  Turn it on and you should get an Ubuntu install screen.

[![](http://s3.amazonaws.com/oldbloguploads/2009/03/ubuntu01.png)](http://s3.amazonaws.com/oldbloguploads/2009/03/ubuntu01.png)

Note you may have to use safe graphics mode (I did) since you are using the S-video cable.  Go through the steps and in about 20 minutes you'll have a shiny new Ubuntu desktop.

[![](http://s3.amazonaws.com/oldbloguploads/2009/03/ubuntu1.jpg)](http://s3.amazonaws.com/oldbloguploads/2009/03/ubuntu1.jpg)

One final tricky step to configure Ubuntu: I had to [remove pulseaudio](http://www.ubuntugeek.com/fix-for-all-pulseaudio-related-issues.html) because it caused some problems later.  Basically, open the sound configuration panel (System > Preferences > Sound), set everything to "ALSA", then open a terminal window (Applications > Accessories > Terminal) and enter the following commands: "sudo apt-get remove pulseaudio" and "sudo apt-get install esound".

**Step 2: Install Miro**

[Miro](http://www.getmiro.com/) is an awesome free piece of software which will download all your TV shows for you.  What's really cool is that in the next step we will tell Miro which shows we like, and it will AUTOMATICALLY go out and download them for us whenever new ones air.  This is basically like free Tivo.

If you want to get technical, Miro is actually a bit torrent client.  Bit torrents are basically a technology that says "instead of downloading a single big file from one place, download little pieces from a whole bunch of places".  This allows you to get the data faster and more reliably since it's distributed (like the internet) and has no single point of failure.  It is also a very good idea to "participate" in this process by sending your little file pieces to other people once you have a file downloaded.  Miro does all this for you of course so you don't have to really know or care about all this, but I thought I'd throw it in for the fellow geeks in the audience.

Anyway, head over to the Miro download page.  The [Ubuntu instructions](http://www.getmiro.com/download/for-ubuntu/) are a little different if you've never installed something in linux before.  There are lots of different versions of Ubuntu.  If you followed the instructions above you have the Intrepid version, but if you aren't sure you can always goto Applications -> Accessories -> Terminal and type "lsb_release -a" to find out for sure.  Then you have to tell it where to look in the Synaptic package manager, and then reload it and pick Miro to install.  The instructions the Miro page are quite good.

Pretty soon you'll have something like this running:
[![](http://s3.amazonaws.com/oldbloguploads/2009/03/miro09911.jpg)](http://s3.amazonaws.com/oldbloguploads/2009/03/miro09911.jpg)

You'll probably want to install [all these codecs](https://help.ubuntu.com/community/RestrictedFormats/) to make sure you can play all the videos.  Just run "sudo apt-get install ubuntu-restricted-extras" from the terminal.

**Step 3: Add TV Shows with TVRSS.net**

Next you'll want to add all the TV shows you want to watch to Miro.  I'll re-post the key steps from this article at [FreeTvReviews.com](http://freetvreviews.com/tutorials/miro-tutorial-how-to-add-a-channel/) which already describes it quite well.





  * Visit [tvRSS.net](http://www.tvrss.net/)


  * Click the [Shows](http://www.tvrss.net/shows/) link




![Miro Tutorial](http://freetvreviews.com/wp-content/uploads/2008/02/miro-tut.jpg)






  * Navigate to a show you want to watch



  * Right-click "Search-based RSS Feed"




![Miro Tutorial](http://freetvreviews.com/wp-content/uploads/2008/02/miro-tut2.jpg)






  * Click "Copy Link Location" in Firefox to copy the location of the link.


  * Launch Miro. At the top menu, click "Channels" -> "Add Channel"




![Miro Tutorial](http://freetvreviews.com/wp-content/uploads/2008/02/miro-tut3.jpg)






  * Paste in the link you copied from tvRSS.net and press Enter


  * Right click the channel and click "rename" to name it something more meaningful, such as the name of the show.  This will help you keep it organized.



Basically, you'll add each show's RSS feed to Miro and it will then download the new shows (using bit torrent files) as them come out.  (A lot of jargon, I know...don't worry about it too much, it works.)  You can also download old episodes from the feed.

One more tip: in the Miro options I'd recommend setting the maximum upload speed to about 10Kb/second.  On most DSL/cable modems this will drastically improve your download speed since it won't be trying to upload at your maximum speed.

**Step 4: Getting Movies**

Many movies are also available as bit torrent files.  Miro can download them for you or you can even install another bit torrent client on Ubuntu if you'd like.

The best places to search for bit torrent movies?  I like to use [mininova.org](http://www.mininova.org/).  Once you do a search, sort the results by number of "seeds" to get the best results.  This means the number of people uploading pieces of the file.  The more seeds, the faster your download will go and typically the better the quality of the movie (there are a lot of bad copies floating around sites like this so it's not quite as easy to get good movies as it is TV shows).

Also, you will often have to wait until a movie comes out on DVD to get a good bit torrent copy.  Before then, most of the copies are from people bringing video cameras into movie theaters and the quality is horrible.  I normally just wait for a DVD copy to come out on mininova.

[![](http://s3.amazonaws.com/oldbloguploads/2009/03/picture-21.png)](http://s3.amazonaws.com/oldbloguploads/2009/03/picture-21.png)

An alternative site you can try is [thepiratebay.org](http://thepiratebay.org/) also but they don't let you sort by number of "seeds".

**Step 5: Getting a Killer Experience with XBMC**

This final step is optional.  You can watch all the movies/TV shows above in Miro or with another video player like [VLC media player](http://www.videolan.org/vlc/) which is excellent.

But if you want to take it one step further and REALLY pimp out your system, consider getting [XBMC](http://xbmc.org/) installed along side Miro.  This thing is GORGEOUS and makes a cool display to show all your content: TV shows, movies, pictures, music...it even does weather and a bunch of other stuff (for example, there is a plugin for getting hulu.com shows).

[![](http://s3.amazonaws.com/oldbloguploads/2009/03/xbmc11.png)](http://s3.amazonaws.com/oldbloguploads/2009/03/xbmc11.png)

[![](http://s3.amazonaws.com/oldbloguploads/2009/03/xbmc21.jpg)](http://s3.amazonaws.com/oldbloguploads/2009/03/xbmc21.jpg)

Once you have it installed, go to the 'video' section and click 'add source'.  You'll want to point it to the directory where Miro is downloading your TV shows.  Now you can view all your TV shows in XBMC.

You may also want to enable deleting of files in the XBMC options.  Then when you're done watching a TV show/movie you can clean it off your hard drive to save space.

With your [wireless keyboard](http://www.amazon.com/gp/redirect.html?ie=UTF8&location=http%3A%2F%2Fwww.amazon.com%2FLogitech-Cordless-Desktop-EX110-967561-0403%2Fdp%2FB0009V6TL4%3Fie%3DUTF8%26s%3Delectronics%26qid%3D1236555510%26sr%3D8-1&tag=httpwwwstartb-20&linkCode=ur2&camp=1789&creative=9325) you can control the whole thing and it is AWESOME!  Check out these [XBMC keyboard controls](http://dhrandy.blogspot.com/2008/09/xbmc-keyboard-controls.html) for more tips.

Here is a video demonstrating [XBMC on Ubuntu](http://www.youtube.com/watch?v=5QfjFlQrgXY) (it would of course be in full screen mode when you actually use it so you won't see the the computer desktop around it):



**Conclusion**
Parts of this can still be a bit tricky unless you are a computer nerd, obviously.  But it's getting easier all the time.  If you run into problems, post them below and maybe everyone here can help you figure it out.

We are quickly reaching a point where downloading media like this over the internet is actually easier and much more enjoyable than traditional distribution models like cable television or mailing DVD's.  As usual, big slow companies are behind the times with this and out of touch with what consumers would like.  About 95% of what's on TV is complete crap and really annoying, so this is a good way to filter out the junk.  It's also a huge opportunity for entrepreneurs to come in and make a killing!

Hope you find this useful or at least educational if you don't plan to do it yourself!
Brian Armstrong
