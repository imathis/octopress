require 'pygments'

module HighlightCode
  def highlight(string, language)
    language = 'ruby' if language == 'ru'
    language = 'objc' if language == 'm'
    language = 'perl' if language == 'pl'
    language = 'yaml' if language == 'yml'

    Pygments.highlight(string, lexer: language, options: { encoding: 'utf-8', linenos: 'table' })
  end
end
