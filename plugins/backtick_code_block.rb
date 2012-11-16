require './plugins/pygments_code'
require 'base64'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  OpeningTag = "xxx6873A6F6-B5AB-49EB-A4A3-64C2504E5B98xxx"
  ClosingTag = "xxx265EBFD6-2E6F-48E6-A94E-8B9ED9199B6Exxx"
  def preprocess_code_blocks(input)
    @options = nil
    @caption = nil
    @lang = nil
    @url = nil
    @title = nil
    input.gsub(/^([ \t]*)`{3} *([^\n]+)?\n(.+?)\n[ \t]*`{3}/m) do
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
        blob = Base64.strict_encode64("<figure class='code'>#{@caption}#{code}</figure>")
        "#{indent}#{OpeningTag}#{blob}{ClosingTag} "
      else
        if @lang.include? "-raw"
          raw = "``` #{@options.sub('-raw', '')}\n"
          raw += str
          raw += "\n```\n"
        else
          code = highlight(str, @lang)
          blob = Base64.strict_encode64("<figure class='code'>#{@caption}#{code}</figure>")
          "#{indent}#{OpeningTag}#{blob}#{ClosingTag} "
        end
      end
    end
  end
  def postprocess_code_blocks(input)
    input.gsub(/#{OpeningTag}([a-zA-Z0-9\+\/=]*)#{ClosingTag}/) do
      Base64.decode64($1)
    end
  end
end
