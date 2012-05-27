require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)(https?:\/\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input)
    input.encode!("UTF-8")
    input.gsub /^`{3}(.+?)`{3}/m do
      str = $1.to_s
      linenos = true
      start = 1
      str.gsub /([^\n]+)?\n(.+?)\Z/m do
        @options = $1 || ''
        code = $2.to_s
        if @options =~ /\s*linenos:false/i
          linenos = false
          @options = @options.sub(/\s*linenos:false/i,'')
        end
        if @options =~ /\s*start:(\d+)/i
          start = $1.to_i
          @options = @options.sub(/\s*start:\d+/i,'')
        end
        if @options =~ AllOptions
          highlight(code, $1, {caption: $2, url: $3, anchor: $4 || 'Link', linenos: linenos, start: start})
        elsif @options =~ LangCaption
          highlight(code, $1, {caption: $2 || '', linenos: linenos, start: start})
        else
          highlight(code, 'plain', {linenos: linenos, start: start})
        end
      end
    end
  end
end
