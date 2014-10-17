# Title: Simple Wikipedia tag for Jekyll
# Authors: Ollivier Robert <roberto@keltia.net>
# Description: Insert a link to a Wikipedia article with lang attribute.
#
# Based on image_tag.rb
#
# Syntax {% wp wikipedia_tag Text [lang] %}
#
# Examples:
# {% wp VIC_Cipher %}
# {% wp VIC_Cipher fr %}
# {% wp VIC_Cipher "" fr %}
# {% wp VIC_Cipher "VIC Cipher" %}
# {% wp VIC_Cipher "VIC Cipher" fr %}

# Output:
# <a href="http://en.wikipedia.org/wiki/VIC_Cipher">VIC_Cipher</a>
# <a href="http://en.wikipedia.org/wiki/VIC_Cipher">fr</a>
# <a href="http://fr.wikipedia.org/wiki/VIC_Cipher">VIC Cipher</a>
# <a href="http://en.wikipedia.org/wiki/VIC_Cipher">VIC Cipher</a>
# <a href="http://fr.wikipedia.org/wiki/VIC_Cipher">VIC Cipher</a>
#
# XXX if text == tag, then all '_' gets replaced by space
#

module Jekyll

  class WikipediaTag < Liquid::Tag
    @wp = nil

    def initialize(tag_name, markup, tokens)
      attributes = ['tag', 'text']

      if markup =~ /(?<tag>\S+)(?:\s+(?<text>.+))?/i
        @wp = attributes.reduce({}) { |wp, attr| wp[attr] = $~[attr].strip if $~[attr]; wp }

        if /(?:"|')(?<text>[^"']+)?(?:"|')(?<lang>\s+\S+)?/ =~ @wp['text']
          @wp['text'] = text
          @wp['lang'] = (lang || 'en').strip
        else
          @wp['text'] = @wp['text'] || @wp['tag'].gsub(/_/, ' ')
          @wp['lang'] = 'en'
        end
      end
      super
    end

    def render(context)
      if @wp
        lang = @wp['lang']
        tag  = @wp['tag']
        text = @wp['text'] || tag.gsub(/_/, ' ')
        "<a href=\"http://#{lang}.wikipedia.org/wiki/#{tag}\">#{text}</a>"
      else
        "Error processing input, expected syntax: {% wp wikipedia_tag [text | \"text\"] [lang] %}"
      end
    end
  end
end

Liquid::Template.register_tag('wp', Jekyll::WikipediaTag)
