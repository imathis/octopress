# A Liquid tag for Jekyll sites that allows posting links to Debian BTS.
# by: Andrew Shadura
#
# Example usage: {% bts 123456 %} //adds a link to a bug #123456
#
# Or, you can just use debian/changelog format, like closes: #123456
# Launchpad bugs are also supported.

require 'cgi'
require './plugins/post_filters'

module Jekyll
  class DebbugsTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text           = text
    end

    def render(context)
      if parts = @text.match(/[#]?([\d]*)/)
        bug = parts[1].strip
        html_output_for bug
      else
        ""
      end
    end

    def html_output_for(bug)
      puts bug
      "<a href='http://bugs.debian.org/#{bug}'>##{bug}</a>"
    end

  end

  class ContentFilters < PostFilter
    def doit(input)
        input = input.gsub(/([Cc]loses: +)(#?)([0-9]+)((, +)(#?)([0-9]+))?/) do
            r = "#{$1}<a href=\"http://bugs.debian.org/#{$3}\">#{$2}#{$3}</a>"
            i = 4
            while ($~[i])
                pre = $~[i + 1]
                hash = $~[i + 2]
                bug = $~[i + 3]
                r += "#{pre}<a href=\"http://bugs.debian.org/#{bug}\">#{hash}#{bug}</a>"
                i += 4
            end

            r
        end
        input.gsub(/(LP: +)(#?)([0-9]+)/, "\\1<a href=\"https://bugs.launchpad.net/bugs/\\3\">\\2\\3</a>")
    end

    def pre_render(post)
      post.content = doit(post.content)
    end
  end
end

Liquid::Template.register_tag('bts', Jekyll::DebbugsTag)
