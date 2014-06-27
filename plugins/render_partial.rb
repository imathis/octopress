# Title: Render Partial Tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Import files on your filesystem into any blog post and render them inline.
# Note: Paths are relative to the source directory, if you import a file with yaml front matter, the yaml will be stripped out.
#
# Syntax {% render_partial path/to/file %}
#
# Example 1:
# {% render_partial about/_bio.markdown %}
#
# This will import source/about/_bio.markdown and render it inline.
# In this example I used an underscore at the beginning of the filename to prevent Jekyll
# from generating an about/bio.html (Jekyll doesn't convert files beginning with underscores)
#
# Example 2:
# {% render_partial ../README.markdown %}
#
# You can use relative pathnames, to include files outside of the source directory.
# This might be useful if you want to have a page for a project's README without having
# to duplicated the contents
#
#

require 'jekyll-page-hooks'

module Jekyll

  class RenderPartialTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @file = nil
      @raw = false
      if markup =~ /^(\S+)\s?(\w+)?/
        @file = $1.strip
        @raw = $2 == 'raw'
      end
      super
    end

    def expand_path(context)
      root = context.registers[:site].source

      # If relative path, e.g. ./somefile, ../somefile
      if @file =~ /^\.+\//
        page = context['page']
        if local_dir = page['dir']
          File.join(root, local_dir, @file)
        else
          local_dir = File.dirname(page['path'])
          File.join(root, local_dir, @file)
        end

      # If absolute or relative to a user directory, e.g. /Users/Bob/somefile or ~/somefile
      elsif @file =~ /^[\/~]/
        File.expand_path(@file)

      # Otherwise, assume relative to site root
      else
        File.join(root, @file)
      end
  
    end

    def render(context)
      file = expand_path(context)

      unless File.exists?(file)
        return "File #{file} could not be found"
      end

      content = File.open(file).read

      raw_content = {}

      content = content.gsub /{%\s*raw\s*%}(.+?){% endraw %}/m do
        data = $1
        key = Digest::MD5.hexdigest(data)
        raw_content[key] = "{% raw %}#{data}{% endraw %}"
        key
      end

      if content =~ /\A-{3}(.+[^\A])-{3}\n(.+)/m
        local_vars = SafeYAML.load($1.strip)
        content = $2.strip
      end

      return content if @raw

      partial = Liquid::Template.parse(content)

      content = context.stack {
        if local_vars
          context['page'] = Jekyll::Utils.deep_merge_hashes(context['page'], local_vars)
        end
        partial.render!(context)
      }.strip

      raw_content.each { |k, v| content.sub!(k, v) }

      parse_convertible(content, context, file)
    end

    # Ensure jekyll page hooks are processed
    def parse_convertible(content, context, path)
      page = Jekyll::ConvertiblePartial.new(context.registers[:site], path, content)
      page.render({})
      page.output.strip
    end
        
  end
end

Liquid::Template.register_tag('render_partial', Jekyll::RenderPartialTag)
