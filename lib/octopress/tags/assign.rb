module Octopress
  class Assign < Liquid::Tag
    include VarHelpers
    include Conditional

    def initialize(tag_name, markup, tokens)
      @markup = markup
      super
    end

    def render(context)
      if strip_expression(@markup, context).strip =~ VarSyntax
        @to = $1
        @from = $2
      else
        raise SyntaxError.new("Syntax Error in 'assign' - Valid syntax: assign [var] = [source]")
      end
      if evaluate_expression @markup, context
        context.scopes.last[@to] = get_value(@from, context)
      end
      ''
    end
  end
end

Liquid::Template.register_tag('assign', Octopress::Assign)

