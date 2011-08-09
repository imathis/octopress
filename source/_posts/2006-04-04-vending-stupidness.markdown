--- 
layout: post
title: Vending Stupidness
date: 2006-4-4
comments: true
categories: life
link: false
---
The building where I work has a cafeteria on the ground floor, and vending machine areas on the third, forth, and fifth floors. Why the second floor got skipped is beyond me, and a subject for another rant.

The third floor vending room has a change machine, a soda machine, and a vending machine with the usual array of snacks and candies. Sodas are $0.75 each (water $1.25); items in the vending machine are either $0.75, $1.00, or $1.25. The maintenance schedule for the machines is haphazardous at best so on any given visit your odds on being faced with a change machine that is out of change, and a vending machine that is either out of change or unable to accept dollar bills, are high.

Some de-compiling of the vending machines interface was necessary to figure out what all of its messages meant.

<strong>Use Exact Change Only</strong> means it no longer can produce change. If you stick in more than the item costs, you aren't getting any money back. In this mode it'll still accept dollar bills.

<strong>Use Coins Only</strong> was a little trickier. At first glance this appears to mean no change can be given, like above. What it actually means is that machine's bill reader storage unit is full. It can still produce change, but it can't accept dollars any more.

Of course these two modes are hard-wired to the change machine. When the vending machine is either full of dollars or out of coin it triggers a state change in the bill changer causing it to be out of order. Fortunately there is a way to solve this problem: use the soda machine as a bill changer. It seemingly never runs out of change nor gets full of dollar bills; sticking a one into its slot and pressing the change return button produces four quarters. And sticking a quarter in and pressing the change return button results in two dimes and a nickel.

Having solved the puzzle like a good monkey I get my cheetos.
