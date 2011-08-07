--- 
layout: post
comments: "false"
title: Automatically Update Your Uptime In Wordpress
date: 2008-8-22
link: "false"
categories: life
---
Recently I read an article on how to capture, upload, and display your computer's uptime in the footer of your blog. <a title="Automatically update your computer's uptime on your website" href="http://www.wesg.ca/2008/06/automatically-update-your-computers-uptime-on-your-website/">Automatically update your computer's uptime on your website</a> does a very good job of laying out the basic techniques for accomplishing this, admittedly nerdy, task.  However, the original script uses FTP, or File Transfer Protocol, to move the formatted uptime information from your computer to your web site host. Using Secure Copy, or scp, would be a better solution.
## SCP
Secure copy, or scp, encrypts data being transfered so that man-in-the-middle attacks aren't possible.  I'll show you the original script, and then  my script which employs scp instead of ftp.  I'm also using a private-public key pair for authentication, so that there is no need for my host password to be either transmitted or stored in the script.
## The Original Script

As you can see, in the "upload to the website" section of the script, the host user id and password are stored.  While this works, it is probably not the best approach.  By generating a ssh key pair, we can eliminate the need for the user id and password, and we can clean up the code using scp.
## ssh-keygen
Run this command in Terminal:

This program creates a pair of encryption keys, public and private, using the RSA encryption scheme. It will prompt you for a filename where it will save the private key. (The public key will be created with the same filename, but with an additional `.pub` extension.) By default, it will want to save the key as`~/.ssh/id_rsa`, which, being one of the default filenames for keys that scp (and ssh) recognizes, will be perfect for our purposes.  Hit return to enter a blank pass phrase, and then return again to confirm a blank pass phrase. (Using ssh-agent would allow using a pass phrase protected key, but that is beyond the scope of this posting.)

Next you want to log onto the remote machine, your web host, and create (if it doesn't already exist) a .ssh directory.  Note the leading dot, which makes this directory hidden to the normal <strong><em>ls</em></strong> command.  To see if you already have one, type

at the command prompt on your web host. 

Once you've created the .ssh directory you are ready to copy the public half of the key pair to your host.  The public key on your local machine will (by default) be called id_rsa.pub.  We are going to rename it as we copy it to the remote machine to authorized_keys2.  (If you already have an authorized_keys2 file on the remote machine, you will need to concatenate the new key to the exiting ones.)

We'll use the scp command to copy, and rename, the public key:

You will have to provide the correct values for <strong><em>yourid</em></strong> and the <strong><em>remotehost.com</em></strong> name.  Since we haven't yet copied the key to the remote machine you will be asked for your password.  In the future, however, having the keys setup will let this command, and others like it, run without requiring a password.

With our keys in place we can now modify the uptime script to use scp.  
## The Modified Script

Now you can follow the rest of the steps at the <a title="Automatically update your computer's uptime on your website" href="http://www.wesg.ca/2008/06/automatically-update-your-computers-uptime-on-your-website/">Automatically update your computer's uptime on your website</a> article, and know that your information is being copied without exposing your id, password, or the file contents thanks to scp and ssh-keygen.
