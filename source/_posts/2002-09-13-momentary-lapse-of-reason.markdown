--- 
layout: post
comments: "false"
title: Momentary Lapse of Reason
date: 2002-9-13
link: "false"
categories: nerdliness
---
The development work I perform as a consultant involves a shared code-base. All the work done by all the developers here is kept in a central repository. Each of us has one or more workspaces where we can check out code, make changes to it, and later integrate our changes so that the other developers have access to the latest version.

Over time, due to constant changes being made by developers the central repository grows in size. Once it reaches a gigabyte bad things start to happen. The way to restore order is to export all the code to a file, destroy the repository and then build a new repository in its place. Once the new repository is in place all the work is imported from the file. This usually reduces the size from 800~900 meg to 200 or so.

It is critical that each developer integrate his or her work prior to this cleanse process, otherwise it will be lost forever. Once that old repository is deleted there is no going back. There is no undo.

Last night there was a cleanse and I was certain that I had integrated all of my work. This morning, however, when I opened my workspace in the brand new repository none of my recent changes were there. In fact it appeared that none of the work from the past month was there.

I freaked out. For a few moments I thought I had screwed up my integration or forgotten it altogether. The past month has been extremely busy and productive in terms of new code for me. I had created dozens of new windows, and written hundreds, thousands of new lines of code. All seemingly gone.

Friday the 13th indeed.

In the end the problem was larger than just me. The process to import the backup file had used the wrong version of the backup file. Everyone had been reset to August 15th. Simply by re-running the load process with the correct file order would be restored.

For me the worst part of the experience today was the few moments when I first discovered all my code was missing. When I was worried that I had screwed up. It was a major "oh no" second.

My lapse of reason has passed now.
