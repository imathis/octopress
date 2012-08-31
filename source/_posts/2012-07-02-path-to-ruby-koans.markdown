---
layout: post
title: "Path to Ruby Koans"
date: 2012-07-02 16:23
comments: true
published: false
categories: Ruby
---

# about_nil.rb

    # THINK ABOUT IT:
    #
    # Is it better to use
    #    obj.nil?
    # or
    #    obj == nil
    # Why?

Use `obj.nil?`, seems that that's a method of inspection.

# about_objects.rb

    # THINK ABOUT IT:
    # What pattern do the object IDs for small integers follow?

ID = 2 * integer + 1

# about_hashes.rb

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?
    
I want to be alerted when accessing keys not existed?
    
    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?

I will be considered as a block.

But the stable version now has a bug on this, see [this](https://github.com/edgecase/ruby_koans/commit/7f29082e95c894ea94c8eb4d1db15d07dd1ba671).

# about_strings.rb

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?

Because shovel operator is faster and do not create a copy of original string.

Shovel operator is a alias of `contact()`, and plus equals operator is syntactic shorthand for `a = a + b`.

See [this](http://stackoverflow.com/questions/4684446/why-is-the-shovel-operator-preferred-over-plus-equals-when-building-a).

    # Surprised?
No.

# about_symbols.rb

    # THINK ABOUT IT:
    #
    # Why do we convert the list of symbols to strings and then compare
    # against the string value rather than against symbols?
  
Because reference to a symbol may accidentally create the symbol itself, in some implementations, `assert_equal true, Symbol.all_symbols.include?(:whatever_you_type)` will always pass.

See [this](http://stackoverflow.com/questions/4686097/ruby-koans-why-convert-list-of-symbols-to-strings
).

    # THINK ABOUT IT:
    #
    # Why is it not a good idea to dynamically create a lot of symbols?

Because they can't be freed and will stay in memory.

See [this](http://stackoverflow.com/questions/4573991/why-is-it-not-a-good-idea-to-dynamically-create-a-lot-of-symbols-in-ruby).

# about_regular_expressions.rb

    # THINK ABOUT IT:
    #
    # When would * fail to match?

I don't know.    

    # THINK ABOUT IT:
    #
    # We say that the repetition operators above are "greedy."
    #
    # Why?

Learn regular expression by yourself.

    # THINK ABOUT IT:
    #
    # Explain the difference between a character class ([...]) and alternation (|).

...
    
# about_constants.rb

    # QUESTION: Which has precedence: The constant in the lexical scope,
    # or the constant from the inheritance hierarchy?

The constant in the lexical scope.

    # QUESTION: Now which has precedence: The constant in the lexical
    # scope, or the constant from the inheritance hierarchy?  Why is it
    # different than the previous answer?

