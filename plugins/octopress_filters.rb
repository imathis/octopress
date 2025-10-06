#custom filters for Octopress
require './plugins/backtick_code_block'
require './plugins/raw'
require './plugins/date'
require 'rubypants'

module OctopressFilters
  FILTERABLE_EXTENSIONS = /(html|textile|markdown|md|haml|slim|xml)/i

  extend self
  include BacktickCodeBlock
  include TemplateWrapper

  def pre_filter(input)
    result = render_code_block(input)
    result.gsub(/(<figure.+?>.+?<\/figure>)/m) do
      safe_wrap($1)
    end
  end

  def post_filter(input)
    processed = unwrap(input)
    RubyPants.new(processed, :dashes => :none).to_html
  end

  def filterable?(document)
    extname = nil
    extname = document.extname if document.respond_to?(:extname)
    extname ||= document.ext if document.respond_to?(:ext)
    return false unless extname

    ext = extname.to_s.delete_prefix('.').downcase
    FILTERABLE_EXTENSIONS.match?(ext)
  end
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc, _payload|
  next unless OctopressFilters.filterable?(doc)
  doc.content = OctopressFilters.pre_filter(doc.content)
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless OctopressFilters.filterable?(doc)
  doc.output = OctopressFilters.post_filter(doc.output)
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

  # Extracts raw content DIV from template, used for page description as {{ content }}
  # contains complete sub-template code on main page level
  def raw_content(input)
    /<div class="entry-content">(?<content>[\s\S]*?)<\/div>\s*<(footer|\/article)>/ =~ input
    return (content.nil?) ? input : content
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

  # Condenses multiple spaces and tabs into a single space
  def condense_spaces(input)
    input.gsub(/\s{2,}/, ' ')
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
    input.titlecase
  end

end
Liquid::Template.register_filter OctopressLiquidFilters
