#require 'albino'
require './plugins/raw'
require 'pygments'
require 'fileutils'
require 'digest/md5'

PYGMENTS_CACHE_DIR = File.expand_path('../../.pygments-cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

module HighlightCode
  include TemplateWrapper
  def pygments(code, lang)
    path = File.join(PYGMENTS_CACHE_DIR, "#{lang}-#{Digest::MD5.hexdigest(code)}.html") if defined?(PYGMENTS_CACHE_DIR)
    if File.exist?(path)
      highlighted_code = File.read(path)
    else
      #highlighted_code = Albino.new(code, lang, :html)
      highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'}) 
      File.open(path, 'w') {|f| f.print(highlighted_code) } if path
    end
    highlighted_code.to_s
  rescue 
    puts $!,$@
  end

  def highlight(code, lang, options = {})
    lang = 'ruby' if lang == 'ru'
    lang = 'objc' if lang == 'm'
    lang = 'perl' if lang == 'pl'
    lang = 'yaml' if lang == 'yml'
    lang = 'coffeescript' if lang == 'coffee'
    lang = 'plain' if lang == '' or lang.nil?

    caption = options[:caption]    || nil
    url     = options[:url]        || nil
    anchor  = options[:anchor]     || nil
    wrap    = options[:wrap]       || true
    linenos = options[:linenos]
    start   = options[:start]

    if lang == 'plain'
      # Escape html tags
      code = code.gsub('<','&lt;').gsub('>','&gt;')
    elsif lang.include? "-raw"
      output  = "``` #{$1.sub('-raw', '')}\n"
      output += code
      output += "\n```\n"
    else
      code = pygments(code, lang).match(/<pre>(.+)<\/pre>/m)[1].gsub(/ *$/, '') #strip out divs <div class="highlight">
    end

    code = tableize_code(code, lang, { linenos: linenos, start: start })
    caption = captionize(caption, url, anchor) if caption

    figure = "<figure class='code'>#{caption}#{code}</figure>"
    figure = safe_wrap(figure) if wrap
    figure
  end

  def captionize (caption, url, anchor)
    figcaption  = "<figcaption><span>#{caption}</span>"
    figcaption += "<a href='#{url}' title='Download code'> #{anchor || 'link'}</a>" if url
    figcaption += "</figcaption>"
  end

  def tableize_code (code, lang, options = {})
    start = options[:start]
    lines = options[:linenos] || true
    table = "<div class='highlight'><table>"
    table += number_lines(start, code.lines.count) if lines
    table += "<td class='code'><pre><code class='#{lang}'>"
    table += code.gsub /^((.+)?(\n?))/, '<span class=\'line\'>\1</span>'
    table +="</code></pre></td></tr></table></div>"
  end

  def number_lines (start, count)
    start ||= 1
    lines = "<td class='gutter'><pre class='line-numbers'>"
    count.times do |index|
      lines += "<span class='line-number'>#{index + start}</span>\n"
    end
    lines += "</pre></td>"
  end
end
