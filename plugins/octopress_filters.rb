#custom filters for Octopress
require './plugins/backtick_code_block'
require './plugins/post_filters'
require './plugins/raw'
require './plugins/date'
require 'rubypants'

module OctopressFilters
  include BacktickCodeBlock
  include TemplateWrapper
  def pre_filter(input, ext)
    input = render_code_block(input, ext)
  end
end

module Jekyll
  class ContentFilters < PostFilter
    include OctopressFilters
    def pre_render(post)
      if post.ext.match('html|textile|markdown|md|haml|slim|xml')
        post.content = pre_filter(post.content, post.ext)
      end
    end
  end
end


module OctopressLiquidFilters
  include Octopress::Date

  # Used on the blog index to split posts on the <!--more--> marker
  def excerpt(input)
    if input.index(/<!--\s*more\s*-->/i)
      input.split(/<!--\s*more\s*-->/i)[0]
    else
      input
    end
  end

  # Checks for excerpts (helpful for template conditionals)
  def has_excerpt(input)
    input =~ /<!--\s*more\s*-->/i ? true : false
  end

  # Summary is used on the Archive pages to return the first block of content from a post.
  def summary(input)
    if input.index(/\n\n/)
      input.split(/\n\n/)[0]
    else
      input
    end
  end

  # Escapes CDATA sections in post content
  def cdata_escape(input)
    input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
  end

  # Replaces relative urls with full urls
  def expand_urls(input, url='')
    url ||= '/'
    input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
      $1+url+$3
    end
  end

  # Prepend a local url with a file path
  # remote urls and urls beginning with ! will be ignored
  def prepend_url(input, path='')
    path += '/' unless path.match /\/$/
    if input.match /^!/
      input.gsub(/^(!)(.+)/, '\2')
    else
      input.gsub(/^(\/)?([^:]+?)$/, "#{path}"+'\2')
    end
  end

  # Improved version of Liquid's truncate:
  # - Doesn't cut in the middle of a word.
  # - Uses typographically correct ellipsis (…) insted of '...'
  def truncate(input, length)
    if input.length > length && input[0..(length-1)] =~ /(.+)\b.+$/im
      $1.strip + ' &hellip;'
    else
      input
    end
  end

  # Improved version of Liquid's truncatewords:
  # - Uses typographically correct ellipsis (…) insted of '...'
  def truncatewords(input, length)
    truncate = input.split(' ')
    if truncate.length > length
      truncate[0..length-1].join(' ').strip + ' &hellip;'
    else
      input
    end
  end

  # Removes trailing forward slash from a string for easily appending url segments
  def strip_slash(input)
    if input =~ /(.+)\/$|^\/$/
      input = $1
    end
    input
  end

  # Returns a url without the protocol (http://)
  def shorthand_url(input)
    input.gsub /(https?:\/\/)(\S+)/ do
      $2
    end
  end

  # Returns a title cased string based on John Gruber's title case http://daringfireball.net/2008/08/title_case_update
  def titlecase(input)
    input.titlecase unless input.nil?
  end

end
Liquid::Template.register_filter OctopressLiquidFilters
