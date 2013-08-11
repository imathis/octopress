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

module Jekyll

  class CodeBlock < Liquid::Block
    TitleUrlLinkText = /(\S[\S\s]*)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
    Title = /(\S[\S\s]*)/
    def initialize(tag_name, markup, tokens)

      @markup = markup
      clean_markup = Octopress::Pygments.clean_markup(markup)
      if clean_markup =~ TitleUrlLinkText
        @options = {
          title:     $1,
          url:       $2,
          link_text: $3
        }
      elsif clean_markup =~ Title
        @options = { title: $1 }
      end

      # grab lang from filename in title
      if @options[:title] =~ /\S[\S\s]*\w+\.(\w+)/ && @options[:lang].nil?
        @options[:lang] = $1
      end

      @options = Octopress::Pygments.parse_markup(markup, @options)

      super
    end

    def render(context)
      begin
        code = super.strip
        code = Octopress::Pygments.highlight(code, @options)
        code = context['pygments_prefix'] + code if context['pygments_prefix']
        code = code + context['pygments_suffix'] if context['pygments_suffix']
        code
      rescue MentosError => e
        markup = "{% codeblock #{@markup} %}"
        Octopress::Pygments.highlight_failed(e, "{% codeblock [lang:language] [title] [url] [link text] [start:#] [mark:#,#-#] [linenos:false] %}\ncode\n{% endcodeblock %}", markup, code)
      end
    end
  end
end

Liquid::Template.register_tag('codeblock', Jekyll::CodeBlock)
