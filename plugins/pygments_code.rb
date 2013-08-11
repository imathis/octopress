require 'pygments'
require 'fileutils'
require 'digest/md5'
require 'colorator'

PYGMENTS_CACHE_DIR = File.expand_path('../../.pygments-cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

module Octopress
  module Pygments

    def self.render_pygments(code, lang)
      highlighted_code = ::Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'})
      highlighted_code = highlighted_code.gsub(/{{/, '&#x7b;&#x7b;').gsub(/{%/, '&#x7b;&#x25;')
      highlighted_code.to_s
    end

    def self.highlight(code, options = {})
      lang = options[:lang]
      lang = 'ruby' if lang == 'ru'
      lang = 'objc' if lang == 'm'
      lang = 'perl' if lang == 'pl'
      lang = 'yaml' if lang == 'yml'
      lang = 'coffeescript' if lang == 'coffee'
      lang = 'csharp' if lang == 'cs'
      lang = 'plain' if lang == '' or lang.nil? or !lang

      options[:lang] = lang
      options[:title] ||= ' ' if options[:url]

      # Attempt to retrieve cached code
      cache = nil
      unless options[:no_cache]
        path  = options[:cache_path] || get_cache_path(PYGMENTS_CACHE_DIR, options[:lang], options.to_s + code)
        cache = read_cache(path)
      end

      unless cache
       if options[:lang] == 'plain'
          # Escape html tags
          code = code.gsub('<','&lt;')
        else
          code = render_pygments(code, options[:lang]).match(/<pre>(.+)<\/pre>/m)[1].gsub(/ *$/, '') #strip out divs <div class="highlight">
        end
        code = tableize_code(code, options[:lang], {linenos: options[:linenos], start: options[:start], marks: options[:marks]})
        title = captionize(options[:title], options[:url], options[:link_text]) if options[:title]
        code = "<figure class='code'>#{title}#{code}</figure>"
        File.open(path, 'w') {|f| f.print(code) } unless options[:no_cache]
      end
      cache || code
    end

    def self.read_cache (path)
      File.exist?(path) ? File.read(path) : nil unless path.nil?
    end

    def self.get_cache_path (dir, name, str)
      File.join(dir, "#{name}-#{Digest::MD5.hexdigest(str)}.html")
    end

    def self.captionize (caption, url, link_text)
      figcaption  = "<figcaption>#{caption}"
      figcaption += "<a href='#{url}'>#{(link_text || 'link').strip}</a>" if url
      figcaption += "</figcaption>"
    end

    def self.tableize_code (code, lang, options = {})
      start = options[:start] || 1
      lines = options[:linenos] || true
      marks = options[:marks] || []
      table = "<div class='highlight'><table><tr>"
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

    def self.number_lines (start, count, marks)
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

    def self.parse_markup (input, defaults={})
      lang      = input.match(/\s*lang:\s*(\S+)/i)
      lang      = (lang.nil? ? nil : lang[1])

      url       = input.match(/\s*url:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
      url       = (url.nil? ? nil : url[3] || url[5] || url[6])

      title     = input.match(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
      title     = (title.nil? ? nil : title[3] || title[5] || title[6])
      title   ||= ' ' if url

      linenos   = input.match(/\s*linenos:\s*(\w+)/i)
      linenos   = (linenos.nil? ? nil : linenos[1])

      marks     = get_marks(input)

      link_text = input.match(/\s*link[-_]text:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
      link_text = (link_text.nil? ? 'link' : link_text[3] || link_text[5] || link_text[6])

      start     = input.match(/\s*start:\s*(\d+)/i)
      start     = (start.nil? ? nil : start[1].to_i)

      endline   = input.match(/\s*end:\s*(\d+)/i)
      endline   = (endline.nil? ? nil : endline[1].to_i)

      if input =~ / *range:(\d+)-(\d+)/i
        start = $1.to_i
        endline = $2.to_i
      end

      options = {
        lang: lang,
        url: url,
        title: title,
        linenos: linenos,
        marks: marks,
        link_text: link_text,
        start: start,
        end: endline
      }

      defaults.each { |k,v| options[k] ||= defaults[k] }
    end

    def self.clean_markup (input)
      input.sub(/\s*lang:\s*\S+/i,''
          ).sub(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i,''
          ).sub(/\s*url:\s*(\S+)/i,''
          ).sub(/\s*link_text:\s*(("(.+?)")|('(.+?)')|(\S+))/i,''
          ).sub(/\s*mark:\s*\d\S*/i,''
          ).sub(/\s*linenos:\s*\w+/i,''
          ).sub(/\s*start:\s*\d+/i,''
          ).sub(/\s*end:\s*\d+/i,''
          ).sub(/\s*range:\s*\d+-\d+/i,'')
    end

    def self.get_marks (input)
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

    def self.get_range (code, start, endline)
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

    def self.highlight_failed(error, syntax, markup, code, file = nil)
      code_snippet = code.split("\n")[0..9].map{|l| "    #{l}" }.join("\n")
      fail_message  = "\nPygments Error while parsing the following markup#{" in #{file}" if file}:\n\n".red
      fail_message += "    #{markup}\n#{code_snippet}\n"
      fail_message += "#{"    ..." if code.split("\n").size > 10}\n"
      fail_message += "\nValid Syntax:\n\n#{syntax}\n".yellow
      fail_message += "\nPygments Error:\n\n#{error.message}".red
      $stderr.puts fail_message.chomp
      raise ArgumentError
    end
  end
end

