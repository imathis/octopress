--- 
layout: post
title: Using Synergy Over a Secure Connection
date: "2009-12-10"
comments: true
categories: life
link: false
---
At work I now have four computers and five screens, all controlled from one keyboard and mouse. Here's how I did it.
## Hardware
The primary machine at work is a Mac Pro running Mac OS X 10.6.2 with 2 x 2.66 GHz Dual-Core Intel Xeon processors, and 4 GB of 667 MHz DDR2 RAM. This machine has two 20" Apple Cinema displays attached to it, and an <a title="Apple Keyboard" href="http://store.apple.com/us/product/MB110LL/A?fnode=MTY1NDA1Mg&amp;mco=MjE0Njk1Ng" target="_blank">Apple Keyboard</a> and an <a title="Apple Mighty Mouse" href="http://store.apple.com/us/product/MB112LL/A?fnode=MTY1NDA1Mg&amp;mco=MzE3MDA2Mw" target="_blank">Apple Mighty Mouse</a>. This machine is called Palantir.

The work supplied laptop is a 15" MacBook Pro also running Mac OS X 10.6.2 with a 2.4 GHz Intel Core 2 Duo processor and 2 GB of 67 MHz DDR2 RAM. This machine is called Orthanc.

The final machine in the mix is my personal MacBook Pro running Mac OS 10.6.2 on an 2.66 GHz Intel Core 2 Duo with 4 GB of 1067 MHz DDR3 RAM. This machine is called BlackPerl.

I also have a Dell Precision 390 running Windows 7 Professional, it has an Intel Core2 Quad CPU running at 2.4 GHz, and 2 GB of RAM. It's called Khazad-dum. This machine doesn't actively participate in the Synergy setup, it's accessed via Remote Desktop from my Mac Pro.
## Software
According to their web site, <a title="Synergy" href="http://synergy2.sourceforge.net/" target="_blank">Synergy</a>
<blockquote>... lets you easily share a single mouse and keyboard between multiple computers with different operating systems, each with its own display, without special hardware. It's intended for users with multiple computers on their desk since each system uses its own monitor(s).</blockquote>
In addition to Mac OS X, Synergy supports Windows (95 through XP), and Unix, Linux, and Solaris.
## Setup
Synergy consists of two parts, a server (the machine with the keyboard and mouse) and one or more clients (those machines you wish to control through the same keyboard and mouse). The server machine utilizes a configuration file to describe the geometry of your various computers. In my case I have things arranged like this, from left to right, on my desk:
<ul>
	<li>BlackPerl (Personal MBP)</li>
	<li>Palantir (Mac Pro)</li>
	<li>Orthanc (Work MBP)</li>
</ul>
So my Synergy configuration file looks like this:
{% codeblock %}# synergy configuration file

section: screens
	# three hosts:
	#	Palantir (Mac Pro)
	# 	Orthanc (MacBook Pro)
	#	BlackPerl (MacBook Pro)
	#
	# arranged from left to right: BlackPerl : Palantir : Orthanc
	#
	BlackPerl:
	Palantir:
	Orthanc:
end

section: links
	# Palantir is to the right of BlackPerl
	BlackPerl:
		right = Palantir
	# BlackPerl is to the left of Palantir,
	# Orthanc is to the right of Palantir
	Palantir:
		left = BlackPerl
		right = Orthanc
	# Palantir is to the left of Orthanc
	Orthanc:
		left = Palantir
end

section: aliases
	# Palantir has an alias
	Palantir:
		localhost
end

section: options
	# use control+alt+# to hop to screen directly
	# 1 = BlackPerl
	# 2 = Palantir
	# 3 = Orthanc
	keystroke(control+alt+1) = switchToScreen(BlackPerl)
	keystroke(control+alt+2) = switchToScreen(Palantir)
	keystroke(control+alt+3) = switchToScreen(Orthanc)
end{% endcodeblock %}
This configuration is saved in my home directory as <strong>.synergy.conf</strong>.

While you could manually start the server each time you wanted to use Synergy, a better solution is to have it started automatically each time the computer is restarted or booted. Using <a title="Lingon from Sourceforge" href="http://sourceforge.net/projects/lingon/files/" target="_blank">Lingon</a> I was able to create a launchd plist for Synergy that starts the server component automatically. My net.sourceforge.synergy2.plist looks like this:

<img class="aligncenter size-full wp-image-2197" title="synergy2" src="http://zanshin.net/wp-content/uploads/2009/12/synergy2.png" alt="synergy2" width="554" height="401" />Once this file is created, Synergy will start automatically every time the machine is booted. This creates the server necessary for Synergy to work.

On each client machine I added a function to my .bashrc file to create a secure shell connection to the machine with the Synergy server, in my case called Palantir. The function looks like this:
{% codeblock %}function pssh() { ssh -L 24800:localhost:24800 userid@palantir.example.com }{% endcodeblock %}
What is happening here is that port 24800 on the local machine is being forwarded to the same port on the remote machine (Palantir). All traffic to port 24800 will be encrypted and passed along to the other machine.

In addition to that function, each client machine also has a second .bashrc funtion called syn, that starts the Synergy client over the port forwarding created by the first function. It looks like this:
{% codeblock %}function syn() { /Users/username/bin/synergy-1.3.1/synergyc -f --name clientName localhost }{% endcodeblock %}
This function starts the Synergy client (synergyc) and names the client machine (--name clientName) and points it at localhost as the server. Since the Synergy port (24800) is port forwarded to the server machine, pointing the client at localhost works.
## How to Use
With the Synergy server always running on my Mac Pro it is easy to start Synergy on both client machines. I open up a new Terminal tab and run the port forwarding function first (pssh). This function results in your being signed into the server, and this connection must exist in order for Synergy to work.

Next, open a new tab, which will give you a prompt on the client machine, and run the syn function to start the Synergy client. This tab will record the output generated by Synergy as you move into and out of the client via the host's mouse.

I have discovered that Synergy is persistent; as long as the client is running and the port forwarding exists your client machine will respond to actions happening on the server. For example: if I take one of the laptops to a meeting without breaking the Synergy connection, and the screen saver starts on the server, the screen saver will be activated on the client too. This is a very minor downside as it is easy to Cmd-Tab to the Terminal instance with the Synergy tabs, and Ctrl-C out of the Synergy client and exit from the remote connection.
## Notes
Synergy seems to be a dead project. No updates have happened to its source in a long time. Also, this setup which worked flawlessly under Mac OS 10.4, and 10.5, seems to be a bit flakier under 10.6. If you aren't interested in this much effort to build a secure connection for Synergy you might want to look at <a title="Teleport" href="http://abyssoft.com/software/teleport/" target="_blank">Teleport</a>, an alternative for accessing multiple computers from one keyboard and mouse.

Also, the launchd plist creation software, Lingon, is no longer being supported either.
