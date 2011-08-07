--- 
layout: post
comments: "false"
title: Secure E-Mail via ssh
date: "2003-12-19"
link: "false"
categories: nerdliness
---
In my quest to have total mobility with my Powerbook I have finally found a solution that allows me to access my mail regardless of any firewalls imposed by my connection location.

Using ssh, which I talked about previously <a href="http://zanshin.net/blogs/000232.html" target="ssh">here</a> and <a href="http://zanshin.net/blogs/000290.html" target="ssh part 2">here</a>, I forwarded the POP (110) and SMTP (25) ports on my laptop through a tunnel inside the secure shell (ssh) connection. The ports are (hopefully) resolved at the remote server and any requests for ports 25 or 110 on my laptop pass-through the tunnel and "execute" on the remote server.

I have three perl scripts for establishing a ssh connection and forwarding ports: work, home, and remote. The first, called "work", connects to my Windows NT workstation. This machine is logged into the network and can ssh out of the client network to the internet at large. All the forwards in my work script are replicated on the NT box. The ssh script on NT connects to a Linux server, outside the local firewall, with a HTTP proxy server, and open POP and SMTP ports. The work ssh command looks like this:

ssh -L25:localhost:25 -L110:localhost:110 -L8080:localhost:8080 -luserid host -N -f

The port forwards, indicated by the '-L' parameter setup a listener on each port listed (25, 110, and 8080) and pass any requests to those ports to the proxy named 'localhost' on the remote machine, named 'host'.

The '-l' parameter indicates the user id I wish to use for this connection, and 'host' is the name or IP address of the remote server I wish to access.

The '-N' parameter causes no remote command to be executed. I don't really understand this parameter, except to say that it is supposed to be good for port forwarding.

The '-f' parameter cause the ssh process to goto background as it runs, freeing up the shell used to start it. More on this later.

On the NT box the ssh command looks like this:

ssh -L25:relay.hostname.com:25 -L110:mail.hostname.com -L8080:localhost:3128
-luserid remoteHost.com

Here I am forwarding the POP and SMTP ports to the hostname that is my mail server. Your name will obviously be different. HTTP (8080) is forwarded to a HTTP proxy running on the remote server itself. In effect the forwards for 25 and 110 say, don't access these ports here on the NT machine, instead follow the ssh connection and resolve them there. This gets me outside the firewall and my mail servers are now visible. (I'm actually using putty on my NT box, so the command isn't visible.)

My mail account settings have to be changed to take advantage of these port forwards. Specifically I removed the existing POP and SMTP server settings and replaced them both with '127.0.0.1', which is the localhost address of my machine. Now when the e-mail client accesses either POP or SMTP the request is forwarded through the ssh connection to be resolved at the remote host. Viola, secure (encrypted) e-mail access from behind a firewall.

The second script, called "home" is used while I am at home, connecting though my broadband modem. I don't need to forward ports and secure shell from home but, since my mail accounts have all been setup to point to 127.0.0.1, not using a script would require changing them each time I came home. Using the script allows those settings to remain unchanged.

Since this script only needs to create a port forward, the remote host I connect to is myself. Like so,

ssh -L25:relay.hostname.com -L110:mail.hostname.com -luserid -N -f 127.0.0.1

Same as the work script, but I don't need to forward HTTP requests, and I am connection back to myself. My machine has an open connection to the internet that allows for POP and SMTP, this script exists just to capture requests from my mail client and pass them on to the appropriate servers.

The final script, called "remote" combines the work script, and the ssh command issued in my NT box. This script is useful when the internet connection available has a firewall, but I don't need to be logged in as I do at work. The command looks like this:

ssh -L25:relay.hostname.com:25  -L110:mail.hostname.com:110
-L8080:localhost:3128 -N -f remoteHost

Here I am forwarding HTTP, POP, and SMTP requests through a machine outside any local firewalls.


Because I used the '-f' parameter in my ssh command, the ssh process happens in the background, freeing up the shell used to start it. This is nice and tidy, but switching from home to work, or work to remote, requires that you first shut down any existing ssh processes. The actual perl script has two more lines to it that find and kill any running ssh connections. They look like this:

#!/usr/bin/perl
open (PS, "ps auxw | grep \'ssh -L\' | grep -v grep | awk '{ print \$2 }'|");
while (<PS>){ chop; system ("sudo kill -9 $_");}

I'm not a perl coder by any stretch, but I understand the first line to be collecting all the process ids of running ssh connections. The second line then kills these processes. The final line of each script is the ssh command itself, as described above.

I know this seems complex and it is, but in a good geeky way. I'm happy, and I get my e-mail (thru an encrypted link) regardless of where I connect from.
