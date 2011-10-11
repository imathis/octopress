---
layout: post
title: "Test Posting for Various Fixes"
date: 2011-09-21 09:24
comments: true
categories: 
---

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo.

## Backtick Codeblock
### [language] [title] [url] [link text]
```
	puts "Hello, #{name}!"
```

``` ruby
	puts "Hello, #{name}!"
```

``` ruby Lorem ipsum
	puts "Hello, #{name}!"
```

``` ruby Lorem ipsum http://example.com
	puts "Hello, #{name}!"
```

``` ruby Lorem ipsum http://example.com Link title
	puts "Hello, #{name}!"
```


## Include Code
### [title] [lang:language] path/to/file

{% include_code pinboard.js %}

{% include_code Lorem ipsum pinboard.js %}

{% include_code Lorem ipsum lang:ruby pinboard.js %}



## Codeblock
### [title] [lang:language] [url] [link text]
{% codeblock %}
$ rm -rf ~/PAIN
{% endcodeblock %}

{% codeblock Lorem ipsum %}
$ rm -rf ~/PAIN
{% endcodeblock %}

{% codeblock Lorem ipsum lang:sh %}
$ rm -rf ~/PAIN
{% endcodeblock %}

{% codeblock Lorem ipsum lang:sh http://example.com/myfilename.sh %}
$ rm -rf ~/PAIN
{% endcodeblock %}

{% codeblock Lorem ipsum lang:javascript myfile.sh http://example.com/myfilename.sh Link title %}
$ rm -rf ~/PAIN
{% endcodeblock %}



## Markdown Code (just with tab)
    def hello_world(name)
      puts "Hello, #{name}!"
    end

