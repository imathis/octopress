require './lib/octopress/codeblock.rb'

module BacktickCodeBlock
  def render_code_block(input)
    input.gsub /^`{3} *([^\n]+)?\n(.+?)\n`{3}/m do
      metadata = $1 || ''
      code = $2
      code.gsub!(/^ {4}/, '') if code.match(/\A {4}/)

      if metadata =~ /([^\s]+)\s+(.+?)(https?:\/\/\S+)\s*(.+)?/i
        language  = $1
        title     = $2
        link_href = $3
        link_name = $4      
      elsif metadata =~ /([^\s]+)\s*(.+)?/i
        language  = $1
        title     = $2
      end

      if language && language.include?('-raw')
        raw = "``` #{metadata.sub('-raw', '')}\n"
        raw << code
        raw << "\n```\n"
      else
        codenblock = CodeBlockHighlighter.new(code, {
          :language  => language,
          :title     => title,
          :link_href => link_href,
          :link_name => link_name
        }).render
      end
    end 
  end
end
