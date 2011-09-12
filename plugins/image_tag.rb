# Title: Simple Image tag for Jekyll
# Authors: Brandon Mathis http://brandonmathis.com
#          Felix Schäfer
# Description: Easily output images with optional class names, width, height, title and alt attributes
#
# Syntax {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | "title text" ["alt text"]] %}
#
# Examples:
# {% img /images/ninja.png Ninja Attack! %}
# {% img left half http://site.com/images/ninja.png Ninja Attack! %}
# {% img left half http://site.com/images/ninja.png 150 150 "Ninja Attack!" "Ninja in attack posture" %}
#
# Output:
# <img src='/images/ninja.png'>
# <img class='left half' src='http://site.com/images/ninja.png' title='Ninja Attack!' alt='Ninja Attack!'>
# <img class='left half' src='http://site.com/images/ninja.png' width='150' height='150' title='Ninja Attack!' alt='Ninja in attack posture'>
#

module Jekyll
  class ImageTag < Liquid::Tag
    TAGS = [:class, :src, :width, :height, :title, :alt]

    CLASS = /(?:(?<class>[^'"\s][^'"]*)\s+)/
    SRC = /(?:(?<src>(https?:\/\/|\/)([^'"\s]+)))/i
    WIDTH = /(?:\s+(?<width>\d+))/
    HEIGHT = /(?:\s+(?<height>\d+))/
    DIMENSIONS = /#{WIDTH}(?:#{HEIGHT})?/  # height is optional
    UNQUOTED_TITLE = /(?:\s+(?<title>[^'"\s][^'"]*?))/
    QUOTED_TITLE = /(?:\s+(?<title_quote>['"])(?<quoted_title>[^'"]*)\g<title_quote>)/
    QUOTED_ALT = /(?:\s+(?<alt_quote>['"])(?<alt>[^'"]*)\g<alt_quote>)/
    TITLE_AND_ALT = /(?:#{UNQUOTED_TITLE}|#{QUOTED_TITLE}(?:#{QUOTED_ALT})?)/  # alt is optional
    IMG = /\A#{CLASS}?#{SRC}#{DIMENSIONS}?#{TITLE_AND_ALT}?\s*\Z/  # class, dimensions title and alt are optional

    def initialize(tag_name, markup, tokens)
      if markup =~ IMG
        @img = TAGS.reduce({}) {|img,tag| img[tag] = $~[tag]; img}
        @img[:title] ||= $~[:quoted_title]
        # Make sure alt is set if we have something to put in there
        @img[:alt] ||= @img[:title]
      end
      super
    end

    def render(context)
      output = super
      if @img
        "<img #{@img.collect {|k,v| "#{k.to_s}='#{v}'" if v}.compact.join(" ")}>"
      else
        "Error processing input, expected syntax: {% img [class name(s)] /url/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
      end
    end
  end
end

Liquid::Template.register_tag('img', Jekyll::ImageTag)
