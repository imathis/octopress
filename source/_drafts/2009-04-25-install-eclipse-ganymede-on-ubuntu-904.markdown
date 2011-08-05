--- 
layout: post
author: Mark
comments: "false"
title: Install Eclipse Ganymede on Ubuntu 9.04
date: 2009-4-25
categories: life
---
Previously I wrote about <a title="How to install Eclipse on Ubuntu 8.10" href="http://zanshin.net/2008/07/22/eclipse-ganymede-on-ubuntu/">installing Eclipse Ganymede on Ubuntu 8.10</a>, however retracing those steps wouldn't work for the latest Ubuntu release, as the Synaptic package doesn't end up in the /opt directory. However there is a very quick as easy way to get the latest Eclipse running on Jaunty Jackalope.
<ol>
	<li>Download your favorite Eclipse package from the <a title="Eclipse downloads" href="http://www.eclipse.org/downloads/">download site</a>.</li>
	<li>Expand the <strong>.tar.gz file</strong>, using <em>tar xzvf</em>. This will result in a directory called 'eclipse' containing the version you downloaded.</li>
	<li>Change to the <strong>/usr/lib</strong> directory</li>
	<li>Make a copy of the existing eclipse sub-directory: <strong>sudo mv eclipse eclipse-3.2</strong>. You'll need the <strong>startup.jar</strong> file contained here in step 6, so don't just throw this installation away.</li>
	<li>Copy the eclipse folder from step 2 to /usr/lib: <strong>sudo cp -Rf ~/eclipse .</strong></li>
	<li>Retrieve the startup.jar file from the previous installation: <strong>sudo cp ../eclipse-3.2/startup.jar .</strong></li>
</ol>
Now when you use the shortcut under Applications -&gt; Programming, you will get Eclipse 3.4 instead of Eclipse 3.2.
