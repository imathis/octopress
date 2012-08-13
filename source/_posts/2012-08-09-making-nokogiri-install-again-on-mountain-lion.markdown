---
layout: post
title: "Making Nokogiri install again on Mountain Lion"
date: 2012-08-09 00:04
comments: true
categories: Ruby, Ruby on rails
---

As probably any geek out there, I upgraded my OS to Apple Mountain Lion.

The upgrade created a lot of problems for me, I basically had to reinstall almost everything, from MySql to homebrew.

I am not sure if everyone experienced the same thing, but that was the case for me.

One of the problems I encountered was that I could not install Nokogiri anymore on my machine, bundler would not install it and complain about dependencies not being installed (specifically `libxml`)

To fix it, you need to reinstall Ruby using RVM with livxml properly linked.

First, install `libxml` and `libxslt` through homebrew, like so:

```
brew install libxml2 libxslt
brew link libxml2 libxslt
```

If that doesn't work you probably need to install `libiconv` like so:

```
cd	
mkdir temp
cd temp
ls
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar xvfz libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/Cellar/libiconv/1.13.1
make
sudo make install
```

And then install `libxml` and `libxslt` again

```
brew install libxml2 libxslt
brew link libxml2 libxslt
```

Once that's done without errors, reinstall Ruby.

```
rvm reinstall ruby-1.9.3-p194
```

RVM will figure out those libraries location and properly install Ruby with those linked up.

Enjoy!