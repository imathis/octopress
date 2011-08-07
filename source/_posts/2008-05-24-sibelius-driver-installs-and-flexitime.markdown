--- 
layout: post
comments: "false"
title: Sibelius, Driver Installs, and Flexitime
date: 2008-5-24
link: "false"
categories: life
---
Recently Sibylle purchased an electronic keyboard for her studio, and last week the copy of Sibelius 5 that she had ordered arrived.  Sibelius is one of the top two or three music notation software programs available and includes a note input mechanism called "Flexitime."  Flexitime captures the music you play on the keyboard (or other MIDI input device) directly on a score.  Last evening we hooked everything up and gave it a try.  We could not have been more frustrated or disappointed.

I had originally hooked the keyboard up to our iMac, which while somewhat aged (800MHz G4) is still serviceable.  It also has Garage Band which we played around with a bit.  Garage Band captures the MIDI information from the keyboard, but does not show that information in music notation form.  Not what Sibylle needs to capture compositions.  
## Sibelius
Sibelius installed very quickly and easily on the iMac and, while a bit slow at times, ran fine on that machine.  No drivers had to be added for the USB to MIDI dongle, and it was simple to follow the Sibelius setup instructions for adding a new MIDI input device to the Mac.  More on how the notation feature worked in a minute.
## Drivers
Installing Sibelius on a Windows machine was slightly more involved, but not annoyingly so.  The installation directions provided by Sibelius are thorough and even lightly humorous.  Getting the MIDI dongle recognized was another matter entirely.  Why peripheral manufacture insist on putting drivers on a CD with the device in the packaging, when they know that driver will be out of date in no time at all, is beyond me.  Installing the included driver failed to activate our MIDI input.  I had to click on the provided link, decipher a myriad of available drivers, download, and execute the new driver setup, in order to have Sibelius (and the computer) recognize the keyboard when it was attached.
## Flexitime
Flexitime is the dynamic note input mechanism included in Sibelius.  The software also allows for computer note input and steptime note input.  Using the computer mouse and keyboard you can create musical scores - a lengthly and laborious process.  Using step input involves the electronic keyboard, for the notes, and the mouse to select the note type from a palette.  With step input you can actually just play the keyboard and get notes on to your score which are accurate in terms of which note, but aren't accurate in terms of duration or other values.  In other words, unless you change the type of note from quarter to eighth to whole, and so on, every note is recorded as a quarter note, regardless of how you play it.  This input mechanism will be fantastic for producing scale or chord worksheets for students.

Flexitime tries to capture music as you play it.  There are many options controlling how it performs, from what duration of notes it recognizes (whole, half, quarter, eighth, sixteenth, thirty-second), to whether or not the metronome adjusts to your playing speed or not.  Both Sibylle and I tried each of these options, and many combinations of these options, trying to get an accurate capture of music being played.

We have not yet been successful.  Even playing a whole note scale produces odd rests, and notes which are of the wrong duration.  Setting the duration sensitivity seems to allow notes of the selected size or longer, when whole, half, or quarter are selected.  Once you pick eighth or shorter as the duration sensitivity, Sibelius starts littering the composition with sixteenth notes, and even thirty-second notes.

Sibelius does provide an online help web site, but several searches didn't reveal any useful information about our situation.  Google searches did turn up several other people with basically the same problem as us.  Some of the suggested answers included making sure that the sound card drivers were up to date (although why the playback channel should improve a MIDI input is beyond me).  And one site said that it is possible to get Flexitime to work, but that it took a lot of fiddling with the available settings.

I spent a hour or so this morning cursing Windows and various driver manufacturers as I update the ThinkPad's sound card driver, all to no avail.  We were still unable to successful produce a score using Flexitime.

The Sibeluis literature suggests that it is difficult for even seasoned pianists to play accurately to a measured beat; there will be little variances, which will throw the notation algorithm off.  So Flexitime tries to adjust to your style of play, speeding up or slowing down the beat as necessary so that the final composition has fidelity.  Therein, I think, lies the problem.  Sibylle has 36 years of piano playing experience, she can play a piece accurately.  Having software "interpret" and "adjust" her playing basically ruins the composition capture.  We will continue to "fiddle" with the various settings and, as soon as the phone support reopens on Tuesday, we will call for technical assistance.
