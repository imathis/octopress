---
layout: page
title: "Backtick Code Blocks"
date: 2011-07-26 23:42
sidebar: false
footer: false
---

With the `backtick_codeblock` filter you can use Github's lovely back tick syntax highlighting blocks.
Simply start a line with three back ticks followed by a space and the language you're using.

## Syntax

    ``` [language] [title] [url] [link text] [linenos:false] [start:#] [mark:#,#-#]
    code snippet
    ```
### Basic options

- `[language]` - Used by the syntax highlighter. Passing 'plain' disables highlighting.
- `[title]` - Add a figcaption to your code block.
- `[url]` - Download or reference link for your code.
- `[Link text]` - Text for the link, defaults to 'link'.

{% render_partial docs/plugins/_partials/options.markdown %}

## Examples

**1.** Here's an example without setting the language.

```
$ sudo make me a sandwich
```

*The source:*

    ```
    $ sudo make me a sandwich
    ```

**2.** This example uses syntax highlighting and a code link.

``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
class Fixnum
  def prime?
    ('1' * self) !~ /^1?$|^(11+?)\1+$/
  end
end
```

*The source:*

    ``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
    class Fixnum
      def prime?
        ('1' * self) !~ /^1?$|^(11+?)\1+$/
      end
    end
    ```

**3.** This example uses a custom starting line number and marks lines 52 and 54 through 55.

``` coffeescript Coffeescript Tricks start:51 mark:52,54-55
# Given an alphabet:
alphabet = 'abcdefghijklmnopqrstuvwxyz'

# Iterate over part of the alphabet:
console.log letter for letter in alphabet[4..8]
```

*The source:*

    ``` coffeescript Coffeescript Tricks start:51 mark:52,54-55
    # Given an alphabet:
    alphabet = 'abcdefghijklmnopqrstuvwxyz'

    # Iterate over part of the alphabet:
    console.log letter for letter in alphabet[4..8]
    ```

### Other ways to embed code snippets

You might also like to [embed code from a file](/docs/plugins/include-code) or [embed GitHub gists](/docs/plugins/gist-tag).
