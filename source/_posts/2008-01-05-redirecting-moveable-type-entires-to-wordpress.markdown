--- 
layout: post
comments: "false"
title: Redirecting Moveable Type Entires to Wordpress
date: 2008-1-5
link: "false"
categories: life
---
One of the potential drawbacks to switching content management systems for my website was losing the permanent link to specific postings.  I receive a fair amount of traffic due to some Google searches, and I have posted comments on a couple of sites that generate a few links per week.  I didn't want to lose this traffic simply because the link had changed names.

In my case there were three issues I needed to address:
<ol>
	<li>I was converting the CMS back-end from Moveable Type to Wordpress.</li>
	<li>I was switching from a number based posting URL scheme to a "year / month / day / title" posting scheme.</li>
	<li>I was moving to a new host and I wouldn't have a Moveable Type installation on the new host.</li>
</ol>
Here's how I managed to create redirects for all 1330 of my Moveable Type entries.

If you search the Wordpress Codex you'll find an article about <a href="http://codex.wordpress.org/Importing_from_Movable_Type_to_WordPress" title="Importing From Moveable Type to Wordpress">importing Moveable Type entries to Wordpress</a>, which contains a section on Preserving Permanent links.  Using the template suggested in the article, I created a new Moveable Type template that output a line for each Moveable Type entry, like this:
<blockquote>&lt;?php
require('wp-config.php');
header('Content-type: text/plain');
?&gt;
&lt;MTEntries lastn="999999"&gt;
Redirect Permanent /archives/&lt;$MTEntryID$&gt;.html http://zanshin.net/blogs/&lt;$MTArchiveDate format="%Y/%m/%d"$&gt;/
&lt;?php echo sanitize_title("&lt;$MTEntryTitle$&gt;"); ?&gt;
&lt;/MTEntries&gt;</blockquote>
When I rebuilt the site, causing this template to be run, the resulting file had a line for each Moveable Type entry that looked something like this:
<blockquote>Redirect Permanent /blogs/######.html http://zanshin.net/yyyy/mm/dd/  &lt;?php echo sanitize_title("Title"); ?&gt;</blockquote>
If I had been just switching to Wordpress on the same host, I could have inserted this file in to my Wordpress directory and everything would have worked.  However, without the Moveable Type installation on the new server, I would have to do more.

What I needed was a pure .htaccess file to permanently redirect visitors to old URL to the new URL.  In order to do that I needed to strip out the php references and manually sanitize the titles. You see the URL scheme I had chosen for Wordpress uses a sanitized version of the posting title in the URL.  Quotes, dollar signs, exclamation points, parenthesises, et cetera, aren't allowed in these sanitized titles.

Making a backup of the redirect.php file the template code above had produced, I set out to accomplish this by hand.  (<strong>NB</strong>: I did try, through the help of a friend to use awk and regular expressions to automate the title sanitazation.  While this was largely successful, I ultimately ended up using a file I had converted in TextMate using a series of find and replace commands.)

The resulting file had 1330 lines that looked like this (and, yes, had I been quicker thinking I could have come much closer to this format with the template described above):

Redirect 301 /blogs/######.html http://zanshin.net/yyyy/mm/dd/title/

Points of interest in this format:
<ul>
	<li>The word "Permanent" has been changed to "301," which is the official designation for a permanent redirect on an Apache web server.</li>
	<li>The title must end with a "/"</li>
	<li>And all spaces in the title are replaced with "-"</li>
</ul>
You can see a text version of the <a href="http://zanshin.net/images/redirect.txt" title="redirect file from MT template">original file</a> as well as one of the <a href="http://zanshin.net/images/htaccess.txt" title="htaccess file">.htaccess</a> file now in effect on my site.

Upon loading this file to the root of my site on the new server I promptly got an internal server error (500), meaning that the .htaccess file had a mistake (or two or three).  I am not ashamed to admit that I used a brute-force method for finding the errors: I commented all 1330 lines out, and then in blocks of 100 lines each un-commented them and reloaded the site.  When it again threw the internal server error between lines 600 and 700, I knew where the problem was located.  Two lines had problems.  One was missing a "-" for a space, and the other was missing the closing "/" at the end of the URL.

Hopefully now people coming to my site via old links, be they from a search engine, an embedded link on another site, or a bookmark, they will be redirected to the new location of the page.
