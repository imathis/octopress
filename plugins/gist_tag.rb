# A Liquid tag for Jekyll sites that allows embedding Gists and showing code for non-JavaScript enabled browsers and readers.
# Written by: Brandon Mathis, Parker Moore
# Inspired by: Brandon Tilly
# Source URL: https://gist.github.com/1027674
# Post http://brandontilley.com/2011/01/31/gist-tag-for-jekyll.html
#
# Example usage: {% gist 1027674 gist_tag.rb %} //embeds a gist for this plugin

require 'cgi'
require 'digest/md5'
require 'net/https'
require 'uri'
require './plugins/pygments_code'

module Jekyll
  class GistTag < Liquid::Tag
    include HighlightCode
    def initialize(tag_name, markup, token)
      super
      @cache_disabled = false
      @cache_folder   = File.expand_path "../.gist-cache", File.dirname(__FILE__)

      options    = parse_markup(markup)
      @lang      = options[:lang]
      @title     = options[:title]
      @lineos    = options[:lineos]
      @marks     = options[:marks]
      @url       = options[:url]
      @link_text = options[:link_text]
      @start     = options[:start]
      @end       = options[:end]
      @markup    = clean_markup(markup)

      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      if parts = @markup.match(/([\d]*) (.*)/)
        gist, file = parts[1].strip, parts[2].strip
        code       = get_cached_gist(gist, file) || get_gist_from_web(gist, file)

        length = code.lines.count
        @end ||= length
        return "#{file} is #{length} lines long, cannot begin at line #{@start}" if @start > length
        return "#{file} is #{length} lines long, cannot read beyond line #{@end}" if @end > length
        if @start > 1 or @end < length
          code = code.split(/\n/).slice(@start -1, @end + 1 - @start).join("\n")
        end

        lang  = file.empty? ? @lang || '' : file.split('.')[-1]
        link  = "https://gist.github.com/#{gist}"
        title = file.empty? ? "Gist: #{gist}" : file
        highlight(code, lang, { title: @title || title, url: link, link_text: @link_text || 'Gist page', marks: @marks, linenos: @linenos, start: @start })
      else
        ""
      end
    end

    def get_gist_url_for(gist, file)
      "https://raw.github.com/gist/#{gist}/#{file}"
    end

    def cache(gist, file, data)
      cache_file = get_cache_file_for gist, file
      File.open(cache_file, "w") do |io|
        io.write data
      end
    end

    def get_cached_gist(gist, file)
      return nil if @cache_disabled
      cache_file = get_cache_file_for gist, file
      File.read cache_file if File.exist? cache_file
    end

    def get_cache_file_for(gist, file)
      bad_chars = /[^a-zA-Z0-9\-_.]/
      gist      = gist.gsub bad_chars, ''
      file      = file.gsub bad_chars, ''
      md5       = Digest::MD5.hexdigest "#{gist}-#{file}"
      File.join @cache_folder, "#{gist}-#{file}-#{md5}.cache"
    end

    def get_gist_from_web(gist, file)
      gist_url          = get_gist_url_for gist, file
      raw_uri           = URI.parse gist_url
      proxy             = ENV['http_proxy']
      if proxy
        proxy_uri       = URI.parse(proxy)
        https           = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new raw_uri.host, raw_uri.port
      else
        https           = Net::HTTP.new raw_uri.host, raw_uri.port
      end
      https.use_ssl     = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request           = Net::HTTP::Get.new raw_uri.request_uri
      data              = https.request request
      code              = data.body.to_s

      cache gist, file, code unless @cache_disabled
      code
    end
  end

  class GistTagNoCache < GistTag
    def initialize(tag_name, markup, token)
      super
      @cache_disabled = true
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)
Liquid::Template.register_tag('gistnocache', Jekyll::GistTagNoCache)
