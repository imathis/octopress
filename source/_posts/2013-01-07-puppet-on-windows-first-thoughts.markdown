---
layout: post
title: "Puppet On Windows: First Thoughts"
date: 2013-01-07 20:46
comments: true
categories: [windows, puppet, vagrant, veewee]
---
One of the things I didn't expect when changing jobs was the amount of Windows Infrastructure I would be responsible for. While not expected, it will be an interesting challenge and is still very much a WebOps and not an enterprise Windows deployment. As we move forward with this infrastructure, there is a huge desire to puppetize it and manage it in a programatic way.

## Setting Up a Dev Environment

As a long time Vagrant user and abuser, I started with attempting to setup a base box using Veewee and Vagrant. This was met with disaster. None of the templates I tried worked and, really, vagrant isn't designed to handle Windows. But failure of this kind always seems to open new doors.

So, I cheated a bit. The veewee template left behind a floppy image with all the of the autounattend.xml stuff rolled inside. I created a new VM in VirtualBox, added a floppy controller, the virtual floppy disk and the Windows 2008 R2 iso. A few minutes later, I had a fully installed Windows 2008 R2 instance.

From there, I shared a folder with my Puppet manifests and modules, installed [Puppet](http://puppetlabs.com/misc/download-options/) and the VirtualBox Guest Additions. At this point, I took a snapshot so I can easily revert back to where I started.

## Out with the Package

So, what is the first thing you want to do when setting up a web server? Install the web server software, right? On a Linux box this looks something like:
{% codeblock lang:puppet %}
package {"httpd":
  ensure => installed,
}

service {"httpd":
  ensure  => running,
  require => Package['httpd'],
}
{% endcodeblock %}

Simple enough, right? So I set out to figure out how to install IIS. The first thing I looked for was a built-in type to handle setting up server roles and features. Nada. So off to the [Forge](http://forge.puppetlabs.com) I went. I found an amazing [IIS](http://forge.puppetlabs.com/simondean/iis) module written by [Simon Dean](https://github.com/simondean). The only problem with it, it doesn't install IIS.

## Enter DISM

DISM or Deployment Image Servicing and Management is where the heavy lifting gets done. {{dism}} is the command line tool that allows you to install roles and features, just like you would from the Server Manager GUI. I owe a huge thanks to [Mark Bools](https://twitter.com/markbools) for helping shine the light on DISM with a [blog post](http://blog.principia-it.co.uk/2012/10/17/puppet-and-windows/). To get started with dism in puppet, Puppet Labs has published the [dism module on the forge](http://forge.puppetlabs.com/puppetlabs/dism) that has a type and provider to work with. To get a list of things that can be installed with dism you can run, {{dism /online /Get-Packages}}. From there, you can use the dism type to install the needed packages. This looks something like:
{% codeblock lang:puppet %}
dism { 'IIS-WebServerRole':
  ensure => present,
}

dism { 'IIS-WebServer':
  ensure  => present,
  require => Dism['IIS-WebServerRole'],
}
{% endcodeblock %}

## General Observations

In general, things worked as expected. Puppet does not seem to care whether the manifests have Windows or UNIX line endings which is very nice. The only thing I have found so far that didn't, "just work," was the module tool, otherwise things translate just fine. The big issues left to deal with are not ones that are easily solved by puppet. There are reboots that need to take place as part of basic installations that really don't lend themselves well to configuration management as a whole. 