require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input)
    input.encode!("UTF-8")
    input.gsub /^`{3}(.+?)`{3}/m do
      str = $1.to_s
      str.gsub /([^\n]+)?\n(.+?)\Z/m do
        markup = $1 || ''
        code = $2.to_s

        options    = parse_markup(markup)
        @lang      = options[:lang]
        @title     = options[:title]
        @lineos    = options[:lineos]
        @marks     = options[:marks]
        @url       = options[:url]
        @link_text = options[:link_text]
        @start     = options[:start]
        markup     = clean_markup(markup)

        if markup =~ AllOptions
          @lang      ||= $1
          @title     ||= $2
          @url       ||= $3
          @link_text ||= $4
        elsif markup =~ LangCaption
          @lang      ||= $1
          @title     ||= $2
        else
          @lang = 'plain'
        end
        highlight(code, @lang, {title: @title, url: @url, link_text: @link_text, linenos: @linenos, marks: @marks, start: @start })
      end
    end
  end
end
