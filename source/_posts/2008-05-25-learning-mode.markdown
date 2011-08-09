--- 
layout: post
title: Learning Mode
date: 2008-5-25
comments: false
categories: life
link: false
---
In the early 1990's, when I was still using OS/2 as my primary operating system, I attended a day-long demonstration about the platform.  Included in the slate of presentations was one about voice recognition.  The presenter, an energetic woman, described how she was able to read and respond to hundreds of emails and Compuserve forum postings using dictation, or voice-to-text, software.  She gave us a quick demo of the software's ability by dictating, "You were right to write to me right now, Mr. Wright."  The software was able to correctly spell each variation of the phonetically identical right/write/Wright.

Of course, the software wasn't able to do that for me when I loaded it on my computer at home.  First, I had to train the software to my speech patterns, inflections, and rhythms.  The training consisted of reading several passages of text, provided with the software, making corrections to the text on the screen as I went.  After perhaps an hour's work, the voice recognition was nearly 100% accurate.  Through the training exercises the software was able to "learn" about my speaking habits, and accurately capture text I dictated.

In the years following that experience I have run across several other examples of "software that learns."  The one that comes to mind most readily are the Bayesian junk mail filters common in email clients today.  By identifying mail you consider spam (or not spam) the filter learns how to sort your mail.  Most of these tools are very accurate, with only a few false positives or negatives.

Our experience with Sibelius this weekend has led me to think that music notation software could benefit from some kind of training mode, or learning mode.  Sibelius allows one to input music notation in three ways: computer keyboard, note-by-note (Steptime) using your MIDI input device, or dynamically (Flexitime) using your MIDI input device.  They explain in their literature that playing a piece of music accurately to a metronome is difficult.  That as humans we tend to vary the time of our playing ever so slightly.  Flexitime attempts to allow for this by adjusting the tempo to match your playing speed.  If you slow do, it slows down.  Unfortunately there are several points of failure between the musician and the notation algorithm, not the least of which is latency introduced by the MIDI interface, and perhaps more latency introduced by the sound system in the computer. (That experienced musicians can, and do, play accurately to a metronome is a discussion for another posting.)

If Sibelius had a "learning mode" that provided several short pieces of music for the musician to play using Flexitime, the notation algorithm could examine the captured results and compare them to the stored standard.  From this comparison the algorithm could "learn" about the latency characteristics of the computer, MIDI input device, and MIDI interface.  While it might not completely eliminate the kind of notation problems we have seen, I feel it could go a long ways towards reducing them.
