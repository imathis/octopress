---
layout: post
title: "Under Siege"
date: 2011-08-13 17:15
comments: true
categories: nerdliness
link: false
---
One of the primary reasons for switching to a static site generator was improved response time. Any site that relies upon dynamically created pages will be slower than one using static pages. The question is, "how much slower?"

Today on [Hacker News](http://news.ycombinator.com "Hacker News") there was a link to [Coderholic](http://www.coderholic.com/ "Coderholic") and an article about [Invaluable Command Line Tools for Web Developers](http://www.coderholic.com/invaluable-command-line-tools-for-web-developers/ "Invaluable Command Line Tools for Web Developers").

One of the tools is [Siege](http://www.joedog.org/index/siege-home "Siege"), a "HTTP benchmarking tool." From the examples given in the article I realized I could quickly and easily compare two of my blogs to see the difference between static pages and dynamic pages.

This site, [zanshin.net](http://zanshin.net "zanshin.net") is now statically served. My cello blog, [Solfège](http://cello.zanshin.net "Solfège"), is based on WordPress and is therefore dynamically served. Both sites are hosted on the same hardware at [Bluehost](http://bluehost.com "Bluehost")

Installing Siege was simple with [brew](http://mxcl.github.com/homebrew/ "Homebrew"), just type:{% codeblock %}
$ brew install siege
{% endcodeblock %}

With Siege installed I first ran a test against the static site. The test simulates twenty (20) concurrent connections for thirty (30 seconds). Here are the results:	{% codeblock %}
○ siege -c20 zanshin.net -b -t30s
** SIEGE 2.70
** Preparing 20 concurrent users for battle.
The server is now under siege...
HTTP/1.1 200   0.57 secs:   50339 bytes ==> /
HTTP/1.1 200   0.67 secs:   50339 bytes ==> /
HTTP/1.1 200   0.71 secs:   50339 bytes ==> /
... (cropped for brievity)
HTTP/1.1 200   1.75 secs:   50339 bytes ==> /
HTTP/1.1 200   6.05 secs:   50339 bytes ==> /
HTTP/1.1 200   2.80 secs:   50339 bytes ==> /

Lifting the server siege...      done.
Transactions:		         612 hits
Availability:		      100.00 %
Elapsed time:		       29.76 secs
Data transferred:	       29.38 MB
Response time:		        0.82 secs
Transaction rate:	       20.56 trans/sec
Throughput:		        0.99 MB/sec
Concurrency:		       16.93
Successful transactions:         612
Failed transactions:	           0
Longest transaction:	        6.28
Shortest transaction:	        0.53
{% endcodeblock %}

612 hits in 29.76 seconds, 100% of which were available.

Now here are the results against the dynamically served site:{% codeblock %}
○ siege -c20 cello.zanshin.net -b -t30s
** SIEGE 2.70
** Preparing 20 concurrent users for battle.
The server is now under siege...
HTTP/1.1 500   0.95 secs:     263 bytes ==> /
HTTP/1.1 500   0.65 secs:     358 bytes ==> /
HTTP/1.1 500   1.95 secs:     358 bytes ==> /
HTTP/1.1 200   2.07 secs:   30498 bytes ==> /
HTTP/1.1 200   2.10 secs:   30498 bytes ==> /
HTTP/1.1 200   2.98 secs:   30498 bytes ==> /
... (cropped for brevity)
HTTP/1.1 500   0.34 secs:     358 bytes ==> /
HTTP/1.1 200   5.39 secs:   30498 bytes ==> /
HTTP/1.1 500   1.28 secs:     358 bytes ==> /
HTTP/1.1 200   4.95 secs:   30498 bytes ==> /
HTTP/1.1 200   2.68 secs:   30498 bytes ==> /
HTTP/1.1 200   1.32 secs:   30498 bytes ==> /

Lifting the server siege...      done.
Transactions:		          98 hits
Availability:		       37.40 %
Elapsed time:		       29.09 secs
Data transferred:	        2.91 MB
Response time:		        5.50 secs
Transaction rate:	        3.37 trans/sec
Throughput:		        0.10 MB/sec
Concurrency:		       18.54
Successful transactions:          98
Failed transactions:	         164
Longest transaction:	        9.93
Shortest transaction:	        0.26
{% endcodeblock %}

Only 98 hits in 29.09 seconds, and only 37.40% availability. For those 98 successful hits there were 164 failed hits. It is worth noting that the number of bytes returned for the static site is 50,339 per transaction, whereas for the dynamic site is it only 30,498 -- when the access was successful.

Having only just discovered this tool I cannot vouch for its accuracy or validity. But, seeing the results side-by-side like this makes a compelling case for static pages over dynamic pages, particularly if you have a high volume of visitors to your site.
