--- 
layout: post
title: ssh, part II
date: "2003-10-20"
comments: true
categories: nerdliness
link: false
---
<a href="http://zanshin.net/blogs/000232.html">Once upon a time</a> I wrote about using ssh to connect to a server outside of the restrictive environment at my primary client site. Since that time I have been happily connecting from my laptop, which isn't logged into the LAN, to my NT workstation, which is logged in, and from the NT workstation to a server out in the wilds of the internet.

Originally I was using a fine piece of software for the ssh connection and subsequent TCP/IP tunnel called 'SSHTunnelManager.' A fairly straight forward user interface made it easy enough for me to create the necessary port forward to allow my laptop to connect to the open ssh process running on the NT workstation.

However, I recently learned about scp, or secure copy, on Unix and wanted to be able to use it to move files to and from my laptop. In order for this gem to work I needed to forward port 22 through the tunnel. SSHTunnelManager has one flaw, it doesn't allow forwarding of ports owned by root, or in other words, any port numbered 1024 or less.

So I resorted to using the command line interface (terminal) and a command like this to make my secure connection and necessary port forwards:

{% codeblock %}
sudo ssh -C -l<i>userid</i> -L22:localhost:22 -L8080:localhost:8080 10.21.85.76{% endcodeblock %}

The breakdown goes like this:

<strong>sudo</strong> allows the command that follows to be run as if you were logged in as root. You supply your password, and provided your ID has administrator access, the command runs.

<strong>ssh -C</strong> run the ssh command, and the first option is '-C' or compress all traffic. Should get some performance gain from this.

<strong>-l<i>userid</i></strong> the id on the remote system you want to log in using

<strong>-L22:localhost:22</strong> forward local port 22 to the remote system and once there resolve it as localhost:22. (remember in my case the remote system has another set of forwards to a server beyond the firewall.)

<strong>-L8080:localhost:8080</strong> again forward local port 8080 to the remote system and once there resolve it as localhost:8080.

<strong>10.21.85.76</strong> the IP address of the remote system I wish to log in to using the userid specified in the '-l' parameter.

So that I don't have to type this command every time I wish to connect I created an alias in my <strong>.tcshrc</strong> file, like this:

<strong>alias remote 'sudo ssh -C -l<i>userid</i> -L22:localhost:22 -L8080:localhost:8080 10.21.85.76'</strong>

Now I just open a terminal window and type 'remote' to connect. I'm prompted for my administrator id first (from the sudo command) and then for my login password on the remote server.

Now I have full HTTP and HTTPS browsing and scp ability from my laptop.
