module Octopress
  class IncludeTag < Liquid::Tag
    include IncludeHelper
    include Conditional
    def initialize(tag_name, markup, tokens)
      @markup = markup.strip
      super
    end

    def render(context)
      if evaluate_expression @markup, context
        file = get_include(strip_expression(@markup, context), context).first
        render_include(file, context) if file
      else
        ''
      end
    end
  end

  class ExistsTag < Liquid::Tag
    include IncludeHelper
    def initialize(tag_name, markup, tokens)
      @file = markup.strip
      super
    end

    def render(context)
      exists(@file, context)
    end
  end

  class WrapTag < Liquid::Block
    include VarHelpers
    include IncludeHelper
    HasContent = /(.*?)({=\s*render\s*})(.*)/im

    def initialize(tag_name, markup, tokens)
      @markup = markup.strip
      super
    end

    def wrap_include(file, content, context)
      if content =~ HasContent
        $1 + render_include(file, context) + $3
      else
        raise SyntaxError.new("Syntax Error in 'wrap_include' - Valid syntax: {% wrap_include template/file.html %}\n[<div>]{= render }[</div>]\n{% endwrap_include %}")
      end
    end

    def render(context)
      if evaluate_expression @markup, context
        file = get_include(strip_expression(@markup, context), context)
        wrap_include(file, super.strip, context) if file
      else
        ''
      end
    end
  end
end

Liquid::Template.register_tag('exists', Octopress::ExistsTag)
Liquid::Template.register_tag('include', Octopress::IncludeTag)
Liquid::Template.register_tag('wrap', Octopress::WrapTag)
