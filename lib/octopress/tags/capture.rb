module Octopress
  class Capture < Liquid::Block
    include Conditional
    WordRegex = '[[:word:]]'
    Syntax = /(#{WordRegex}+)/o
    def initialize(tag_name, markup, tokens)
      @markup = markup
      super
    end

    def render(context)
      if evaluate_expression @markup, context
        if strip_expression(@markup, context).strip =~ Syntax
          @to = $1
        else
          raise SyntaxError.new("Syntax Error in 'capture' - Valid syntax: capture [var]")
        end
        output = super
        context.scopes.last[@to] = output
      end
      ''
    end
  end
end

Liquid::Template.register_tag('capture', Octopress::Capture)
