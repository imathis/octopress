module Jekyll
  class IncludeSidebarTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
    super
      @file = file.strip
    end

    def render(context)
      file = (@file == "" ? context['page.sidebar'] : @file)
      if file.include? 'site.'
        file = context[file]
      end
      render_include "sidebars/#{file}", context
    end

    def render_include(file, context)
      tag = IncludeTag.new('', file, [])
      tag.render(context)
    end
  end

end

Liquid::Template.register_tag('include_sidebar', Jekyll::IncludeSidebarTag)
