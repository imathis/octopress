require './plugins/raw'
require './plugins/config'
require 'albino'
require 'pygments'
require 'fileutils'
require 'digest/md5'

PYGMENTS_CACHE_DIR = File.expand_path('../../.pygments-cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

module HighlightCode
  include TemplateWrapper
  include SiteConfig
  def pygments(code, lang)
    path = File.join(PYGMENTS_CACHE_DIR, "#{lang}-#{Digest::MD5.hexdigest(code)}.html") if defined?(PYGMENTS_CACHE_DIR)
    if File.exist?(path)
      highlighted_code = File.read(path)
    else
      if get_config('pygments')
        highlighted_code = Albino.new(code, lang, :html)
      else
        highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'}) 
      end
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
    lang = 'plain' if lang == '' or lang.nil? or !lang

    caption = options[:caption]   || nil
    url     = options[:url]       || nil
    anchor  = options[:anchor]    || nil
    wrap    = options[:wrap]      || true
    marks   = options[:marks]
    linenos = options[:linenos]
    start   = options[:start]

    code = code.gsub(/{{/, '&#x7b;&#x7b;').gsub(/{%/, '&#x7b;&#x25;')

    if lang == 'plain'
      # Escape html tags
      code = code.gsub('<','&lt;')
    elsif lang.include? "-raw"
      output  = "``` #{$1.sub('-raw', '')}\n"
      output += code
      output += "\n```\n"
    else
      code = pygments(code, lang).match(/<pre>(.+)<\/pre>/m)[1].gsub(/ *$/, '') #strip out divs <div class="highlight">
    end

    code = tableize_code(code, lang, { linenos: linenos, start: start, marks: marks })
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
    lines = options[:linenos].nil? ? true : options[:linenos]
    marks = options[:marks]   || []
    table = "<div class='highlight'><table>"
    table += number_lines(start, code.lines.count, marks) if lines
    table += "<td class='code'><pre><code class='#{lang}'>"
    if marks.size
      code.lines.each_with_index do |line,index|
        classes = 'line'
        if marks.include? index + start
          classes += ' marked'
          classes += ' start' unless marks.include? index - 1 + start
          classes += ' end' unless marks.include? index + 1 + start
        end
        table += "<span class='#{classes}'>#{line}</span>"
      end
    else
      table += code.gsub /^((.+)?(\n?))/, '<span class=\'line\'>\1</span>'
    end
    table +="</code></pre></td></tr></table></div>"
  end

  def number_lines (start, count, marks)
    start ||= 1
    lines = "<td class='gutter'><pre class='line-numbers'>"
    count.times do |index|
      lines += "<span class='line-number#{' marked' if marks.include? index + start}'>#{index + start}</span>\n"
    end
    lines += "</pre></td>"
  end

  def get_lang (input)
    lang = nil
    if input =~ /\s*lang:(\w+)/i
      lang = $1
    end
    lang
  end

  def replace_lang (input)
    input.sub(/ *lang:\w+/i, '')
  end

  def get_marks (input)
    # Matches pattern for line marks and returns array of line numbers to mark
    # Example input mark:1,5-10,2
    # Outputs: [1,2,5,6,7,8,9,10]
    marks = []
    if input =~ / *mark:(\d\S*)/i
      marks = $1.gsub /(\d+)-(\d+)/ do
        ($1.to_i..$2.to_i).to_a.join(',')
      end
      marks = marks.split(',').collect {|s| s.to_i}.sort
    end
    marks
  end

  def replace_marks (input)
    input.sub(/ *mark:\d\S*/i,'')
  end

  def get_linenos (input)
    linenos = true
    if input =~ / *linenos:false/i
      linenos = false
    end
    linenos
  end

  def replace_linenos (input)
    input.sub(/ *linenos:false/i,'')
  end

  def get_start (input)
    start = 1
    if input =~ / *start:(\d+)/i
      start = $1.to_i
    end
    start
  end

  def replace_start (input)
    input.sub(/ *start:\d+/i,'')
  end

  def get_end (input)
    endline = nil
    if input =~ / *end:(\d+)/i
      endline = $1.to_i
    end
    endline
  end

  def replace_end (input)
    input.sub(/ *end:\d+/i,'')
  end

  def get_range (input, start, endline)
    if input =~ / *range:(\d+)-(\d+)/i
      start = $1.to_i
      endline = $2.to_i
    end
    {start: start, end: endline}
  end
  def replace_range (input)
    input.sub(/ *range:\d+-\d+/i,'')
  end
end
