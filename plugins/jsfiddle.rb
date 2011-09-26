# Title: jsFiddle tag for Jekyll
# Author: Brian Arnold (@brianarn)
# Description:
#   Given a jsFiddle shortcode, outputs the jsFiddle iframe code.
#   Using 'default' will preserve defaults as specified by jsFiddle.
#
# Syntax: {% jsfiddle shorttag [tabs] [skin] [height] [width] %}
#
# Examples:
#
# Input: {% jsfiddle ccWP7 %}
# Output: <iframe style="width: 100%; height: 300px" src="http://jsfiddle.net/ccWP7/embedded/js,resources,html,css,result/light/"></iframe>
#
# Input: {% jsfiddle ccWP7 js,html,result %}
# Output: <iframe style="width: 100%; height: 300px" src="http://jsfiddle.net/ccWP7/embedded/js,html,result/light/"></iframe>
#

module Jekyll
  class JsFiddle < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      if markup =~ /(\w+)(\s+[\w,]+)?(\s+\w+)?(\s+\w+)?(\s+\w+)?/
        @fiddle = $1
        @sequence = 'js,resources,html,css,result'
        @skin = 'light'
        @height = '300px'
        @width = '100%'
        if $2 && $2.strip() != 'default'
          @sequence = $2.strip()
        end
        if $3 && $3.strip() != 'default'
          @skin = $3.strip()
        end
        if $4 && $4.strip() != 'default'
          @height = $4.strip()
        end
        if $5 && $5.strip() != 'default'
          @width = $5.strip()
        end
      end
    end # initialize

    def render(context)
      if @fiddle
        "<iframe style=\"width: #{@width}; height: #{@height}\" src=\"http://jsfiddle.net/#{@fiddle}/embedded/#{@sequence}/#{@skin}/\"></iframe>"
      else
        "Error processing input, expected syntax: {% jsfiddle [shortcode] %}"
      end
    end # render
  end # class JsFiddle
end #module Jekyll

Liquid::Template.register_tag('jsfiddle', Jekyll::JsFiddle)

# vim: set et sw=2 ts=2:
