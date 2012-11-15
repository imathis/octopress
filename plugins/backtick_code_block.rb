require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input)
    @options = nil
    @caption = nil
    @lang = nil
    @url = nil
    @title = nil
    input.gsub(/^((?: {4}|\t)*)`{3} *([^\n]+)?\n(.+?)\n(?: {4}|\t)*`{3}/m) do
      indent = $1
      @options = $2 || ''
      str = $3

      if @options =~ AllOptions
        @lang = $1
        @caption = "<figcaption><span>#{$2}</span><a href='#{$3}'>#{$4 || 'link'}</a></figcaption>"
      elsif @options =~ LangCaption
        @lang = $1
        @caption = "<figcaption><span>#{$2}</span></figcaption>"
      end

      if not(indent.empty?)
        str = str.gsub(/^#{indent}/, '')
      end
      if str.match(/\A( {4}|\t)/)
        str = str.gsub(/^( {4}|\t)/, '')
      end
      if @lang.nil? || @lang == 'plain'
        code = tableize_code(str.gsub('<','&lt;').gsub('>','&gt;').gsub('&','&amp;'))
        "#{indent}<figure class='code'>#{@caption}#{code}</figure>"
      else
        if @lang.include? "-raw"
          raw = "``` #{@options.sub('-raw', '')}\n"
          raw += str
          raw += "\n```\n"
        else
          code = highlight(str, @lang)
          "#{indent}<figure class='code'>#{@caption}#{code}</figure>"
        end
      end
    end
  end
end
