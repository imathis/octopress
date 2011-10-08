# Title: Include Code Tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
# Configuration: You can set default import path in _config.yml (defaults to code_dir: downloads/code)
#
# Syntax {% include_code path/to/file %}
#
# Example 1:
# {% include_code javascripts/test.js %}
#
# This will import test.js from source/downloads/code/javascripts/test.js
# and output the contents in a syntax highlighted code block inside a figure,
# with a figcaption listing the file name and download link
#
# Example 2:
# You can also include an optional title for the <figcaption>
#
# {% include_code Example 2 javascripts/test.js %}
#
# will output a figcaption with the title: Example 2 (test.js)
#
require './lib/octopress/codeblock.rb'

module Jekyll

  class IncludeCodeTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      if markup.strip =~ /\s*lang:(\w+)/i
        @language = $1
        markup = markup.strip.sub(/lang:\w+/i,'')
      end

      if markup.strip =~ /(.*)?(?:\s+|^)(\/*\S+)/i
        @title     = $1
        @link_href = $2
      end
      @title = @link_href if @title.nil? || @title.empty?
      super
    end

    def render(context)
      code_dir  = context.registers[:site].config['code_dir'].sub(/^\//,'') || 'downloads/code'

      file_path = File.expand_path(code_dir, context.registers[:site].source)
      file_name = "#{file_path}/#{@link_href}"

      if File.symlink?(file_path)
        return "Code directory '#{file_path}' cannot be a symlink"
      end

      begin
        file_content = File.open(file_name, 'r') { |f| f.read }
      rescue
        return "Could not read file #{filename}"
      end  

      CodeBlockHighlighter.new(file_content, {
        :language  => @language,
        :title     => @title,
        :link_href => "/#{code_dir}/#{@link_href}",
        :link_name => 'download'
      }).render(context)
    end
  end

end

Liquid::Template.register_tag('include_code', Jekyll::IncludeCodeTag)
