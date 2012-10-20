require 'rouge'
require 'fileutils'
require 'digest/md5'

module HighlightCode
  def highlight(str, lang)
    lexer = Rouge::Lexer.find_fancy(lang) || Rouge::Lexers::Text
    formatter = Rouge::Formatters::HTML.new(:css_class => 'pre-code')
    pre = formatter.format(lexer.lex(str))
    %<<code class=#{lang.inspect}>#{pre}</code>>
  end
end
