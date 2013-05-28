module Octopress
  class Assign < Liquid::Tag
    include VarHelpers
    include Conditional

    def initialize(tag_name, markup, tokens)
      @markup = markup
      super
    end

    def render(context)
      if strip_expression(@markup, context).strip =~ VAR_SYNTAX
        @to = $1
        @operator = $2
        @from = $3
      else
        raise SyntaxError.new("Syntax Error in 'assign' - Valid syntax: assign [var] = [source]")
      end
      if evaluate_expression @markup, context
        value = get_value(@from, context)

        if @operator == '+=' && !context.scopes.last[@to].nil?
          context.scopes.last[@to] += value 
        else
          context.scopes.last[@to] = value
        end
      end
      ''
    end
  end
end

Liquid::Template.register_tag('assign', Octopress::Assign)

