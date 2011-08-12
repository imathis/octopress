---
layout: post
title: "Switching to Octopress"
date: 2011-08-11 08:26
comments: true
categories: nerdliness
link: false
---
As mentioned a couple of days ago I have [switched](http://zanshin.net/2011-08-09-shiny/ "Shiny") from using [WordPress](http://wordpress.org "WordPress") to using [Octopress](http://octopress.org "Octopress") for my website. With just one or two minor exceptions everything about the site is working as I want. I still want to tweak the font sizes and spacing a bit, and I've got some ideas for the sidebar that need incorporating, but I am very pleased overall with how the site works now.

For those of you who are interested, here's how I went about this change.

## A plan
As much as I would like to say I had a plan with tasks and steps and milestones and testing, I didn't. Large parts of this were winged, and my checklist was several scraps of paper with hastily jotted notes reminding myself to "copy all images from old site to new" or "figure out Mint migration". Basically this project broke down into two major activities. Part one was researching Octopress and figuring out how it worked and how it's theme was setup. Part two was migrating my site from WordPress to Octopress.

## Getting Octopress
You can find Octopress, and detailed instructions on installing it, at [Octpress.org](http://octopress.org "Octopress"). In a nutshell you create a new Github repository and then grab a copy of Octopress from its repository. Octopress makes use of several open source tools including RVM, Pow, and Markdown. It also adds to Jekyll a Rakefile with several useful tasks predefined.

### Using RVM
Octopress is Ruby-based and makes use of the excellent Ruby version manager called [RVM](http://beginrescueend.com/ "RVM"). This tools allows you to have multiple versions of Ruby installed, and makes switching between those versions a snap. Octopress uses Ruby 1.9.2, and comes with a .rvmrc file specifying that dependency. Once you've installed Octopress you'll need to trust the .rvmrc file so that it can properly switch your Ruby environment anytime you access your Octopress installation.

Rather than run the {% codeblock %}$ rvm rvmrc trust{% endcodeblock %} command to accept the .rvmrc file included with Octopress, which never quite seemed to work in my zsh environment, I found it easier to change to another directory and then cd back into the Octopress directory. Upon returning to the Octopress installation I was presented with the RVM dialog about trusting the .rvmrc file the directory contained. This is a one time thing and, once accepted, automatically changes your Ruby environment to 1.9.2 every time you access that directory.

### POW!
[Pow](http://pow.cx/ "Pow") is a zero-configuration Rack server that runs on Mac OS X and makes running Rails and Ruby applications a breeze. It also works smashingly with Octopress. Once POW is installed all you need do is create a symbolic link to your Octopress installation and you can start viewing your site at **yourdomain.dev**. Well worth the very few minutes it takes to download and install POW.

Having POW installed and setup for my site made tweaking and testing the theme and migrated postings far easier and quicker.

### Markdown
[Markdown](http://daringfireball.net/projects/markdown/ "Markdown") is John Gruber's text-to-HTML conversion tool. It allows you to write plain text files that are easily converted to syntactically correct HTML documents. After just a couple days use I find writing in Markdown to be quick and easy. I should have taken the Markdown plunge years ago.

### Rakefile to the Rescue
Octopress is a framework around [Jekyll](http://jekyllrb.com/ "Jekyll") and one of the features it adds is a [Rakefile](http://en.wikipedia.org/wiki/Rake_(software) "Rakefile") with helpful tasks predefined. The first rake task you'll make use of, {% codeblock %}rake install {% endcodeblock %} installs the default Octopress theme. There are also tasks to generate your site, deploy it (via rsync), and to create new pages or posts. 

## Getting Started
Follow the steps outlined on the [Octopress](http://octopress.org "Octopress") site and you should be up and running in a few minutes. If you get stuck, the developer Brandon Mathis is very responsive in the [Convore](https://convore.com/octopress/ "Convore") based support forum.

Octopress allows you to self-host your site or make use of Github to host it. In my case I wanted to self-host, and I wanted to alter the base theme a bit to suit my own tastes. As themes go the included default theme is nicely proportioned; best of all it is HTML 5 based and is mobile aware, meaning it works well on full-sized LCD screens as well as tablet or phone sized devices. Octopress does a good job of providing exits where you can override or customize the theme settings to suit your site's needs. More on that in a bit.


## Migrating from WordPress
The biggest concern for me was migrating my WordPress content to Markdown files. There are a number of scripts available to accomplish this task, some that access the database directly and others which work against the XML file resulting from exporting your site from WordPress. I opted for a script that worked against the XML export, and over the course of several iterations modified it to suit my needs. Specifically there were three things I wanted to accomplish in addition to converting everything into .markdown files:

1. Some of my postings date back to 1999 and were created by hand. Others came into existence while I was using Blogger in the early 2000s. Later I moved to a self-hosted instance of MoveableType, and finally I settled on WordPress. Each of these eras produced content that looked the same but often times had different character encodings.

2. Also, I had amassed a huge number of categories over the years and I wanted to once and for al pair that down to a more reasonable set of about a dozen.

3. And finally I wanted to identify some entries as regular postings and others as link postings. 

In addition to converting the postings, I wanted to capture the comments. My site doesn't generate a lot of comments (187 since 1999) but I didn't want to lose them. Octopress makes use of [Disqus](http://disqus.com/ "Disqus"), and Disqus made it easy for me to migrate the comments.

### Encoding
Solving the encoding riddle was easy, once I knew it needed to be solved. After the initial conversion of my entries, when I'd generate the Octopress version of my site there were four error messages indicating that [Liquid](http://wiki.shopify.com/UsingLiquid "Liquid") (the tag library used to assemble the pages) didn't like finding ASCII-8BIT and UTF-8 encoding in the same file. Of course the Liquid error message didn't indicate _which_ files, and I had over 1700 I was converting. At first I was content to ignore those messages, especially since my site looked okay and all the postings I spot checked were fine. It wasn't until I tried to access the Archives page that I realized something was amiss. 

The Archives page just showed the underlying Liquid tag markup, it wasn't showing the archives. Putting two and two together I realized that the files which weren't converting to Markdown properly were causing the Archives page to fail. After examining the files using variations of this command: {% codeblock %}find . -type f -exec file "{}" \; | grep [-v] [ASCII | HTML | SMGL | UTF-8]{% endcodeblock %} I realized I'd need to find a way to re-encode everything in UTF-8 for things to work properly. Fortunately Ruby 1.9.2 provides an encoding() that made this easy to accomplish. The find command given above won't run as written. I've indicated places where I added or subtracted options and arguments with square brackets ([]).

### Categories and Posting Types
It was also rather easy to add a case statement to the script that would keep some categories and default all others to a generic "life" category. This case statement was also used to identify those postings I wanted to display as a link and not as a regular posting.

You can view my script below.

{% gist 1133266 %}

Please feel free to download this script and extend it for your own use. I got it from another gist which I can unfortunately no longer find.

### Script Update
Since originally posting my script on Github, and starting to draft this posting I've had to modify it. The original script failed to handle pre and code tags very well. In fact it out-and-out eliminated all pre blocks entirely. While I spot checked my site, I didn't think to check postings that made use of those tags. It wasn't until a reader kindly added a comment to one of the most [popular postings](http://zanshin.net/2009/09/07/installing-postgresql-on-mac-10-6-snow-leopard/ "Installing PostgreSQL on Mac 10.6 Snow Leopard") on this site that the command line sections were missing that I realized I had a problem. The script shown above *does* convert pre and code blocks. As with any script you find on the Internet you should test it carefully and be prepared to modify it as needed to suit your needs.

### Disqus
I had already created a Disqus account so that I could comment on Disqus enabled sites. Adding my site to my account was simple and straight forward. Next I added the Disqus WordPress plugin to the WordPress instance of my site and exported all comments to Disqus. With as few comments as I have this only took a few minutes. Enabling Disqus in Octopress is a simple as adding your site's shortname to the _config.yml file. As long as the postings keep the same URL, the comments appear as if by magic. 

## Testing and Development
With postings in hand and the base theme to work from I spent several days making the theme my own. I quickly discovered that generating a site with over 12 years worth of history and nearly 1800 postings takes a while. On average my 2.66GHz MacBookPro takes six and a half minutes to generate my site. Not something you want to wait for if you are making dozens of little changes you want to see right away. I created a __drafts_ directory and parked all my original postings there during the time I used to tweak the theme. Once I had things more or less where I wanted them, I copied the entries back into the __posts_ directory and viewed the site in its entirety.

After reading through the Rakefile I discovered that there are two rake tasks designed to help with long generation times. {% codeblock %}$ rake isolate{% endcodeblock %} sequesters all postings except the one you name in a _stash directory, making generation times speedy again. {% codeblock %}$ rake integrate{% endcodeblock %} returns the isolated postings to their _posts home.

Thanks to POW I was able to make changes, generate the site, and see the changes rapidly. 

## Deploying
Up to this point in my process all the work was being done on my local machine. My WordPress site continued on blissfully unaware of its limited shelf live. Decommissioning the WordPress instance and enabling the Octopress instance had the potential for the greatest impact should something go wrong. Here are the tasks I identified for this step of the process:

* Copy all images from the /images directory on the old site to the /images directory for Octopress. (In hindsight I may have orphaned some images by not examining the media storage area of WordPress. Whoops.)
* Grab the site's favicon and put it at the root of the new site
* Modify the custom/head.html file to include 
* * Any meta tags and data I wanted
* * The link to Mint, my visitor tracking system

### Mint
Under WordPress, [Mint](http://haveamint.com "Mint") was installed in its own directory at the root of my site. This won't work with an out-of-the-box Octopress (or Jekyll for that matter) installation. The **rake deploy** command uses _rsync_ to copy the site from the local machine to the host server, and that command employs the --delete option. If Mint were installed in the site's root it'd get wiped out each time the site was deployed.

Fortunately it is possible to install Mint in its own sub-domain and track activity on all sibling sub-domains and the parent domain. Once the new sub-domain was established I copied my Mint directory to its new home, and then accessed Mint using the **?moved** query parameter to let it know it had been moved. I also had to wipe out all Mint cookies. 

### Decommissioning WordPress
There are steps available on the WordPress support pages for how to move a WordPress site. Doing this would allow you to keep accessing the (now stagnant) WordPress version of your site. I opted to work without that safety net and just created a new folder on my host server where I copied all the files and directories of my WordPress instance. The WordPress database is still up and running, so if I really need to go back for any reason I believe I can. It's been several days now and with no appreciable problems I don't anticipate ever needing the old instance again.

### Deploy
With WordPress safely copied elsewhere, my images all migrated, and Mint working smoothly in its new sub-domain, I was ready to run **rake deploy** for real. Roughly 60 hours of work spread over 10 days was coming down to a single command. Imagine my dismay to discover that my hosting provider was at that moment having issues with secure shell access, meaning my deployment failed. And continued to fail for the next 15 minutes. Since I had only copied the WordPress site to it's archive location visitors were still seeing everything. The only thing I'd lose by a delay might be a new comment, but those are rare here so I wasn't overly concerned. 

Once [Bluehost](http://bluehost.com "Bluehost") had ssh up and running again I was able to run the deploy and see my site, clad in its new theme, being served as a collection of static pages.

## Statistics
It takes 6 minutes and 30 seconds on average to generate my site. There are 1772 postings, which (along with various image files) generates some 19.221 files. This includes all the "older" pages, all the archive pages, and a few error document handler pages. For the really nerdy among you, here's the command I run to count all the files: {% codeblock %}ls -aRF | wc -l{% endcodeblock %} This counts all files, recursively, from the directory where it is run.

## Aftermath
This has been an immensely fun project for me. I've wanted to tinker with my website for some time now but learning PHP (the _lingua franca_ of WordPress) isn't something I want to do. While I have had some limited success in modifying or extend WordPress themes I was largely frustrated with the entire customize or build-your-own theme experience with WordPress. 

While I wouldn't recommend Octopress or Jekyll for anyone who wanted a weblog on their site, I do recommend it if you like to tinker and hack at things and want a site that statically served and not dynamically created through database queries.

If you have any questions about my migration experience please leave a comment below or contact me via the [interact](http://zanshin.net/interact/ "Interact") page.