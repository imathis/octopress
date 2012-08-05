---
layout: post
title: "problem with running spec in vim"
date: 2012-08-05 22:02
comments: true
categories: General
---

I have been using Vim for almost a week now.

I am using the [dotvim](http://github.com/astrails/dotvim) configuration by [Astrails](http://astrails.com).

All in all, the configuration is awesome and I completely love it, it's the longest time period I have ever used Vim. Considering that the second place is about 5 minutes, that's super impressive.

I only have one problem with it.

I took the spec running functions from [Gary Bernhardt](https://github.com/garybernhardt) [dotfiles](https://github.com/garybernhardt/dotfiles/), I just remapped the keys differently.

```
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>' :call RunTestFile()<cr>
map <leader>; :call RunNearestTest()<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
```

As you can see, I mapped `,;` to run line specs, and `,'` to run the entire spec file.

The problem is, that the terminal exists immediately after the result, does not wait for me to hit `Enter` or anything.

You can see the problem demo in this YouTube Video

{% youtube gUB48XwNq0M %}

I asked this question on StackOverflow [here](http://stackoverflow.com/questions/11785035/vim-issue-with-running-specs-in-ruby-rspec/11785791#11785791)

Someone suggested it might be a trailing character, but I checked and there's nothing like that.

The same person suggested to map just `ls` like so:

```
nmap <leader>ls :!ls<cr>
```

But this command does not exit.

Another thing I tried is this
In a vim session I mapped a key like this

```
map <Leader>~ :!rspec %<cr>
```

When I used it, the terminal did not exit as well.

Vim Experts, what am I missing here?

Running specs all the time is something crucial to my workflow, I don't want to hide vim very time, it breaks my flow.

Any help appreciated.

My entire vim configuration is here: [link](http://www.github.com/kensodev/dotvim)