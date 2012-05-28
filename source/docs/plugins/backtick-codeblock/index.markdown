---
layout: page
title: "Backtick Code Blocks"
date: 2011-07-26 23:42
sidebar: false
footer: false
---

With the `backtick_codeblock` filter you can use Github's lovely back tick syntax highlighting blocks.
Simply start a line with three back ticks followed by a space and the language you're using.

#### Syntax


    ``` [language] [title] [url] [link text] [start:#]
    code snippet
    ```


#### Example (plain)

    ```
    $ sudo make me a sandwich
    ```

``` linenos:false
$ sudo make me a sandwich
```

#### Example With Syntax Highlighting a Caption and Link

    ``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
    class Fixnum
      def prime?
        ('1' * self) !~ /^1?$|^(11+?)\1+$/
      end
    end
    ```

``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
class Fixnum
  def prime?
    ('1' * self) !~ /^1?$|^(11+?)\1+$/
  end
end
```

#### Example with a custom starting line number

    ``` coffeescript Coffeescript Tricks start:51 mark:52,54-55
    # Given an alphabet:
    alphabet = 'abcdefghijklmnopqrstuvwxyz'

    # Iterate over part of the alphabet:
    console.log letter for letter in alphabet[4..8]
    ```

``` coffeescript Coffeescript Tricks start:51 mark:52,54-55
# Given an alphabet:
alphabet = 'abcdefghijklmnopqrstuvwxyz'

# Iterate over part of the alphabet:
console.log letter for letter in alphabet[4..8]
```
