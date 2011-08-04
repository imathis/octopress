#
# Author: Adam Lindberg <eproxus@gmail.com>
#
# Outputs spans for each argument to the block separated by plus signs (+):
#
#   {% key Command + X %}
#
#   ...will output...
#
#   <span class='key-sequence'>
#     <span class='key'>Command</span>
#     <span class='key-sep' />
#     <span class='key'>X</span>
#   </span>
#

module Jekyll
  @keys = nil

  class KeyTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      @keys = markup
    end

    def render(context)
      keys = @keys.split(/[^\\]\+/)
      spans = keys.map { |k| "<span class='key'>#{k.strip}</span>" }
      return "<span class='key-sequence'>" +
        spans.join("<span class='key-sep' />") +
        "</span>"
    end
  end
end

Liquid::Template.register_tag('key', Jekyll::KeyTag)
