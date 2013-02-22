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

require './plugins/pygments_code'
require 'pathname'

module Jekyll

  class IncludeCodeTag < Liquid::Tag
    include HighlightCode
    def initialize(tag_name, markup, tokens)
      @file = nil
      @title_old = nil

      opts     = parse_markup(markup)
      @options = {
        lang:      opts[:lang],
        title:     opts[:title],
        lineos:    opts[:lineos],
        marks:     opts[:marks],
        url:       opts[:url],
        link_text: opts[:link_text] || 'view raw',
        start:     opts[:start]     || 1,
        end:       opts[:end]
      }
      markup     = clean_markup(markup)

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
        puts "### ------------ WARNING ------------ ###"
        puts "This include_code syntax is deprecated "
        puts "Correct syntax: path/to/file.ext [title]"
        puts "Update include for #{filepath}"
        puts "### --------------------------------- ###"
      end

      if File.symlink?(code_path)
        puts "Code directory '#{code_path}' cannot be a symlink"
        return "Code directory '#{code_path}' cannot be a symlink"
      end

      unless filepath.file?
        puts "File #{filepath} could not be found"
        return "File #{filepath} could not be found"
      end

      Dir.chdir(code_path) do
        @options[:lang]  ||= filepath.extname.sub('.','')
        @options[:title]   = @options[:title] ? "#{@options[:title]} (#{filepath.basename})" : filepath.basename
        @options[:url]   ||= "/#{code_dir}/#{@file}"

        code = filepath.read
        code = get_range(code, @options[:start], @options[:end])
        highlight(code, @options)
      end
    end
  end
end

Liquid::Template.register_tag('include_code', Jekyll::IncludeCodeTag)
