--- 
layout: post
title: CPU Frequency
date: 2003-11-8
comments: true
categories: life
link: false
---
Thanks to <a href="http://a.wholelottanothing.org/">Matt Haughey</a>, <a href="http://randomfoo.net/">Leonard Lin</a>, and this <a href="http://docs.info.apple.com/article.html?artnum=14449#faq9">Apple document</a> my Powerbook G4 (867 MHz) is once again running at 867 MHz.

I just last evening upgraded to 10.2.8 figuring that all the quirks have been flattened by now. Silly me. Less than 24 hours later I read that 10.2.8 may have reset my cpu frequency to a figure 2/3rds of its rated speed.

Running the <strong>sysctl hw.cpufrequency</strong> command in the Terminal I discovered to my dismay that my CPU was running at a mere 667 MHz. Following Apple's directions I reset my PMU and restarted my machine. Once again I am running at a full 867 MHz.
