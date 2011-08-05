--- 
layout: post
author: Mark
comments: "false"
title: Organizing Data
date: "2009-10-24"
categories: life
---
Now that I have most of the software I use on a recurring basis installed on the MacBook Pro, it is time to start addressing my data. Pictures and music were the low-hanging fruit, and have already been transferred. (Although I am considering deleting all the pictures and re-transferring them via the Migration Assistant. Doing it manually certainly worked, but the folder hierarchy I had before was lost. I really don't want to recreate it and re-sort thousands of images.)

The rest of my data breaks down into about eight types: E-books, Manuals, Word documents, Excel spreadsheets, Powerpoint presentations, diagrams, PDF, and RFT files. Figuring out where to put all of this on the new machine isn't as easy as simply copying it across. The current organization scheme grew organically and without much thought at times. It is less an organization and more a hodge-podge.
## A Word on the Home Directory Hierarchy
When a new user account is created on a Macintosh computer there are some directories included in the user's home directory by default. They are:
<ul>
	<li>Desktop</li>
	<li>Documents</li>
	<li>Downloads</li>
	<li>Library</li>
	<li>Movies</li>
	<li>Music</li>
	<li>Pictures</li>
	<li>Public</li>
	<li>Sites</li>
</ul>
I've added four more directories to this list:
<ul>
	<li>Applications</li>
	<li>Dropbox</li>
	<li>bin</li>
	<li>Projects</li>
</ul>
The <strong>Applications</strong> folder is where I am installing all software that I add to the MacBook Pro, provided it will work there. The Mac OS X-Apache-MySQL-PHP technology stack (MAMP) installation refused to run when it was located in /Users/mark/Applications, so I moved it to /Applications. Dropbox also installed itself in /Applications.

The <strong>Dropbox</strong> folder itself, not the software that enables the client, is located in my home directory. This is the default location and I'm used to it and think it works very well.

<strong>bin</strong> is the folder where my program scripts, either bash, Ruby, or Python, live. bin is short for "binary."

<strong>Projects</strong> is where I keep any source code that I am developing, or the files associated with a software project, e.g., WordPress site themes or web site files.

With a precedent set of adding home directories for specific uses, I need to decide whether my remaining files go into one of the established directories or into a specially created directory just for them.
## E-books
I have been an avid e-book reader for several years. I got hooked on the format with a Palm and consequently most of my e-books are in the eReader format. I also have a number of PDF or Word copies of books. Heretofore my eBook folder has been located under the Documents folder in my home directory. However, eBooks aren't Documents, they are specialized in format and purpose. I think it's time to move eBooks out of Documents and into it's own directory, Ebooks.
## Manuals
Over the years I've collected a number of technical books and references, some as PDFs, others as self-contained web sites. While these could be considered eBooks none of them require specialized or proprietary software to be viewed. I've always kept them in a directory in my home directory. I see no reason to change that now.
## Word, Excel, Powerpoint
Historically I have tended to keep a directory under my Documents directory for each of these file types. I think this grew out of wanting to set a default save location for each in their respective programs. Over time these three directories have become the most jumbled and chaotic.  Each is littered with files and sub-directories. The sub-directories were an attempt to impose order. "Resumes," for example is a sub-folder under Word that houses many examples of my resume. It also holds some Rich Text Format (RTF) copies of my resume, and some PDF copies as well. I put the non-Word format files in with the Word-format ones since that is where my resumes were. Adding insult to injury not all of my resumes are in the Resume directory, there are a few running around loose in the Documents folder.

The Excel directory is equally messy for the same reasons. Powerpoint isn't too bad simply because I don'y have too many slide shows. However it does hold a couple of OpenOffice Presentation files.

Clearly it is time for a major rethinking regarding how to organize files produced by my office productivity suite. Since I am switching from Microsoft Office to OpenOffice this seems like a good time to abandon the Word - Excel - Powerpoint triumvirate. The better approach I think would be to promote the sub-directories from inside Word, Excel, and Powerpoint, so that they live directly under Documents. Instead of saving things based on their file type, save them by topic. All resumes, regardless of file type, go in the resume directory.

The hard part will be moving everything around and developing a good sense for topics.
## PDF and RTF
These files have their own directory on my old machine just like Word, Excel, and Powerpoint. And just like those three, it is a somewhat chaotic jumble of files. Once again, grouping files by type wasn't a good idea. Henceforth PDFs and RTFs will be stored in the topical directory where they belong.
## Diagrams
The final broad category of files are diagrams. Some of these are Visio documents I've saved from previous employment engagements and the rest are Omni Graffle files. And like all their sibling file types, these have tended to be segregated by file extension. So, just like the rest these files will be stored in the topic for which they were created.
## Summary
With the addition of the new top-level directories, and the shifting of file-type directories to topics, the new hierarchy looks like this:
<ul>
	<li>Applications</li>
	<li>bin</li>
	<li>Desktop</li>
	<li>Documents
<ul>
	<li>topic, e.g., Resume</li>
	<li>topic, e.g., Letters</li>
</ul>
</li>
	<li>Downloads</li>
	<li>Dropbox</li>
	<li>EBooks</li>
	<li>Library</li>
	<li>Movies</li>
	<li>Music</li>
	<li>Pictures</li>
	<li>Public</li>
	<li>Projects</li>
	<li>Sites</li>
</ul>
Ultimately I'll be using Spotlight to find files I need so remembering where in this hierarchy things are located won't be critical. It is pleasing, however, to have a better organization scheme. Especially one that isn't dependent upon proprietary file extensions as the principle discriminator.
