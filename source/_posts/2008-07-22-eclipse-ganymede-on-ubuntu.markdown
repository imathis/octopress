--- 
layout: post
title: Eclipse Ganymede on Ubuntu
date: 2008-7-22
comments: true
categories: nerdliness
link: false
---
(These steps assume you already have a version of Eclipse installed under /opt.)

1. Download Eclipse Ganymede
2. Untar the downloaded file.
3. Change to the /opt directory.
4. Rename the previous /opt/eclipse installation.
5. Move the ganymede folder to /opt.

Like this:
{% codeblock %}
$ wget http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/ganymede/R/eclipse-jee-ganymede-linux-gtk.tar.gz 

$ tar xzvf eclipse-jee-ganymede-linux-gtk.tar.gz 

$ cd /opt 

$ sudo mv eclipse eclipse-europa 

$ sudo mv ~/eclipse . 
{% endcodeblock %}

You should now be able to launch Eclipse Ganymede using the same shortcuts or scripts as before.

