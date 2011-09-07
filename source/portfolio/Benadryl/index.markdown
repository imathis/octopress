---
layout: page
title: "Benadryl"
sharing: true
footer: true
---

A much needed makeover for [Benadryl](http://www.benadryl.co.uk/).

The previous clunking all-Flash bunker was broken up and mostly HTML-ized.

Mobile devices are detected by [WURFL](http://wurfl.sourceforge.net/) and specific views are presented by an extension to the ViewEngine. Web and mobile pages shares the same page content which is data from the model.

The site's design was supplied as images which were then cut up in order to build the HTML and style sheets.

{% img /images/portfolio/benadryl-two/1.png %}

Javascript and Ajax pull in the pollen data and nearby store information.

{% img /images/portfolio/benadryl-two/2.png %}

{% img /images/portfolio/benadryl-two/3.png %}

{% img /images/portfolio/benadryl-two/4.png %}

{% img /images/portfolio/benadryl-two/5.png %}

{% img /images/portfolio/benadryl-two/6.png %}

To keep things lean, there is no jQuery at all in the [mobile site](http://www.benadryl.co.uk/m). Ajax is pure Xhr and DOM manipulation is pure getElementById() and so forth.

{% img /images/portfolio/benadryl-two/7.png %}

As we don't need interactivity on the mobile view we can use a Google static map which loads super quickly.

{% img /images/portfolio/benadryl-two/8.png %}

[Back to portfolio](/portfolio)
