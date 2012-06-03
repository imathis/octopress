# Title: Simple Code Blocks for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Write codeblocks with semantic HTML5 <figure> and <figcaption> elements and optional syntax highlighting — all with a simple, intuitive interface.
#
# Syntax:
# {% codeblock [title] [url] [link text] %}
# code snippet
# {% endcodeblock %}
#
# For syntax highlighting, put a file extension somewhere in the title. examples:
# {% codeblock file.sh %}
# code snippet
# {% endcodeblock %}
#
# {% codeblock Time to be Awesome! (awesome.rb) %}
# code snippet
# {% endcodeblock %}
#
# Example:
#
# {% codeblock Got pain? painreleif.sh http://site.com/painreleief.sh Download it! %}
# $ rm -rf ~/PAIN
# {% endcodeblock %}
#
# Output:
#
# <figure class='code'>
# <figcaption><span>Got pain? painrelief.sh</span> <a href="http://site.com/painrelief.sh">Download it!</a>
# <div class="highlight"><pre><code class="sh">
# -- nicely escaped highlighted code --
# </code></pre></div>
# </figure>
#
# Example 2 (no syntax highlighting):
#
# {% codeblock %}
# <sarcasm>Ooooh, sarcasm... How original!</sarcasm>
# {% endcodeblock %}
#
# <figure class='code'>
# <pre><code>&lt;sarcasm> Ooooh, sarcasm... How original!&lt;/sarcasm></code></pre>
# </figure>
#
require './plugins/pygments_code'
require './plugins/raw'

module Jekyll

  class CodeBlock < Liquid::Block
    include HighlightCode
    CaptionUrlTitle = /(\S[\S\s]*)\s+(https?:\/\/)(\S+)\s+(.+)/i
    CaptionUrl = /(\S[\S\s]*)\s+(https?:\/\/)(\S+)/i
    Caption = /(\S[\S\s]*)/
    def initialize(tag_name, markup, tokens)
      @caption = nil
      @url = nil
      
      @lang = get_lang(markup)
      markup = replace_lang(markup)

      @linenos = get_linenos(markup)
      markup = replace_linenos(markup)

      @marks = get_marks(markup)
      markup = replace_marks(markup)
      
      @start = get_start(markup)
      markup = replace_start(markup)

      if markup =~ CaptionUrlTitle
        @caption = $1
        @url = $2 + $3
        @anchor = $4
      elsif markup =~ CaptionUrl
        @caption = $1
        @url = $2 + $3
      elsif markup =~ Caption
        @caption = $1
      end
      if @caption =~ /\S[\S\s]*\w+\.(\w+)/ && @lang.nil?
        @lang = $1
      end
      super
    end

    def render(context)
      code = super.strip
      code = highlight(code, @lang, {caption: @caption, url: @url, anchor: @anchor, start: @start, marks: @marks, linenos: @linenos})
      code = context['pygments_prefix'] + code if context['pygments_prefix']
      code = code + context['pygments_suffix'] if context['pygments_suffix']
      code
    end
  end
end

Liquid::Template.register_tag('codeblock', Jekyll::CodeBlock)
