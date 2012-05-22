# Author: Brandon Mathis
# Description: Provides plugins with a method for wrapping and unwrapping input to prevent Markdown and Textile from parsing it.
# Purpose: This is useful for preventing Markdown and Textile from being too aggressive and incorrectly parsing in-line HTML.
module TemplateWrapper
  # Wrap input with a <div>
  def safe_wrap(input)
    "<!--escape--><div class='escape-wrapper'><notextile><!--content-->#{input}<!--end-content--></notextile></div><!--end-escape-->"
  end
  # This must be applied after the
  def unwrap(input)
    input.gsub /<!--escape-->([\s\S]*?)<!--content-->(.+?)<!--end-content-->([\s\S]*?)<!--end-escape-->/m do
      $2
    end
  end
end

# Author: phaer, https://github.com/phaer
# Source: https://gist.github.com/1020852
# Description: Raw tag for jekyll. Keeps liquid from parsing text betweeen {% raw %} and {% endraw %}

module Jekyll
  class RawTag < Liquid::Block
    def parse(tokens)
      @nodelist ||= []
      @nodelist.clear

      while token = tokens.shift
        if token =~ FullToken
          if block_delimiter == $1
            end_tag
            return
          end
        end
        @nodelist << token if not token.empty?
      end
    end
  end
end

Liquid::Template.register_tag('raw', Jekyll::RawTag)
