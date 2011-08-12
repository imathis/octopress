--- 
layout: post
title: Eclipse Ganymede on Ubuntu
date: 2008-7-22
comments: true
categories: life
link: false
---
(These steps assume you already have a version of Eclipse installed under /opt.)

Step 1. Download Eclipse Ganymede:
<pre style="padding-left: 30px;">$ wget http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/ganymede/R/eclipse-jee-ganymede-linux-gtk.tar.gz{% endcodeblock %}
(NB: I'm using the J2EE version, adjust the download if you want a different install.)[1]

Step 2. Untar the downloaded file.
<pre style="padding-left: 30px;">$ tar xzvf eclipse-jee-ganymede-linux-gtk.tar.gz{% endcodeblock %}
Step 3. Change to the /opt directory.
<pre style="padding-left: 30px;">$ cd /opt{% endcodeblock %}
Step 4. Rename the previous /opt/eclipse installation.
<pre style="padding-left: 30px;">$ sudo mv eclipse eclipse-europa{% endcodeblock %}
Step 5. Move the ganymede folder to /opt.
<pre style="padding-left: 30px;">$ sudo mv ~/eclipse .{% endcodeblock %}
You should now be able to launch Eclipse Ganymede using the same shortcuts or scripts as before.

 

[1] The Eclipse package options are:

-jee- Java EE Developers

-SDK-3.4- Classic 3.4

-java- IDE for Java Developers

-cpp- IDE for C/C++ Developers
