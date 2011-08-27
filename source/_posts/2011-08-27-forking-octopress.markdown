---
layout: post
title: "Forking Octopress"
date: 2011-08-27 09:14
comments: true
categories: nerdliness
link: false
---
When I setup Octopress I followed the directions outline on the [Octopress Setup](http://octopress.org/docs/setup/ "Octopress Setup") page. In a nutshell these steps create a Github repository for you to track your instance of Octopress with, and a local (i.e., on your computer) instance of Octopress where you create your website, generate it, and from where you deploy. Diagrammatically it looks something like this: {% img /images/octopress_pull.png 545 361 "Octopress Pull Setup" %}	

From your local instance you can fetch [updates from Octopress](http://octopress.org/docs/updating/ "Updating Octopress") and keep your Github instance synchronized via **git push origin master**. 

My Git-fu is not very strong yet, so I was at first mystified and then frustrated to discover that I couldn't easily share a plugin I added to my Octopress installation with Brandon Mathis' __ur__-Octopress. On Github, at least, without a fork tying your repository back to a source repository, there is no way to issue a pull request. It maybe that one can create the equivalent of a pull request on their local copy of a repository and send a pull request to the project owner, but my Git understanding doesn't include that knowledge.

What I wanted and needed was an active fork of the ur-Octopress, a fork that was actively tied to my local instance of Octopress as well. After asking one of the developers I work with who has more Git experience than I, and after [posting a question on StackOverflow](http://stackoverflow.com/questions/7210273/add-github-fork-to-existing-repository "Add Github fork to existing repository"), I took the following steps to "add" a fork to my Github Octopress repository.

1. I deleted my existing Github Octopress repository. It was named "Octopress" so any new fork of the ur-Octopress would result in the fork being called Octopress-1. Not what I wanted.

2. I forked the **imathis/octopress** repository.

3. I removed the, now broken, remote between my local git repository and the deleted Github repository using **git remote rm origin**

4. I created a new remote, called **origin**, to link my local git repository to the forked Octopress on Github, via **git remote add origin git://github/zan5hin/octopress.git**

5. When I tried to push my local git repository to Github (**git push origin master**) it failed with the following error message: **! [rejected]  master -> master (non-fast-forward)**. The fork on Github contained changed not present in my local repository that I needed to resolve first. If I have updated locally before starting this process it is likely I wouldn't have had this error. To resolve the error I ran **git pull origin master**.

6. I resolved the two minor merge conflicts created by the git pull.

7. I generated my site and viewed it via Pow to make sure everything was still working properly.

8. I synchronized my local repository with Github via **git push origin master**

The result of all this work is looks like this: {% img /images/octopress_fork.png 545 361 "Octopress Pull Setup" %}

All of my commits are in place, and I can now generate pull requests for Brandon to process as he sees fit.