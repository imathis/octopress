--- 
layout: post
title: Automatically Update Your Uptime In Wordpress
date: 2008-8-22
comments: true
categories: life
link: false
---
Recently I read an article on how to capture, upload, and display your computer's uptime in the footer of your blog. <a title="Automatically update your computer's uptime on your website" href="http://www.wesg.ca/2008/06/automatically-update-your-computers-uptime-on-your-website/">Automatically update your computer's uptime on your website</a> does a very good job of laying out the basic techniques for accomplishing this, admittedly nerdy, task.  However, the original script uses FTP, or File Transfer Protocol, to move the formatted uptime information from your computer to your web site host. Using Secure Copy, or scp, would be a better solution.
## SCP
Secure copy, or scp, encrypts data being transfered so that man-in-the-middle attacks aren't possible.  I'll show you the original script, and then  my script which employs scp instead of ftp.  I'm also using a private-public key pair for authentication, so that there is no need for my host password to be either transmitted or stored in the script.
## The Original Script
{% codeblock %}#!/bin/sh
#mark as executable
# get the uptime data
days=$(uptime | awk '{print $3}' | sed 's/,//g')
hours=$(uptime | awk '{print $5}' | sed 's/,//g')
label=$(uptime | awk '{print $4}')
 
if [ "$days" = 1 ]; then
  day_label='day'
else
  day_label='days'
fi
 
#format labels
if [ $hours = 1 ]; then
  hour_label='hour'
else
  hour_label='hours'
fi
 
#format output
if [ "$label" = 'mins,' ]; then
  echo 'My MacBook has been on for '$days minutes'' &gt; uptime.txt
elif [[ "$label" = 'day,' || "$label" = 'days,' ]]; then
  echo 'My MacBook has been on for '$days $day_label, $hours $hour_label'' &gt; uptime.txt
elif [ "$label" = '2' ]; then
  echo 'My MacBook has been on for '$days hours'' &gt; uptime.txt
fi
 
#upload to the website
hostname="FTP address"
username="FTP username"
password="FTP password"
 
ftp -n $hostname &lt;&lt;EOF
 
quote USER $username
quote PASS $password
cd /path/to/wordpress/uploads
put uptime.txt
EOF
 
#move the uptime file back to its original place
mv uptime.txt /path/to/file
 
echo "task completed"{% endcodeblock %}
As you can see, in the "upload to the website" section of the script, the host user id and password are stored.  While this works, it is probably not the best approach.  By generating a ssh key pair, we can eliminate the need for the user id and password, and we can clean up the code using scp.
## ssh-keygen
Run this command in Terminal:
{% codeblock %}ssh-keygen -t rsa{% endcodeblock %}
This program creates a pair of encryption keys, public and private, using the RSA encryption scheme. It will prompt you for a filename where it will save the private key. (The public key will be created with the same filename, but with an additional {% codeblock %}.pub{% endcodeblock} extension.) By default, it will want to save the key as{% codeblock %}~/.ssh/id_rsa{% endcodeblock}, which, being one of the default filenames for keys that scp (and ssh) recognizes, will be perfect for our purposes.  Hit return to enter a blank pass phrase, and then return again to confirm a blank pass phrase. (Using ssh-agent would allow using a pass phrase protected key, but that is beyond the scope of this posting.)

Next you want to log onto the remote machine, your web host, and create (if it doesn't already exist) a .ssh directory.  Note the leading dot, which makes this directory hidden to the normal <strong><em>ls</em></strong> command.  To see if you already have one, type
{% codeblock %}ls -a{% endcodeblock %}
at the command prompt on your web host. 

Once you've created the .ssh directory you are ready to copy the public half of the key pair to your host.  The public key on your local machine will (by default) be called id_rsa.pub.  We are going to rename it as we copy it to the remote machine to authorized_keys2.  (If you already have an authorized_keys2 file on the remote machine, you will need to concatenate the new key to the exiting ones.)

We'll use the scp command to copy, and rename, the public key:
{% codeblock %}scp id_rsa.pub yourid@remotehost.com:~/.ssh/authorized_keys2{% endcodeblock %}
You will have to provide the correct values for <strong><em>yourid</em></strong> and the <strong><em>remotehost.com</em></strong> name.  Since we haven't yet copied the key to the remote machine you will be asked for your password.  In the future, however, having the keys setup will let this command, and others like it, run without requiring a password.

With our keys in place we can now modify the uptime script to use scp.  
## The Modified Script
{% codeblock %}#!/bin/sh
# timeup.sh

# get the uptime data
days=$(uptime | awk '{print $3} ' | sed 's/,//g')
hours=$(uptime | awk '{print $5} ' | sed 's/,//g')
label=$(uptime | awk '{print $4} ')

if [ "$days" = 1 ] ; then
day_label='day'
else
day_label='days'
fi

# format labels
if [ $hours = 1 ] ; then
hour_label='hour'
else
hour_label='hours'
fi

# format output
if [ "$label" = 'mins,' ] ; then
echo 'My Powerbook has been on for '$days minutes'' &gt; uptime.text
elif [[ "$label" = 'day,' || "$label" = 'days,' ]] ; then
echo 'My Powerbook has been on for '$days $day_label, $hours $hour_label'' &gt; uptime.text
elif [ "$label" = '2' ] ; then
echo 'My Powerbook has been on for '$days hours'' &gt;&gt; uptime.text
fi

# upload to web host
# relies upon ssh-key for authentication
scp uptime.text id@remotehost:/path/to/wordpress/uploads/uptime.textontent/uploads/uptime.text

echo "task completed"{% endcodeblock %}
Now you can follow the rest of the steps at the <a title="Automatically update your computer's uptime on your website" href="http://www.wesg.ca/2008/06/automatically-update-your-computers-uptime-on-your-website/">Automatically update your computer's uptime on your website</a> article, and know that your information is being copied without exposing your id, password, or the file contents thanks to scp and ssh-keygen.
