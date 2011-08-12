--- 
layout: post
title: Managing ssh keys
date: 2009-10-9
comments: true
categories: nerdliness
link: false
---
Earlier this evening, while not paying close enough attention to what I was doing, I managed to delete some semi-important files on my desktop at work. The error happened because I was remotely logged in via the command line and wasn't paying attention to which machine I was actually working against. My error is recoverable but it gives me new respect for the working environment system administrators live in day in and day out.

The files I deleted where the public and private key pair that uniquely identify my work desktop, and the list of public keys my work desktop has added to its authorized keys list. No real harm done except that now when I try to remotely login to that computer I have to enter the password. I decided to start over and document the process so I can perform it again in the future, if need be.
## Step One
Generate a key pair on each machine you regularly use. In my case I have two work computers, a desktop called Palantir and a laptop called Orthanc, and two personal computers, both laptops, called Eeyore and Tigger. On Unix based systems run the ssh-keygen command to create a new public and private key pair. Like this:
{% codeblock %}$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/mhn/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/mhn/.ssh/id_rsa.
Your public key has been saved in /Users/mhn/.ssh/id_rsa.pub.{% endcodeblock %}
The id_rsa file is my identification and private key. The id_rsa.pub file is my public key. In order to make copying the public key to other machines easier I made a copy of the id_rsa.pub file on each machine, using the machine's name as a unique identifier.
{% codeblock %}$ cp id_rsa.pub machineName.pub{% endcodeblock %}
## Step Two
Next I copied the public keys from each machine into a folder in my Dropbox:
{% codeblock %}$ cp .pub ~/Dropbox/public_keys/{% endcodeblock %}
Since I can access my Dropbox from all of my machines, and since the key files are named for the machine they represent, this is a elegant way to house them centrally. You could also use scp (secure copy) to accomplish the same thing:
{% codeblock %}$ scp machineName.pub you@othermahince.com:~/.ssh{% endcodeblock %}
## Step Three
Once you have the key files on the remote machine or in  your Dropbox, ssh (secure shell) into that machine and change to the .ssh directory.
{% codeblock %}$ ssh you@remoteMachine.com
Password:
$ cd .ssh{% endcodeblock %}
Make sure the authorized_keys file exists in the .ssh directory using the touch command.
{% codeblock %}$ touch authorized_keys{% endcodeblock %}
Concatenate the public key from the other machine to the authorized_keys file,
{% codeblock %}$ cat machineName.pub >> authorized_keys{% endcodeblock %}
Repeat the concatenation for each machine you want access this computer from remotely.
## Step Four
There is no step four. You're done.
## Step Five
I also used the named public key files to allow password-less access to my bitbucket account.

<strong>NB:</strong> These steps worked for me. You should probably read more about <a title="Quick Logins with ssh Client Keys" href="http://oreilly.com/pub/h/66">ssh keys</a>, <a title="Copying Files with scp" href="http://www.lesbell.com.au/Home.nsf/b8ec57204f60dfcb4a2568c60014ed0f/04eaff076bce249dca256fb6007f53e5?OpenDocument">scp</a>, and <a title="Secure Shell" href="http://en.wikipedia.org/wiki/Secure_Shell">ssh</a> before attempting to follow them. Especially if you've never done this before.
