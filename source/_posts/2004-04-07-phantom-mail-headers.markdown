--- 
layout: post
comments: "false"
title: Phantom Mail Headers
date: 2004-4-7
link: "false"
categories: life
---
For some time now I have noticed that when I downloaded my e-mail I was seeing higher counts in the status bar than I was new messages in my inbox. When I first noticed the problem, one of my mail accounts was claiming to download 61 messages more than I was actually getting.

I am not sure when these phantom message headers appeared, or what may have caused them. I have managed to rid myself of them ( for now ) and I wanted to share the steps in case some one else is having the same issue.

Some background:
<ul>
<li class="il">I'm using 10.3.3 ( although the problem first appeared under 10.3.2, and possibly under 10.2.8 )</li>
<li class="il">I'm using SpamSieve 2.1.2</li>
<li class="il">The account in question is set to remove messages from the server immediately</li>
<li class="il">There is only one rule defined, the one that activates SpamSieve</li>
<li class="il">Mail's built-in Junk filter is turned off</li>
</ul>
First I tried rebuilding all the folders in Mail. When that didn't work I tried deleting and recreating the mail account with the phantom headers. Next I contacted my ISP to see if the problem was somehow at their end. They said there weren't any messages in that account.

My next step was to move the ~/Library/Caches/Mail folder to my desktop. This didn't work either.

Finally I logged into the control panel for my account at my ISP and deleted the mail account from the server ( after downloading all the mail there first, of course ). Then I re-created the account on the server.

This steps seems to have worked. When I get my mail the status bar numbers match the instances of new mail in my inbox. Personally I think that an aborted or failed mail retrieval attempt left these headers on the ISP server somehow. Deleting the account there, with a seemingly empty inbox, got rid of problem when nothing done on my machine worked.
