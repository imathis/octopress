---
layout: post
title: "searching through the history of commands you ran in terminal"
date: 2012-08-09 00:06
comments: true
categories: General
---

Whenever I am logged in to a server or even when I am working on my own machine, I keep searching through the command history through up and down arrows.

While this can be efficient if you have 2-3 commands, it can be quite frustrating to find specific commands.

That is something I keep doing over and over again, and now I have a better way, I just grep through the list of commands, find the one I want, copy it and paste it into a new command, and I'm done.

This saves me **a lot** of time.

Here's how:

To show the history of commands you just do:

```
history
```

You probably know the rest, but you can just pipe the history into grep and search your history

```
history | grep {command_or_part_of_command}
```

For example:

```
history | grep cp -R
```

Enjoy!