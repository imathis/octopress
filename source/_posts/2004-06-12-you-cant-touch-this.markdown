--- 
layout: post
title: You Can't Touch This
date: 2004-6-12
comments: true
categories: life
link: false
---
Thanks to <a href="http://www.padawan.info/" title="padawan.info">padawan.info</a>'s <a href="http://www.padawan.info/weblog/preventing_image_hotlinking.html" title="preventing image hotlinking">preventing image hotlinking</a> article I now have protected to some degree my site's images.

The process is relatively simple, create a new .htaccess file for your images subfolder (you do have an images subfolder, right?) and paste the following code in it.
<pre>
RewriteEngine On
RewriteCond %{HTTP_REFERER} !^$
RewriteCond %{HTTP_REFERER} !^http://(www.)?zanshin.net(/)?.*$ [NC]
RewriteRule .*.(gif|jpg|jpeg|png)$ - [F,NC]</pre>
Cool.
