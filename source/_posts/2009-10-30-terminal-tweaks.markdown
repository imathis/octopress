--- 
layout: post
title: Terminal Tweaks
date: "2009-10-30"
comments: false
categories: life
link: false
---
While the Apple Mac OS X graphical user interface is beautiful and very easy to use, having a powerful Unix command line at my disposal gives OS X something extra. Out of the box Terminal (Applications -&gt; Utilities -&gt; Terminal) is ready to go, but I like to customize all parts of my computer, so here is what I've done to Terminal.
## Terminal Style
I use a colored theme to provide high contrast in my Terminal window. This improves readability tremendously. The theme I like currently is called <a title="GiovanniStyle" href="http://tempe.st/2009/01/giovannistyle-high-readability-for-your-terminalapp/" target="_blank">GiovanniStyle</a>. It uses light yellow on a dark blue background. While the author suggests Consolas for the font I am using <a title="Anonymous Pro font" href="http://www.ms-studio.com/FontSales/anonymouspro.html" target="_blank">Anonymous Pro</a>. Consolas comes with Microsoft Office which I don't have installed. There is a free font called Inconsolas that mimics the Microsoft offering, but I still like the Anonymous appearance better.
<p style="text-align: center;"><img class="aligncenter size-full wp-image-2128" title="terminal" src="http://zanshin.net/wp-content/uploads/2009/10/terminal.png" alt="terminal" width="537" height="397" /></p>

## Manpages Color
The only drawback to GiovanniStyle is view manpages. By default some of the colors used in man's output is not contrasty enough to be legible. Consequently I added a section to my .bash_profile to compensate. Here are the color designations I'm using for manpages:

And here's the output:

<img class="aligncenter size-full wp-image-2137" title="manpages" src="http://zanshin.net/wp-content/uploads/2009/10/manpages.png" alt="manpages" width="596" height="441" />
## My Prompt
Speaking of bash, I've modified my prompt, to make it standout more and to provide the information about who I'm logged in as and what my current working directory is, in a manner pleasing to me. Here's the prompt:

And here's what it looks like:
<p style="text-align: center;"><img class="aligncenter size-full wp-image-2142" title="prompt" src="http://zanshin.net/wp-content/uploads/2009/10/prompt.png" alt="prompt" width="599" height="128" /></p>

## .bash_profile and .bashrc
I do not pretend to understand (yet) all the ins and outs of what goes in a .bash_profile and what goes in a .bashrc file. With that disclaimer in mind, I know the .bash_profile is the personal initialization file, which is executed for login shells, and the .bashrc file is the individual per-interactive-shell startup file. In my case I tend to have PATH additions and exports in .bash_profile, while keeping aliases and functions in my .bashrc.

This is my current .bash_profile:

And this is my current .bashrc file:

The <strong>calendar</strong> alias runs the calendar command against a calendar file of my own making. I just copied the <strong>calender.all</strong> file in
<pre>/usr/share/calendar</pre>
and eliminated the calendars I wasn't interested in seeing and called the new file calendar.mark.

The <strong>dus</strong> alias produces a list of directories and files sorted into order from largest to smallest. It recurses through all sub-directories from where it is run, i.e., running it from your home directory could take a while depending on your processor and the number of files on your system. You can add an <strong>-h</strong> flag to the <strong>du</strong> command to get a human-readable output, but that breaks the sorting.

<strong>Adventure</strong> is fun, you should give it a try. Don't blame me however, if you get eaten by a grue.

<strong>Mailsize</strong> spits out the current size of your mail directory. I'm up to 5 GB myself.

<strong>bk</strong> takes you back to the previous directory. It's the same as <strong>cd -</strong> only shorter.

The <strong>r</strong> function and the <strong>rm</strong> alias are measures designed to protect me from careless use of the remove (rm) command. Be warned that issuing a <strong>rm -rf </strong>neatly sidesteps these "protections." Command-line-interfaces are powerful and therefore can be dangerous.
