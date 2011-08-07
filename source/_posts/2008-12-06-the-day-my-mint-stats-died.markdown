--- 
layout: post
comments: false
title: The Day My Mint Stats Died
date: 2008-12-6
link: false
categories: life
---
Three years ago, on December 5th, I installed Mint for the first time.  Since that time it has recorded 26,000 plus page views and almost 15,000 visits to my humble site.  Along the way I have added and taken away various peppers, and I upgraded to version 2.0 this past year.  Mint has worked flawlessly the entire time.

On December 5th this year, when I tried to view my Mint page all I got was the End User License Agreement (EULA) acceptance page.  I was very reluctant to accept the license for fear it would truly install Mint again and somehow overlay all my statistics.  I post a question to the Mint troubleshooting forum and waited for an answer.

Meanwhile my site itself was taking a very long time to load.  I called Sibylle and asked her to try an view my Mint page thinking that the problem could somewhere in my browser cache or cookies.  She also got the EULA screen, not the log in page that I was hoping for.  I used phpMyAdmin on my site to back up the Mint database just in case.  I had a back up from late November when I had last updated Wordpress on my site, but I was hoping to not lose the statistics collected since then.

By early evening I still hadn't gotten any responses on the forum so I accepted the license and waited to see what happened.  After a very long time loading I got the "Create new account" page.  Fearing that my statistics were about to be lost I entered in the same id and password I'd used before and hit Enter again.  After another very long wait I was back at the EULA page.  Somehow the installation was caught in a loop.

Sibylle commented that my site was extremely slow to load on her computer as well.  Wondering if there might be something wrong with my host, I called their technical support.  As an aside let me say that Bluehost has phenomenal technical support.  I pressed "2" for support and was speaking to Jason in 5 seconds.  Wow.

Jason had me look at the error logs for my site, and he made several suggestions, but the one that caught my attention was to repair the database.  Turns out phpMyAdmin has a table repair utility built-in.  I selected all the tables in my Mint database and ran the repair option.  Within seconds it was done (it's a small database) and voilà!, my Mint statistic page was back again.  Complete with all the statistics from the past 3 years.  Even better, my site was running normally.  Page loads were no longer taking several minutes to occur.

Apparently, around 3 am on the 5th, something happened on my site that caused one or more of the Mint tables to need repair.  Since every page on my site calls into the Mint software, and hence touches the database, this "needs repair" state brought my site to its knees.  And it caused Mint to think it was still being installed.

Tonight, more than a day after the repair was done, both my site and my statistics are working normally.  I cannot imagine what caused the error with the database, but I am grateful that it was easily fixed.
