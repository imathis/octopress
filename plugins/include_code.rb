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
# {% include_code javascripts/test.js Example 2 %}
#
# will output a figcaption with the title: Example 2 (test.js)
#

require 'colorator'
require 'pathname'
require './plugins/pygments_code'

module Jekyll

  class IncludeCodeTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @file = nil
      @title_old = nil
      @original_markup = markup

      opts = Octopress::Pygments.parse_markup(markup)
      @options = opts.merge({
        link_text: opts[:link_text] || 'view raw',
        start:     opts[:start]     || 1
      })
      markup = Octopress::Pygments.clean_markup(markup)

      if markup.strip =~ /(^\S*\.\S+) *(.+)?/i
        @file = $1
        @options[:title] ||= $2
      elsif markup.strip =~ /(.*?)(\S*\.\S+)\Z/i # Title before file is deprecated in 2.1
        @title_old = $1
        @file = $2
      end
      super
    end

    def render(context)
      code_dir = (context.registers[:site].config['code_dir'].sub(/^\//,'') || 'downloads/code')
      code_path = (Pathname.new(context.registers[:site].source) + code_dir).expand_path
      filepath = code_path + @file

      unless @title_old.nil?
        @options[:title] ||= @title_old
        puts "### ------------ WARNING ------------ ###".yellow
        puts "This include_code syntax is deprecated ".yellow
        puts "Correct syntax: path/to/file.ext [title]".yellow
        puts "Update include for #{filepath}".yellow
        puts "### --------------------------------- ###".yellow
      end

      if File.symlink?(code_path)
        puts "Code directory '#{code_path}' cannot be a symlink".yellow
        return "Code directory '#{code_path}' cannot be a symlink".yellow
      end

      unless filepath.file?
        puts "File #{filepath} could not be found".yellow
        return "File #{filepath} could not be found".yellow
      end

      Dir.chdir(code_path) do
        @options[:lang]  ||= filepath.extname.sub('.','')
        @options[:title]   = @options[:title] ? "#{@options[:title]} (#{filepath.basename})" : filepath.basename
        @options[:url]   ||= "/#{code_dir}/#{@file}"

        code = filepath.read
        code = get_range(code, @options[:start], @options[:end])
        begin
          Octopress::Pygments.highlight(code, @options)
        rescue MentosError => e
          markup = "{% include_code #{@original_markup} %}"
          Octopress::Pygments.highlight_failed(e, "{% include_code [title] [lang:language] path/to/file [start:#] [end:#] [range:#-#] [mark:#,#-#] [linenos:false] %}", markup, code, filepath)
        end
      end
    end
  end
end

Liquid::Template.register_tag('include_code', Jekyll::IncludeCodeTag)
