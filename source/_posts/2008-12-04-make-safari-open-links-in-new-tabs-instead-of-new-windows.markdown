--- 
layout: post
comments: "false"
title: Make Safari Open Links in New Tabs Instead of New Windows
date: 2008-12-4
link: "false"
categories: life
---
From <a title="456 Berea Street" href="http://www.456bereastreet.com/">456 Berea Street</a> comes this <a title="Force Safari to Open Targeted Links in a New Tab" href="http://www.456bereastreet.com/archive/200812/make_safari_open_targeted_links_in_new_tabs_instead_of_new_windows/">tip on forcing Safari to open targeted links in a new tab</a> rather than in a new browser window.  (NB: I changed the order of the steps slightly to suit my way of thinking.)
<ol>
	<li>Open a Terminal window.</li>
	<li>Type the follow command but don't press enter yet: defaults write com.apple.Safari TargetedClicksCreateTabs -bool true</li>
	<li>Quit Safari.</li>
	<li>Press enter in the Terminal to execute the command.</li>
	<li>Restart Safari, and enjoy new tabs rather than new windows.</li>
</ol>
<div></div>
