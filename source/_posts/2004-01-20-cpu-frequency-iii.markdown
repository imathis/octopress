--- 
layout: post
title: CPU Frequency III
date: 2004-1-20
comments: false
categories: nerdliness
link: false
---
Some times a little information is a dangerous thing.

After <a href="http://www.zanshin.net/blogs/000296.html" title="original cpu frequency posting">upgrading</a> to 10.2.8 on my Powerbook (eeyore) I discovered the 'sysctl' command. Among other things it purports to report the CPU frequency of the machine. You do this by issuing this command:

sysctl hw.cpufrequency

Only the output may upset you. It certainly did me. I have a 867 MHz G4 but sysctl reported my CPU frequency as 667000000. A difference of 200 MHz or about 23%. Not cool. Further investigation into the matter had me <a href="http://www.zanshin.net/blogs/000309.html" title="follow up cpu frequency posting">reseting my PMU</a> every time I had to restart my laptop. You see after reseting the PMU (and reseting the clock from 12/31/1969 <i>each</i> time) sysctl would return a beautiful 867000000 for cpuFrequency.

Not being happy with this situation I have been searching for clarification about this problem and a fix to make it go away. Yesterday, thanks to <a href="http://www.livejournal.com/community/macosx/1980838.html" title="live journal thread on cpu frequency">live journal thread on cpu frequency</a> I think I found out what is happening. Moreover, I have confidence that my understanding is now the truth.

The hw.cpufrequency is an <i>undocumented</i> parameter of the sysctl command. Its results are not accurate. With the help of the XCode developer's disk included in 10.3 (Panther) I installed the Skidmark GT benchmark tool yesterday. Upon running it with sysctl reporting 867 as the cpu frequency I got benchmarks of 86, 86, and 86 for Integer, Floating Point, and Vector.

Rebooting and <i>not</i> reseting the PMU results in sysctl showing 667 once again. Running Skidmark again I got 86, 86, and 86. Skidmark rates a 1.0 GHz CPU at 100, so values of 86 would be correct for a 867 MHz processor.

In other words, if you have been chasing after the solution to the sysctl hw.cpufrequency "bug" like I have, you can stop. Hw.cpufrequency is undocumented and returns a <i>false</i> value for G4 processors. If you have 10.3, put the XCode CD in your machine and install the Skidmark GT tool (it's part of the CHUD benchmarking package) and use it to evaluate your machine's performance.
