--- 
layout: post
title: Sharing iTunes Beyond Your Subnet
date: 2009-2-5
comments: true
categories: life
link: false
---
iTunes allows you to share your music library with other computers based on the same subnet of your network. Network addressing is too arcane a subject for this posting, but a simplified explanation will help. Each computer on a network gets a unique address, know as an IP address. (IP stands for Internet Protocol.) IP addresses have four sets of numbers, separated by a dot, e.g., 192.168.101.10. For licensing reasons Apple restricts the sharing of music to computers that have identical addresses except for the last portion of the IP address. If your computer has an address of 198.162.101.1, then any computer with an address of 192.168.101.* can receive your shared music.

Currently I have a situation where I'd like to share my music to a computer that isn't on the same subnet. It turns out this is possible, if a bit cumbersome. I'm basing my instructions below on the much more detailed instructions I found the <a title="SSH Tunnel MtdWiki" href="http://wiki.mt-daapd.org/wiki/SSH_Tunnel" target="_blank">SSH Tunnel MtdWiki</a>.  

Make sure you can establish a secure shell (ssh) connection from the client (listening) computer and the server (playing) computer. Open Terminal and type
{% codeblock %}ssh userid@192.168.1.1{% endcodeblock %}
where userid is the user account you have on the computer you'll be using as the server. And where 192.168.1.1 is the IP address that machine has.

If this works then you are ready for the next step. If it doesn't work, you'll need to visit the Sharing preference pane (for Mac OS X 10.4.x) and make sure that Remote Login is enabled. While you are there, make sure that iTunes Music Sharing is also enabled.

Step two is to create a secure shell tunnel between the listening computer and the playing computer. One of the more useful features of ssh tunnels is the ability to forward a port from one computer to another. Services that listen to or respond at specific ports can be forwarded through a ssh tunnel to remote machines. iTunes uses port 3689 for sharing music. We want to establish a tunnel between our two computers that ties port 3689 on the listening computer to port 3689 on the playing computer. Something like this:
{% codeblock %}ssh userid@192.168.1.1 -N -f -L 3689:192.168.1.1:3689{% endcodeblock %}
Here's a breakdown of the command:

<span style="font-family: 'Courier New'; line-height: 18px; white-space: pre;"><strong>s</strong></span><strong>sh userid@192.168.1.1</strong> is the normal secure shell login command. The <strong>-N</strong> flag makes it a non-interactive session, and the <strong>-f</strong> flag causes the whole command to run in the background, both of which free up your command line for other activities. The <strong>-L</strong> flag establishes the port forwarding from port 3689 on the listening machine to the same port on the playing machine.

Next you will need to install a <a title="Network Beacon" href="http://www.chaoticsoftware.com/ProductPages/NetworkBeacon.html" target="_blank">Network Beacon</a>, which allows iTunes to see the DAAP port (3689). The one I used is freely available from <a title="Chaotic Software" href="http://www.chaoticsoftware.com/" target="_blank">Chaotic Software</a>. Since iTunes is geared to only "see" shared music from the same subnet, you need something to act as a proxy for the remote server. In this case Network Beacon acts as that proxy, allowing the copy on the listening machine to see the music on the playing machine through the secure tunnel and port forward we created above.

Here's an image of how to configure the beacon on the listening machine:

<img class="alignnone" src="http://zanshin.net/images/beacon.png" alt="" width="451" height="377" />

 

With the beacon enabled, and the tunnel established, start iTunes on your listening computer and wait a few moments while the shared library is populated under the "Shared" heading in the sidebar.
