require './plugins/raw'
require './plugins/config'
require 'pygments'
require 'fileutils'
require 'digest/md5'
begin # Make it easy for folks to use rubypython if they like
  require 'rubypython'
rescue LoadError # rubypython is not installed
end

PYGMENTS_CACHE_DIR = File.expand_path('../../.pygments-cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

module HighlightCode
  include TemplateWrapper
  include SiteConfig
  def pygments(code, lang)
    highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'})
    highlighted_code = highlighted_code.gsub(/{{/, '&#x7b;&#x7b;').gsub(/{%/, '&#x7b;&#x25;')
    highlighted_code.to_s
  rescue
    puts $!,$@
  end

  def highlight(code, options = {})
    lang = options[:lang]
    lang = 'ruby' if lang == 'ru'
    lang = 'objc' if lang == 'm'
    lang = 'perl' if lang == 'pl'
    lang = 'yaml' if lang == 'yml'
    lang = 'coffeescript' if lang == 'coffee'
    lang = 'csharp' if lang == 'cs'
    lang = 'plain' if lang == '' or lang.nil? or !lang

    url        = options[:url]        || nil
    title      = options[:title]      || (url ? ' ' : nil)
    link_text  = options[:link_text]  || nil
    escape     = options[:escape]     || false
    marks      = options[:marks]
    linenos    = options[:linenos]
    start      = options[:start]      || 1
    no_cache   = options[:no_cache]   || false
    cache_path = options[:cache_path] || nil

    # Attempt to retrieve cached code
    cache = nil
    unless no_cache
      path  = cache_path || get_cache_path(PYGMENTS_CACHE_DIR, lang, options.to_s + code)
      cache = read_cache(path)
    end

    unless cache
     if lang == 'plain'
        # Escape html tags
        code = code.gsub('<','&lt;')
      else
        code = pygments(code, lang).match(/<pre>(.+)<\/pre>/m)[1].gsub(/ *$/, '') #strip out divs <div class="highlight">
      end
      code = tableize_code(code, lang, {linenos: linenos, start: start, marks: marks })
      title = captionize(title, url, link_text) if title
      code = "<figure class='code'>#{title}#{code}</figure>"
      code = safe_wrap(code) if escape
      File.open(path, 'w') {|f| f.print(code) } unless no_cache
    end
    cache || code
  end

  def read_cache (path)
    File.exist?(path) ? File.read(path) : nil unless path.nil?
  end

  def get_cache_path (dir, name, str)
    File.join(dir, "#{name}-#{Digest::MD5.hexdigest(str)}.html")
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
    table = "<div class='highlight'><table>"
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
    table +="</pre></td></tr></table></div>"
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
    escape    = input.match(/\s*escape:(\w+)/i)
    marks     = get_marks(input)
    url       = input.match(/\s*url:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
    link_text = input.match(/\s*link[-_]text:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
    start     = input.match(/\s*start:(\d+)/i)
    endline   = input.match(/\s*end:(\d+)/i)

    opts = {
      lang:         (lang.nil? ? nil : lang[1]),
      title:        (title.nil? ? nil : title[3] || title[5] || title[6]),
      linenos:      (linenos.nil? ? nil : linenos[1]),
      escape:       (escape.nil? ? nil : escape[1]),
      marks:        marks,
      url:          (url.nil? ? nil : url[3] || url[5] || url[6]),
      start:        (start.nil? ? nil : start[1].to_i),
      end:          (endline.nil? ? nil : endline[1].to_i),
      link_text:    (link_text.nil? ? nil : link_text[3] || link_text[5] || link_text[6])
    }
    opts.merge(parse_range(input, opts[:start], opts[:end]))
  end

  def clean_markup (input)
    input.sub(/\s*lang:\s*\w+/i, ''
        ).sub(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i, ''
        ).sub(/\s*url:\s*(\S+)/i, ''
        ).sub(/\s*link_text:\s*(("(.+?)")|('(.+?)')|(\S+))/i, ''
        ).sub(/\s*mark:\d\S*/i,''
        ).sub(/\s*linenos:\s*\w+/i,''
        ).sub(/\s*start:\s*\d+/i,''
        ).sub(/\s*end:\s*\d+/i,''
        ).sub(/\s*range:\s*\d+-\d+/i,'')
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

  def parse_range (input, start, endline)
    if input =~ / *range:(\d+)-(\d+)/i
      start = $1.to_i
      endline = $2.to_i
    end
    {start: start, end: endline}
  end

  def get_range (code, start, endline)
    length    = code.lines.count
    start   ||= 1
    endline ||= length
    if start > 1 or endline < length
      raise "#{filepath} is #{length} lines long, cannot begin at line #{start}" if start > length
      raise "#{filepath} is #{length} lines long, cannot read beyond line #{endline}" if endline > length
      code = code.split(/\n/).slice(start - 1, endline + 1 - start).join("\n")
    end
    code
  end

end
