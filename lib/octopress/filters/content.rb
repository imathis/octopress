# encoding: utf-8

require File.expand_path("../helpers/titlecase.rb", File.dirname(__FILE__))
module Octopress
  module ContentFilters

    # Escapes CDATA sections in post content

    def cdata_escape(input)
      input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
    end

    # Used on the blog index to split posts on the <!--more--> marker

    def excerpt(input)
      if input.index(/<!--\s*more\s*-->/i)
        input.split(/<!--\s*more\s*-->/i)[0]
      else
        input
      end
    end

    # Checks for excerpts (helpful for template conditionals)

    def has_excerpt(input)
      input =~ /<!--\s*more\s*-->/i ? true : false
    end

    # Summary is used on the Archive pages to return the first block of content from a post.

    def summary(input)
      if input.index(/\n\n/)
        input.split(/\n\n/)[0]
      else
        input
      end
    end

    # Improved version of Liquid's truncate:
    # - Doesn't cut in the middle of a word.
    # - Uses typographically correct ellipsis (…) insted of '...'

    def truncate(input, length)
      if input.length > length && input[0..(length-1)] =~ /(.+)\b.+$/im
        $1.strip + ' &hellip;'
      else
        input
      end
    end

    # Improved version of Liquid's truncatewords:
    # - Uses typographically correct ellipsis (…) insted of '...'
    
    def truncatewords(input, length)
      truncate = input.split(' ')
      if truncate.length > length
        truncate[0..length-1].join(' ').strip + ' &hellip;'
      else
        input
      end
    end
  end
end

Liquid::Template.register_filter Octopress::ContentFilters

