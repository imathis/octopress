--- 
layout: post
comments: "false"
title: Chords are Polymorphic
date: 2009-3-5
link: "false"
categories: nerdliness
---
In object oriented programming, polymorphism is defined as the ability of different objects to respond to the same message in different ways. Polymorphism is a Greek term meaning "many forms." While the term may seem intimidating, the basic idea couldn't be simpler: Each object can have a unique response to the same message.

Take people for example; ask a dozen people the same question and they all could determine their answers differently, but the meaning of the question and the form of the answer would be the same. The private mental process is different.

As I learn to play the piano, I am struck again and again by the similarity between music and programming. Music is a language, just like Java or Python, and it has its own syntax, rules, and constructs, just like Java or Python. Take chords, for example. (For the sake of this discussion I'm only going to talk about three-note chords. I haven't learned any chords with four or more notes.)

In programming a function is a set of instructions that performs a task and returns a value. The function may or may not accept an input value (or set of values). A chord is a musical function that accepts the scale as it's input value and returns a set of notes as its output. To use object oriented nomenclature, the scales are objects, and the chords are messages sent to those objects to perform some function.

The Major Scale object has 8 attributes, one for each scale degree. From <a title="Major Scale" href="http://en.wikipedia.org/wiki/Major_scale">Wikipedia</a>:
<blockquote>
<ul>
	<li>1st - Tonic (key note)</li>
	<li>2nd - Supertonic</li>
	<li>3rd - Mediant</li>
	<li>4th - Subdominant</li>
	<li> 5th - Dominant</li>
	<li>6th - Submediant</li>
	<li>7th - Leading note</li>
	<li>8th - Tonic (or octave)</li>
</ul>
</blockquote>
Chords are named using Roman numerals (for the most part), so you have the I chord (one chord), IV chord (four chord), and so on. The I chord always returns the 1st, 3rd, and 5th scale degrees. The IV chord always returns the 4th, 6th, and 8th scale degrees. The notes assigned to the scale degrees vary based on the scale in question.

Again, to use object oriented concepts; the Major scale class would define the eight scale degrees, and methods for each of the chords (I, IV, V, V7, et cetera). Each instance of a major scale (C, G, D, A, et cetera) would inherit the scale degrees and chord methods from the Major scale class. Something like this:
<p style="text-align: center;"><img class="aligncenter" title="scale class model" src="http://zanshin.net/images/scales.jpg" alt="" width="507" height="365" /></p>

The C Major scale is comprised of the following notes: C D E F G A B C. So a I chord in C Major would return C-E-G as the notes. A IV chord, F-A-C.

A G Major scale is comprised of G A B C D E F# G, so a IV chord would return C-E-G, just like the I chord in C Major.

The chord functions (I, IV, V) are polymorphic. They respond to the same question in different ways. Ask a D Major scale the IV chord question and you get G-B-D, ask the same IV chord question of F# Major and you get B-D#-F#. The chord function always returns the same scale degrees, but the result is polymorphic in that the scale degrees vary based on scale to which they are being applied.
