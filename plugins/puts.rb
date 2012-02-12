# Title: Puts Tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Puts is a liquid tag block which outputs its contents to the terminal
#
# Example Usage:
# Lets say you've assigned some variable you need to test.
# {% assign noun = "toaster" %}
#
# Drop it in a puts block along with a way to identify it in the output.
# {% puts %}
# Look out he's got a {{ noun }}.
# {% endputs %}
#
# Outputs:
# >>> {% puts %} <<<
# Look out he's got a toaster.
#

module Jekyll
  class Puts < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      puts ">>> {% puts %} <<<"
      puts super.map(&:strip).join
    end
  end
end

Liquid::Template.register_tag('puts', Jekyll::Puts)
