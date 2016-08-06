# Title: plnkr tag for Jekyll
# Author: Jarrett Meyer (@jarrettmeyer)
# Description:
#   Given a plnkr tag, outputs the plnkr iframe code.
#   Based on the jsFiddle plugin by Brian Arnold (@brianarn)
#
# Syntax: {% plnkr tag [height] [width] %}
#
# Examples:
#
# Input: {% plnkr YLJx5K5Cp7c9K9yf65vj %}
# Output: <iframe style="width: 100%; height: 300px" src="http://embed.plnkr.co/YLJx5K5Cp7c9K9yf65vj/preview"></iframe>
#
# Input: {% plnkr YLJx5K5Cp7c9K9yf65vj 500px 400px %}
# Output: <iframe style="width: 400px; height: 500px" src="http://embed.plnkr.co/YLJx5K5Cp7c9K9yf65vj/preview"></iframe>
#

module Jekyll
  class Plnkr < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @markup = markup
      if /(?<plnkr>\w+)(?:\s+(?<height>\w+))?(?:\s+(?<width>\w+))?/ =~ @markup
        @plnkr  = plnkr
        @width  = width  || '100%'
        @height = height || '300px'
      end
    end

    def render(context)
      if @plnkr
        "<iframe style=\"width: #{@width}; height: #{@height}\" frameborder=\"0\" seamless=\"seamless\" src=\"http://embed.plnkr.co/#{@plnkr}/preview\"></iframe>"
      else
        "Error processing input, expected syntax: {% plnkr tag [height] [width] %}"
      end
    end
  end
end

Liquid::Template.register_tag('plnkr', Jekyll::Plnkr)
