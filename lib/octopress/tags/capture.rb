module Octopress
  class Capture < Liquid::Block
    include Conditional
    WORD_REGEX = '[[:word:]]'
    SYNTAX = /(#{WORD_REGEX}+)\s*(\+=)?/o
    def initialize(tag_name, markup, tokens)
      @markup = markup
      super
    end

    def render(context)
      if evaluate_expression @markup, context
        if strip_expression(@markup, context).strip =~ SYNTAX
          @to = $1
          @operator = $2
        else
          raise SyntaxError.new("Syntax Error in 'capture' - Valid syntax: capture [var]")
        end
        output = super
        if @operator == '+=' && !context.scopes.last[@to].nil?
          context.scopes.last[@to] += output 
        else
          context.scopes.last[@to] = output
        end
      end
      ''
    end
  end
end

Liquid::Template.register_tag('capture', Octopress::Capture)
