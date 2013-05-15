module Octopress
  class Return < Liquid::Tag
    include VarHelpers
    include Conditional

    def initialize(tag_name, markup, tokens)
      @markup = markup.strip
      super
    end

    def render(context)
      if evaluate_expression @markup, context
        get_value(strip_expression(@markup, context), context)
      else
        ''
      end
    end
  end
end

Liquid::Template.register_tag('return', Octopress::Return)
