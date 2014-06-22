---
layout: post
title: "kitchen-tmux"
date: 2014-06-21 22:18:35 -0700
comments: true
categories:  test-kitchen, chef
---
The more I work with [test-kitchen](http://kitchen.ci), the more I have wanted a different workflow. Essentially, I really liked the idea of concurrency, but I struggled to parse the output. As a result, I found myself opening a number of windows in tmux and running `kitchen test <OS>`.

This idea and some Saturday night hacking has resulted in `kitchen-tmux`. Instead of going through each OS, I create a new session and then a window for each of the sessions. I haven't used it as part of my workflow yet, but playing with it a bit, this seems like it is going to be a huge win. You can find the code on [GitHub](https://github.com/cwebberOps/dotfiles/blob/master/bin/kitchen-tmux) or below:

{% codeblock lang:bash %}
#!/bin/bash

SESSION=${PWD##*/}
PWD=$(pwd)
tmp=$TMUX

unset TMUX

tmux -2 new-session -d -s $SESSION

for x in $(kitchen list -b); do
  tmux new-window -t $SESSION -n "$x"
  tmux send-keys -t $SESSION  "kitchen test $x
"
done

tmux select-window -t $SESSION:1

export TMUX=$tmp
tmux switch-client -t $SESSION
{% endcodeblock %}

Hopefully this is useful to more than just me.
