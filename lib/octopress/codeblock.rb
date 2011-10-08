require './pygments_code'
require './plugins/raw'

class CodeBlockHighlighter
  include HighlightCode
  include TemplateWrapper

  def initialize(code, metadata = {})
    @code = code
    @meta = metadata

    @meta[:language] = $1 if @meta[:language].nil? && @meta[:link_name] =~ /\S[\S\s]*\w+\.(\w+)/
  end

  def render_caption
    title   = "<span>#{@meta[:title]}</span>" if @meta[:title]
    link    = "<a href='#{@meta[:link_href]}'>#{@meta[:link_name] || 'link'}</a>" if @meta[:link_href]
    "<figcaption>#{title}#{link}</figcaption>" if title || link
  end

  def render_code
    if @code
      if @meta[:language]
        source = highlight(@code, @meta[:language])
      else
        source = tableize_code(@code.strip.gsub(/</,'&lt;'))
      end
    end
  end

  def render(context = nil)
    code = render_code()
    if context
      code = safe_wrap(code)
      code = context['pygments_prefix'].strip << code if context['pygments_prefix']
      code = code << context['pygments_suffix'].strip if context['pygments_suffix']
    end
    "<figure class='code'>#{render_caption()}#{code}</figure>"
  end
end
