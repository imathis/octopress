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
require './lib/octopress/codeblock.rb'

module Jekyll

  class CodeBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      if markup.strip =~ /\s*lang:(\w+)/i
        @language = $1
        markup = markup.strip.sub(/lang:\w+/i,'')
      end

      if markup =~ /(.+?)(https?:\/\/\S+)\s*(.+)?/i
        @title     = $1
        @link_href = $2
        @link_name = $3
      elsif markup =~ /(.+)?/i
        @title     = $1
      end
      @title.strip! if @title
      super
    end

    def render(context)
      code    = super.join

      CodeBlockHighlighter.new(code, {
        :language  => @language,
        :title     => @title,
        :link_href => @link_href,
        :link_name => @link_name || 'download'
      }).render(context)
    end
  end
end

Liquid::Template.register_tag('codeblock', Jekyll::CodeBlock)
