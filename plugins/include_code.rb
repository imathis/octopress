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

require './plugins/pygments_code'
require 'pathname'

module Jekyll

  class IncludeCodeTag < Liquid::Tag
    include HighlightCode
    def initialize(tag_name, markup, tokens)
      @title = nil
      @file = nil
      @start = 1
      @end = nil
      @linenos = true
      if markup.strip =~ /\s*lang:(\w+)/i
        @filetype = $1
        markup = markup.strip.sub(/lang:\w+/i,'')
      end
      if markup.strip =~ /\s*linenos:false/i
        @linenos = false
        markup = markup.strip.sub(/linenos:false/i,'')
      end
      if markup =~ /\s*start:(\d+)/i
        @start = $1.to_i
        markup = markup.sub(/\s*start:\d+/i,'')
      end
      if markup =~ /\s*end:(\d+)/i
        @end = $1.to_i
        markup = markup.sub(/\s*end:\d+/i,'')
      end
      if markup =~ /\s*range:(\d+),(\d+)/i
        @start = $1.to_i
        @end = $2.to_i
        markup = markup.sub(/\s*range:\d+,\d+/i,'')
      end
      if markup.strip =~ /(.*)?(\s+|^)(\/*\S+)/i
        @title = $1 || nil
        @file = $3
      end
      super
    end

    def render(context)
      code_dir = (context.registers[:site].config['code_dir'].sub(/^\//,'') || 'downloads/code')
      code_path = (Pathname.new(context.registers[:site].source) + code_dir).expand_path
      file = code_path + @file

      if File.symlink?(code_path)
        return "Code directory '#{code_path}' cannot be a symlink"
      end

      unless file.file?
        return "File #{file} could not be found"
      end

      Dir.chdir(code_path) do
        code = file.read
        length = code.lines.count
        @end ||= length
        return "#{file} is #{length} lines long, cannot begin at line #{@start}" if @start > length
        return "#{file} is #{length} lines long, cannot read beyond line #{@end}" if @end > length
        if @start > 1 or @end < length
          code = code.split(/\n/).slice(@start -1, @end + 1 - @start).join("\n")
        end
        @filetype = file.extname.sub('.','') if @filetype.nil?
        title = @title ? "#{@title} (#{file.basename})" : file.basename
        url = "/#{code_dir}/#{@file}"
        highlight(code, @filetype, {caption: title, url: url, anchor: 'download', start: @start, linenos: @linenos})
      end
    end
  end

end

Liquid::Template.register_tag('include_code', Jekyll::IncludeCodeTag)
