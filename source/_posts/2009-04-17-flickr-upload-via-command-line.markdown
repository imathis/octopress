--- 
layout: post
title: Flickr Upload Via Command Line
date: 2009-4-17
comments: false
categories: life
link: false
---
Recently one of my coworkers Twittered that he had uploaded some <a title="Josh Works on Twitter" href="https://twitter.com/worksology/status/1530154480">11,000 pictures</a> to his Flickr account. After getting over my initial shock at the sheer volume of images, I started thinking that I had a couple thousand images on my hard drive that I would like to have on Flickr too.

Using the <a title="Tools for Flickr" href="http://www.flickr.com/tools/">Flickr Uploadr</a> is problematic. First you have to select the pictures you wish to upload; a task exacerbated by the hierarchically nested directory structure that iPhoto uses to store your pictures. The Uploadr isn't bright enough to traverse sub-directories looking for images, so you are forced to open each <em>year/month/day</em> combination to select images. An unenviable task with pictures spanning the last nine years on your hard drive.

A better approach would be to copy all the images you wanted to upload into one directory and then let Flickr Uploadr work against that collection. Fortunately the Unix under pinnings of Mac OS X make copying files from dozens of nested sub-directories to a single target directory simple. Using the find command with the -exec switch like so:

<strong>find . -name "*.JPG" -exec cp "{}" /path/to/new/directory \;</strong>

will search the current directory (and all of its sub-directories) for files matching the *.JPG string. And the -exec switch runs the copy (cp) command for each file found (the "{}" portion of the command). The /path/to/new/directory is delimited by the backslash-semi-colon at the end of the command.

After running this command I had a folder with over 4,600 images. Far more than I expected. The OS X operating system keeps metadata in files beginning with a dot, and my new images directory was filled with these dot-files, one for each image file. If there was an image file named 396.JPG, then there was a dot-file named .396.JPG.

Another find command, this time executing the rm (remove) command would take care of these dot-files for me:

<strong>find . -name ".*.JPG" -exec rm "{}" \;</strong>

As always when you are using rm, care should be taken to not delete more than you wish. Leaving the -exec portion of the command off, i.e., <strong>find . -name ".*.JPG"</strong> will list the file found by the find. Running that variation of the command first will help you to see what effect adding the -exec rm "{}" \; switch will have.

After removing the dot-files, I had approximately 2,300 images left, which seemed like the right amount. Starting Flickr Uploadr, I selected all the images in my new directory and waited. And waited. And waited. It took Flickr Uploadr a very long time to import all the images to its interface, before I could adjust the upload settings and start the upload process.

Once I had created a new set, and marked the images to be private, I started the upload. Within minutes Flickr Uploadr crashed. Subsequent re-starts also crashed. Finally I managed to click on the "remove all" button and empty the tool of images to be uploaded. I then tried uploading only smaller sets of images, say 500 at a time. This initially appeared to be working, but again the Uploadr crashed. Doggedly rerunning the utility I finally managed to upload all my images.

Signing into my Flickr account, and opening the new set I had created for these images I discovered that I had uploaded the thumbnail image size and not the full image size. 2,200 of them.

Some investigating in one of the iPhoto image directories revealed that there were two copies of each picture, one a thumbnail and one the full-sized image. The thumbnail has the file extension .jpg, while the full-sized image ends with .JPG. Unix based operating systems are cAse sEnsITive. .jpg and .JPG are not the same. I am used to using lowercase letters for file extensions, so when the find command above, using "*.jpg" for the search pattern return what appeared to be the right number of images, I didn't realize that I had gotten the thumbnails only.

After deleting 2,279 images from Flickr, which takes a really long time, I wasn't looking forward to struggling with the balky Flickr Uploadr utility again, especially since the full-size images would big considerably large (i.e. much slower loading) than the thumbnails. Through Google I discovered a Lifehacker article on a<a title="Use a command line utility to upload to Flickr" href="http://lifehacker.com/software/hack-attack/automatically-upload-a-folders-photos-to-flickr-262311.php"> command line utility to upload images to Flickr</a>. My hope was that by eliminating the extra layers of complexity, and the memory requirements, of the GUI Uploadr, I would have better luck.

In short the command line utility, a pair of Python scripts, worked like a champ. It uploaded 2,299 images with only 22 failures, for a total of 2,279 new pictures in my Flickr account. If I were to do this again, here are the steps I would follow from start to finish. These steps assume that you have read the Lifehacker article, and downloaded the necessary Python scripts.

First create a directory to temporarily hold the images you wish to upload:

<strong>mkdir ~/images</strong>

Next, switch to your iPhoto Library and copy all the full sized images to the new images directory:

<strong>cd ~/Pictures/iPhoto\ Library/</strong>

<strong>find . -name "*.JPG" -exec cp "{}" ~/images \;</strong>

Since this find command will also capture all the OS X meta files (dot files) run this command to remove them:

<strong>cd ~/images</strong>

<strong>find . -name ".*.JPG" -exec rm "{}" \;</strong>

Now you should have a directory filled with all the full sized images from your iPhoto library. The next step is to run the Python upload script. Make sure to follow the configuration instructions listed in the Lifehacker article. And be aware that on the first running of this script you will have to sign into your Flickr account and authorize the Python script so it can access your account. Since all the parameters are specified in the script itself the final command is rather simple. In my case I saved the utility to my bin folder:

<strong>cd ~/bin</strong>

<strong>python uploadr.py</strong>

The script will display a success (or problem) line for each file it operates against. Running the command as I've shown above will dump these messages to your console. If you wanted to save them for posterity you could run the command like this:

<strong>python uploadr.py &gt; log.txt</strong>

which would produce a text file with the output for you.

Now I have 2,279 images to tag, comment on, add titles to, et cetera. Unfortunately there isn't a utility, command line or otherwise, to do that for me.
