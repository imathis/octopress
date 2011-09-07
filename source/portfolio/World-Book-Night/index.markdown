---
layout: page
title: "World Book Night"
sharing: true
footer: true
---

[Reading initiative.](http://www.worldbooknight.org/your-books/the-wbn-top-100-books)

The underlying site is built in Joomla CMS which in turn is built in PHP. It's really not my cup of tea.
I wrote the Users' Favourite Books section as PHP pages/modules which are plugged into the framework.
The demo was was written in Rails in three days. The PHP/Joomla port took four times as long!

The main page shows the top 100 favourite books. The popularity algorithm ranks favourites by number of votes weighted by where in the users' ranking order the book is placed.

{% img /images/portfolio/world-book-night/1.png %}

The user's list of favourites. The list can be re-ordered by dragging and dropping.

{% img /images/portfolio/world-book-night/2.png %}

The book search page with infinite scrolling (except IE which has to use a button). This was a doddle in Rails but a pain in PHP/Joomla. I had to replicate jQuery's load() function with Mootools.

{% img /images/portfolio/world-book-night/3.png %}

[Back to portfolio](/portfolio)