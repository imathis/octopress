--- 
layout: post
title: Roundhaus
date: 2008-2-1
comments: true
categories: nerdliness
link: false
---
After trying to enable <a href="http://zanshin.net/2008/01/30/remote-access/" title="SBC DSL remote access - fail">remote access</a> to my home network and discovering that AT&amp;T doesn't really allow inbound connections, I've resorted to a different solution for access-from-anywhere-version-control.
### Roundhaus
<a href="http://roundhaus.com" title="RoundHaus">Roundhaus</a>, has this to say about their subversion offering,
<blockquote>Working with subversion repositories has never been easier. Create new projects, assign permissions, add and remove people all from a simple to use interface.</blockquote>
That Roundhaus also offers a Ruby on Rails™ development platform and continuous integration servers, is just icing on an already good cake.

I also considered <a href="http://beanstalkapp.com/" title="Beanstalk - Version Control with a Human Face">Beanstalk</a> as a remote version control platform, however difficulties with accessing the repository unfortunately put them in second place.
<h4>Setup</h4>
Creating my free, single project, three user account was quick and painless.  Within minutes I had a repository, and was able to import my code.  Roundhaus offers several <a href="https://roundhaus.com/plans" title="RoundHaus - plans">plans</a> to choose from, and you can up- or downgrade whenever you want or need.

My objective was to house the three hand-coded sites I maintain under version control to allow development work from any machine, without the constant worry of which machine holds the current version.  To get started I downloaded the source code from the three sites to my Powerbook; the live source being the truth of those sites.

Next I created a working directory on my laptop, and put each site in its own sub-directory.  Having the three sites under a common parent directory allowed me to import the parent in to my project trunk on Roundhaus.  From the command line in Mac OS X, I first navigated to my working directory, and then issued this subversion command to get started:
{% codeblock %}$ cd websites{% endcodeblock %}
{% codeblock %}$ svn import -m "initial import of sites" . https://path-to-roundhaus-project/project/trunk{% endcodeblock %}
The period in the middle off the subversion import command is crucial; it represents the current working directory and tells subversion what to import.

With my source imported into the repository I was able to delete the working directory and create a new, empty, working directory.  Changing to that directory I was able to issue the subversion check out (co) command to retrieve revision 1 of my project:
{% codeblock %}$ cd sites{% endcodeblock %}
{% codeblock %}$ svn co https://path-to-roundhaus-project/project/trunk{% endcodeblock %}
Repeating this checkout process on each of my machines gives me access to one, and only one, trusted source for my code.  Details about working with <a href="http://subversion.tigris.org/" title="subversion">subversion</a>, both from the command line, or within an IDE like <a href="http://eclipse.org" title="Eclipse">Eclipse</a> or <a href="http://macromates.com/" title="TextMate - The Missing Editor for Mac OS X">TextMate</a>, are beyond the scope of this review, look for a future posting on integrating subversion into your work flow.

Roundhaus has been extremely easy to work with and, so far, very reliable.  In the few days since I've started using it numerous changes have been made to the code base without any hiccups or issues.  Best of all, I no longer have to worry about whether I am working on the correct source.
