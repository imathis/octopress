# Title: Simple Image tag for Jekyll
# Authors: Brandon Mathis http://brandonmathis.com
#          Felix Schäfer, Frederic Hemberger
# Description: Easily output images with optional class names, width, height, title and alt attributes
#
# Syntax {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | "title text" ["alt text"]] %}
#
# Examples:
# {% img /images/ninja.png Ninja Attack! %}
# {% img left half http://site.com/images/ninja.png Ninja Attack! %}
# {% img left half http://site.com/images/ninja.png 150 150 alt:"Ninja in attack posture" title:"Ninja Attack!" %}
#
# Output:
# <img src="/images/ninja.png">
# <img class="left half" src="http://site.com/images/ninja.png" alt="Ninja Attack!">
# <img class="left half" src="http://site.com/images/ninja.png" width="150" height="150" alt="Ninja in attack posture" title="Ninja Attack!">
#

module Jekyll

  class ImageTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      @img  = nil
      title = nil
      alt   = nil
      attributes = ['class', 'src', 'width', 'height', 'alt']

      markup =~ /alt:(".+?")\s*/i
        alt = $1
        markup.sub! /alt:".+?"\s*/i, ''

      markup =~ /title:(".+?")\s*/i
        title = $1
        markup.sub! /title:".+?"\s*/i, ''

      if markup =~ /(?<class>[\S\s]*?)?\s*?(?<src>\S+\.\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?\s*("?(?<alt>[^"]+)"?)?/i
        @img = attributes.reduce({}) { |img, attr| img[attr] = $~[attr].strip if $~[attr]; img }
        @img['alt'] = alt unless alt.nil?
        @img['title'] = title unless title.nil?
      end
      super
    end

    def render(context)
      if @img
        "<img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>"
      else
        "Error processing input, expected syntax: {% img [class name(s)] path/to/image [width [height]] [alt:\"alt text\"] [title:\"title text\"] %}"
      end
    end
  end
end

Liquid::Template.register_tag('img', Jekyll::ImageTag)
