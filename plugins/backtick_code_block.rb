require './plugins/pygments_code'

module BacktickCodeBlock
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input, ext)
    input.encode!("UTF-8")
    input.gsub /^`{3}(.+?)`{3}/m do
      str = $1.to_s
      str.gsub /([^\n]+)?\n(.+?)\Z/m do
        markup = $1 || ''
        code = $2.to_s

        @options = {}
        clean_markup = Octopress::Pygments.clean_markup(markup)

        if clean_markup =~ AllOptions
          @options = {
            lang: $1,
            title: $2,
            url: $3,
            link_text: $4,
          }
        elsif clean_markup =~ LangCaption
          @options = {
            lang: $1,
            title: $2
          }
        end

        @options = Octopress::Pygments.parse_markup(markup, @options)

        begin
          code = Octopress::Pygments.highlight(code, @options)
          code = "<notextile>#{code}</notextile>" if ext.match(/textile/)
          code
        rescue MentosError => e
          markup = "```#{original_markup}"
          Octopress::Pygments.highlight_failed(e, "```[language] [title] [url] [link text] [linenos:false] [start:#] [mark:#,#-#]\ncode\n```", markup, code)
        end
      end
    end
  end
end
