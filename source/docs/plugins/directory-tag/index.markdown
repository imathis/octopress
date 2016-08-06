---
layout: page
title: "Directory Tag"
date: 2012-07-28 00:18
sidebar: false
footer: false
---

The directory tag lets you iterate over files at a particular path. If files conform to the standard Jekyll format, YYYY-MM-DD-file-title, then those attributes will be populated on the yielded file object. The `forloop` object maintains [its usual context](http://wiki.shopify.com/UsingLiquid#For_loops).

#### Syntax

{% raw %}
    {% directory path: path/from/source [reverse] [exclude] %}
      {{ file.url }}
      {{ file.name }}
      {{ file.date }}
      {{ file.slug }}
      {{ file.title }}
    {% enddirectory %}
{% endraw %}

##### Options:

- `reverse` - Defaults to 'false', ordering files the same way `ls` does: 0-9A-Za-z.
- `exclude` - Defaults to '.html$', a Regexp of files to skip.

##### File Attributes:

- `url` - The absolute path to the published file
- `name` - The basename
- `date` - The date extracted from the filename, otherwise the file's creation time
- `slug` - The basename with date and extension removed
- `title` - The titlecase'd slug

#### Example, images

The social icons in this project:

{% raw %}
    {% directory path: images/icon exclude: google %}
      <img src="{{ file.url }}" alt="{{ file.title }}" datetime="{{ file.date | date_to_xmlschema }}" />
    {% enddirectory %}
{% endraw %}

#### Output

{% directory path: images/icon exclude: google %}
  <img src="{{ file.url }}" alt="{{ file.title }}" datetime="{{ file.date | date_to_xmlschema }}" />
{% enddirectory %}

#### Example, downloads 

The fonts in this project:

{% raw %}
    {% directory path: fonts %}<a href="{{ file.url }}" >{{ file.name }}</a>{% unless forloop.last %}, {% endunless %}{% enddirectory %}
{% endraw %}

#### Output

{% directory path: fonts %}<a href="{{ file.url }}" >{{ file.name }}</a>{% unless forloop.last %}, {% endunless %}{% enddirectory %}

[&laquo; Plugins page](/docs/plugins)
