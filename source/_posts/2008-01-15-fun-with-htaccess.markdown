--- 
layout: post
title: Fun with .htaccess
date: 2008-1-15
comments: true
categories: life
link: false
---
Recently I have made good use of the Apache .htaccess file to redirect and rewrite URL's to keep visitors from getting page not found errors.  Moving three domains, creating a subdomain or two, and then moving things around again, has created ample opportunity for lost visitors.

There are lots and lots of pages in the Google search results for ".htaccess," so here are my notes, all in one place, for your reading pleasure.

<strong>Redirect visitors from an old site to a new site</strong>
<blockquote>RewriteEngine On
RewriteBase /
RewriteCond %{HTTP_HOST} !www.newsite.com$ [NC]
RewriteRule ^(.*)$ http://www.newsite.com/$1 [L,R=301]</blockquote>
<ol>
	<li><strong>RewriteEngine On</strong> is required to make all the following lines work.</li>
	<li><strong>RewriteBase /</strong> indicates we want to work within the current directory</li>
	<li><strong>RewriteCond %{HTTP_HOST} www.oldsite.com$ [NC]</strong> defines the condition the rule(s) should be run under.  In this case we are saying the when the entered URL is not (<strong>!</strong>) www.newsite.com.  The <strong>[NC]</strong> makes the condition not case sensitive.</li>
	<li><strong>RewriteRule ^(.*)$ http://www.newsite.com/$1 [L,R=301]</strong> is the actual rule to be run when the above condition is met.  The <strong>^</strong> and <strong>$</strong> define the beginning and ending of the URL the visitor has typed.  The period (<strong>.</strong>) indicates any character in a regular expression, and the splat (<strong>*</strong>) says any number of characters.  The visitor is sent to <strong>www.newsite.com</strong>, and anything typed in addition to the base domain is appended to www.newsite.com via the <strong>$1</strong>.  <strong>[L,R=301]</strong> says that when this rule is executed is should be the <strong>l</strong>ast rule run, and that the <strong>r</strong>edirect should be considered permanent <strong>(301</strong>).</li>
</ol>
<strong>Redirect visitors from a subdomain to a parent domain</strong>
<blockquote>RewriteEngine On
RewriteBase /
RewriteCond %{HTTP_HOST} subdomain.parentdomain.com$ [NC]
RewriteRule ^(.*)$ http://parentdomain.com/$1 [L,R=301]</blockquote>
<ol>
	<li>The only difference in this example is that the condition is looking for the subdomain, and the rule states the parent domain.</li>
</ol>
In both of the examples above, it is assumed that none of the pages within the site are changing their URL format.  The RewriteRule is merely appending the page specific portion of the URL to the end of the new URL.

<strong>Redirect visitors using .html links to .php links</strong>
<blockquote>RewriteEngine On
RewriteBase /
RewriteCond %{HTTP_HOST} !newdomain.com$ [NC]
RewriteRule ^(.*)\.html$ http://newdomain.com/$1\.php [L,R=301]
RewriteRule ^(.*)\.php$ http://newdomain.com/$1\.php [L,R=301]
RewriteRule ^(.*)$ http://newdomain.com/ [L,R=301]</blockquote>
<ol>
	<li>The example above not only redirects visitors from the old site to the new, it rewrites any links entered ending with .<strong>html</strong> to end with .<strong>php</strong>.</li>
	<li>Also the last rule, <strong>RewriteRule ^(.*)$ http://newdomain.com/ [L,R=301]</strong>, ensures that any visits to the root domain will be properly redirected.  The two preceeding rules only catch URL's entered that have a page link specified.</li>
</ol>
<strong>Redirect visitors with old URL format to new URL format</strong>
<blockquote>RewriteEngine on
Redirect 301 /resume.php http://markhnichols.com/
Redirect 301 /blogs/cat_life.html http://zanshin.net/category/life/
Redirect 301 /blogs/001398.html http://zanshin.net/2007/12/29/moving/</blockquote>
When you change the format of the URL link (beyond just changing the link type as in the previous example) you could do it as I have above.
<ol>
	<li><strong>Redirect 301 /resume.php http://newdomain.com/</strong> redirects visitors looking for my resume at my old site to its new location at a new site entirely.</li>
	<li><strong>Redirect 301  /blogs/cat_life.html http://zanshin.net/category/life/</strong> redirects visitors looking for a category page using the old location (<strong>/blogs/cat_life</strong>) to its new home (<strong>http://zanshin.net/category/life/</strong>).</li>
	<li> <strong>Redirect 301 /blogs/001398.html http://zanshin.net/2007/12/29/moving/</strong> redirects visitors using a old link to a posting (<strong>/blogs/001398.html</strong>) to its new location (<strong>http://zanshin.net/2007/12/29/moving/</strong>).</li>
</ol>
I make no guarantees about your success using my examples.  These redirects work for me, your mileage may vary, void where prohibited, for external use only, and see your doctor.
