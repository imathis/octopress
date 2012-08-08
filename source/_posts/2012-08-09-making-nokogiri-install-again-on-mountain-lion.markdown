avi.io---
layout: post
title: "Making Nokogiri install again on Mountain Lion"
date: 2012-08-09 00:04
comments: true
categories: 
---


```
 8035  brew install libxml2 libxslt
 8037  brew link libxml2 libxslt
 8039  mkdir temp
 8041  cd temp
 8042  ls
 8043  wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
 8044  tar xvfz libiconv-1.13.1.tar.gz
 8045  cd libiconv-1.13.1
 8046  ./configure --prefix=/usr/local/Cellar/libiconv/1.13.1
 8047  make
 8048  sudo make install
```

```
 8035  brew install libxml2 libxslt
 8037  brew link libxml2 libxslt
```

```
 8056  rvm reinstall ruby-1.9.3-p194
```