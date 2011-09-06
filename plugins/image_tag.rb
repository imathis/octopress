# Title: Simple Image tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Easily output images with optional class names and title/alt attributes
#
# Syntax {% image [class name(s)] url [title text] %}
#
# Example:
# {% ima left half http://site.com/images/ninja.png Ninja Attack! %}
#
# Output:
# <image class='left' src="http://site.com/images/ninja.png" title="Ninja Attack!" alt="Ninja Attack!">
#

module Jekyll

  class ImageTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      @img = {}
      
      if markup =~ /(\S.*\s+)?(https?:\/\/|\/)(\S+)(\s+\d+\s+\d+)?(\s+.+)?/i
        @img[:src] = $2 + $3
        @img[:class] = $1 if $1
        @img[:title] = $5.strip if $5
        
        if $4 =~ /\s*(\d+)\s+(\d+)/
          @img[:width] = $1
          @img[:height] = $2
        end      
      end
      super
    end

    def render(context)
      
      output = super
      if @img[:src]
        
        attributes = []
        @img.each{ |key, value| attributes << "#{key}='#{value}'" }
        attributes = attributes.join(' ').gsub(/'/, '"')
        
        "<img #{attributes}>"
      else
        "Error processing input, expected syntax: {% img [class name(s)] /url/to/image [width height] [title text] %}"
      end
      
    end
  end
end

Liquid::Template.register_tag('img', Jekyll::ImageTag)
