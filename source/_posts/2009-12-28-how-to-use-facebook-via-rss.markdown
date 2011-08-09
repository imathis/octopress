--- 
layout: post
title: How to Use Facebook Via RSS
date: "2009-12-28"
comments: false
categories: life
link: false
---
I have a love-hate relationship with Facebook. I appreciate seeing what the people I know are up to, but I dislike all the quizzes and games and their associated chatter. Turns out it is possible to get status updates, notifications, notes and links via RSS feed. Naturally, since Facebook wants to your share your stuff with the world and not just lurk in the corner like a good introvert, they don't make it obvious how to set up the feeds.

<a title="jwz.org" href="http://www.jwz.org/" target="_blank">Jamie Zawinski</a> has a short posting on his <a title="Live Journal" href="http://www.livejournal.com/" target="_blank">Live Journal</a> site explaining <a title="How to use Facebook with a feed reader" href="http://jwz.livejournal.com/1144527.html" target="_blank">how to use Facebook using RSS feeds</a>. I've copied the directions below.
<ol>
	<li><strong>Posts:</strong> Find the Posts feed by going to <a href="http://www.facebook.com/posted.php">http://www.facebook.com/posted.php</a>. On the upper right of the page is a gray box, and at the bottom of that box is a link entitled "My Friends' Links" with the RSS logo next to it. Copy that URL. Subscribe to it in your feed reader. This is the RSS URL for any links and (external) images that your friends post.</li>
	<li><strong>Notes:</strong> Find the Notes feed by going to <a href="http://www.facebook.com/notes.php">http://www.facebook.com/notes.php</a> and repeating the above. This is the RSS URL for things that your friends post via the "Notes" app, which is (I guess) the more blog-like way of posting long things to Facebook.</li>
	<li><strong>Notifications:</strong> Find the Notifications feed by going to<a href="http://www.facebook.com/notifications.php">http://www.facebook.com/notifications.php</a> and repeating the above. This is the RSS URL for things like <em>"so-and-so commented on your status"</em>. You might not care to subscribe to this one because you can get all of <em>these</em> kind of notifications in email.</li>
	<li><strong>Status Updates:</strong> This is the RSS URL for the "What are you doing?" Twitter-like part of Facebook. This is the one you probably care about, and it is trickier, because Facebook no longer links to the feed URL! Nice one guys. You have to construct this URL by editing one of the above URLs. E.g., take the "Notes" URL and change the part of the URL that says <strong>"friends_notes"</strong> to <strong>"friends_status"</strong>. Keep the parts of the URL before and after that, including the magic numbers at the end.</li>
</ol>
I set up NetNewsWire following his directions and it works beautifully. And since I use the <a title="Selective Twitter for Facebook" href="http://www.facebook.com/selectivetwitter" target="_blank">Selective Tweets</a> application on Facebook to allow status updates via <a title="Twitter" href="http://twitter.com" target="_blank">Twitter</a>, I now won't need to visit the Facebook page except on rare occasion.
