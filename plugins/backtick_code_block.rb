require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)(https?:\/\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input)
    input.encode!("UTF-8")
    input.gsub /^`{3}(.+?)`{3}/m do
      str = $1.to_s
      str.gsub /([^\n]+)?\n(.+?)\Z/m do
        markup = $1 || ''
        code = $2.to_s

        linenos = get_linenos(markup)
        markup = replace_linenos(markup)

        marks = get_marks(markup)
        markup = replace_marks(markup)
        
        start = get_start(markup)
        markup = replace_start(markup)

        if markup =~ AllOptions
          highlight(code, $1, {caption: $2, url: $3, anchor: $4 || 'Link', linenos: linenos, start: start, marks: marks})
        elsif markup =~ LangCaption
          highlight(code, $1, {caption: $2 || nil, linenos: linenos, start: start, marks: marks})
        else
          highlight(code, 'plain', {linenos: linenos, start: start})
        end
      end
    end
  end
end
