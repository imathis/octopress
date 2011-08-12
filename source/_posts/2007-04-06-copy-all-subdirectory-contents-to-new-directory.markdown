--- 
layout: post
title: Copy All Subdirectory Contents to New Directory
date: 2007-4-6
comments: true
categories: nerdliness
link: false
---
This entry is merely here so I don't have to try and remember where I wrote it down for the next time I need it.

<strong>Problem</strong>
A directory, A, contains many sub-directories, B, C, D, .... Each sub-directory contains one or more files that you want copied to a new directory without the directory hierarchy. Result will be a directory, A1, that contains just files.

<strong>Solution</strong>
The *nix <strong>cp</strong> command.

{% codeblock %}
cp -r &lt;source_directory&gt;/*/*.filetype .
{% endcodeblock %}

Copy, recursively for files (little r, not Directories or big R), from the source_directory, searching all folders (/*), for all files of a type (/*.filetype) to here (.)

Thanks <a href="http://blueyak.org" title="blue yak">JJ</a>.
