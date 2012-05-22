---
layout: page
title: "Puts - log from Liquid to the terminal"
date: 2011-07-22 09:14
sidebar: false
footer: false
---

Puts is a Liquid block which outputs its contents to your terminal with Ruby's `puts` command. This really handy when you're working on a Liquid tag or a Jekyll plugin and you want to to be able to peek behind the curtain at what Liquid sees.

#### Syntax

{% raw %}
    {% puts %}Optional Text: {{ some_liquid_variable }}{% endputs %}
{% endraw %}

This just outputs the contents of the block to the terminal. Note: Markdown, Textile and other converters run after liquid, so depending on where you use the block, you may see raw templating markup, not processed html.

#### Example 1

{% raw %}
    {% for post in site.posts %}
    {% puts %}Title: {{ post.title }}{% endputs %}
    {% endfor %}
{% endraw %}

#### Output:

{% raw %}
```
{% puts %} Title: Hello World, I just switched to Octopress
{% puts %} Title: Zombie Ninjas Attack: A survivor's retrospective
...
```
{% endraw %}

#### Example 2 - Longer content
If a line of output is wider than 80 characters it gets output in a puts block for easier marking.

{% raw %}
    {% for post in site.posts %}
    {% puts %}
    Title: {{ post.title }}
    Content: {{ post.content }}
    {% endputs %}
    {% endfor %}
{% endraw %}

#### Output

{% raw %}
```
{% puts %}
Title: Zombie Ninjas Attack: A survivor's retrospective
Content: Spoiler: You don't want to survive this. So there I was, standing in line
for a movie. I could hear hear some car alarms going off in the distance, but that
....
{% endputs %}
```
{% endraw %}

[&laquo; Plugins page](/docs/plugins)
