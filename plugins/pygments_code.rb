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
      highlighted_code = highlighted_code.gsub(/{{/, '&#x7b;&#x7b;').gsub(/{%/, '&#x7b;&#x25;')
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
    lang = 'csharp' if lang == 'cs'
    lang = 'plain' if lang == '' or lang.nil? or !lang

    url       = options[:url]       || nil
    title     = options[:title]     || (url ? ' ' : nil)
    link_text = options[:link_text] || nil
    wrap      = options[:wrap]      || true
    marks     = options[:marks]
    linenos   = options[:linenos]
    start     = options[:start]     || 1

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
    title = captionize(title, url, link_text) if title

    figure = "<figure class='code'>#{title}#{code}</figure>"
    figure = safe_wrap(figure) if wrap
    figure
  end

  def captionize (caption, url, link_text)
    figcaption  = "<figcaption>#{caption}"
    figcaption += "<a href='#{url}'>#{(link_text || 'link').strip}</a>" if url
    figcaption += "</figcaption>"
  end

  def tableize_code (code, lang, options = {})
    start = options[:start] || 1
    lines = options[:linenos] || true
    marks = options[:marks] || []
    table = "<table class='highlight'>"
    table += number_lines(start, code.lines.count, marks) if lines
    table += "<td class='main #{'unnumbered' unless lines} #{lang}'><pre>"
    code.lines.each_with_index do |line,index|
      classes = 'line'
      if marks.include? index + start
        classes += ' marked'
        classes += ' start' unless marks.include? index - 1 + start
        classes += ' end' unless marks.include? index + 1 + start
      end
      line = line.strip.empty? ? ' ' : line
      table += "<div class='#{classes}'>#{line}</div>"
    end
    table +="</pre></td></tr></table>"
  end

  def number_lines (start, count, marks)
    start ||= 1
    lines = "<td class='line-numbers' aria-hidden='true'><pre>"
    count.times do |index|
      classes = 'line-number'
      if marks.include? index + start
        classes += ' marked'
        classes += ' start' unless marks.include? index - 1 + start
        classes += ' end' unless marks.include? index + 1 + start
      end
      lines += "<div data-line='#{index + start}' class='#{classes}'></div>"
    end
    lines += "</pre></td>"
  end

  def parse_markup (input)
    lang      = input.match(/\s*lang:(\w+)/i)
    title     = input.match(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
    linenos   = input.match(/\s*linenos:(\w+)/i)
    marks     = get_marks(input)
    url       = input.match(/\s*url:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
    link_text = input.match(/\s*link_text:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
    start     = input.match(/\s*start:(\d+)/i)
    endline   = input.match(/\s*end:(\d+)/i)

    opts = {
      lang:         (lang.nil? ? nil : lang[1]),
      title:        (title.nil? ? nil : title[3] || title[5] || title[6]),
      linenos:      (linenos.nil? ? nil : linenos[1]),
      marks:        marks,
      url:          (url.nil? ? nil : url[3] || url[5] || url[6]),
      start:        (start.nil? ? nil : start[1].to_i),
      end:          (endline.nil? ? nil : endline[1].to_i),
      link_text:    (link_text.nil? ? nil : link_text[3] || link_text[5] || link_text[6]) 
    }
    opts.merge(get_range(input, opts[:start], opts[:end]))
  end

  def clean_markup (input)
    input.sub(/\s*lang:\w+/i, ''
        ).sub(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i, ''
        ).sub(/\s*url:(\S+)/i, ''
        ).sub(/\s*link_text:\s*(("(.+?)")|('(.+?)')|(\S+))/i, ''
        ).sub(/\s*mark:\d\S*/i,''
        ).sub(/\s*linenos:false/i,''
        ).sub(/\s*start:\d+/i,''
        ).sub(/\s*end:\d+/i,''
        ).sub(/\s*range:\d+-\d+/i,'')
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

  def get_range (input, start, endline)
    if input =~ / *range:(\d+)-(\d+)/i
      start = $1.to_i
      endline = $2.to_i
    end
    {start: start, end: endline}
  end
end
