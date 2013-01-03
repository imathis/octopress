require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input, ext)
    escape = ext ? ext.match(/textile/) != nil : false
    input.encode!("UTF-8")
    input.gsub /^`{3}(.+?)`{3}/m do
      str = $1.to_s
      str.gsub /([^\n]+)?\n(.+?)\Z/m do
        markup = $1 || ''
        code = $2.to_s

        opts     = parse_markup(markup)
        @options = {
          lang:      opts[:lang],
          title:     opts[:title],
          lineos:    opts[:lineos],
          marks:     opts[:marks],
          url:       opts[:url],
          link_text: opts[:link_text] || 'link',
          start:     opts[:start]     || 1,
          escape:    opts[:escape]    || escape
        }
        markup     = clean_markup(markup)

        if markup =~ AllOptions
          @options[:lang]      ||= $1
          @options[:title]     ||= $2
          @options[:url]       ||= $3
          @options[:link_text] ||= $4
        elsif markup =~ LangCaption
          @options[:lang]      ||= $1
          @options[:title]     ||= $2
        else
          @options[:lang]      ||= 'plain'
        end
        highlight(code, @options)
      end
    end
  end
end
