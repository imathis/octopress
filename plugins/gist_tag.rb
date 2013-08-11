# A Liquid tag for Jekyll sites that allows embedding Gists and showing code for non-JavaScript enabled browsers and readers.
# Written by: Brandon Mathis, Parker Moore
#
# Example usage: {% gist 1027674 gist_tag.rb %} //embeds a gist for this plugin

require 'cgi'
require 'digest/md5'
require 'net/https'
require 'fileutils'
require 'uri'
require './plugins/pygments_code'

module Jekyll
  class GistTag < Liquid::Tag
    def initialize(tag_name, markup, token)
      super
      @cache_disabled = false
      @original_markup = markup
      @cache_folder = File.expand_path "../.gist-cache", File.dirname(__FILE__)

      @options = Octopress::Pygments.parse_markup(markup, )
      @markup = Octopress::Pygments.clean_markup(markup)

      @options = opts.merge({
        link_text: opts[:link_text] || 'Gist page'
      })

      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      if parts = @markup.match(/([\d]*) (.*)/)
        gist, file = parts[1].strip, parts[2].strip

        @options[:title]     ||= file.empty? ? "Gist: #{gist}" : file
        @options[:url]       ||= "https://gist.github.com/#{gist}"
        @options[:lang]      ||= file.empty? ? @options[:lang] || '' : file.split('.')[-1]
        @options[:no_cache]    = @cache_disabled
        @options[:cache_path]  = @cache_disabled ? nil : get_cache_path(@cache_folder, get_cache_file(gist, file), @markup + @options.to_s)

        cache = read_cache(@options[:cache_path])

        unless cache
          code = get_gist_from_web(gist, file)
          code = get_range(code, @options[:start], @options[:end])
          begin
            code = Octopress::Pygments.highlight(code, @options)
          rescue MentosError => e
            markup = "{% gist #{@original_markup} %}"
            Octopress::Pygments.highlight_failed(e, "{% gist gist_id [filename] [lang:language] [title:title] [start:#] [end:#] [range:#-#] [mark:#,#-#] [linenos:false] %}", markup, code, file)
          end
        end
        code || cache
      else
        "Gist formatting error, format should be {% gist gist_id [filename] %}"
      end
    end

    def get_gist_url_for(gist, file)
      "https://raw.github.com/gist/#{gist}/#{file}"
    end

    def get_cache_file(gist, file)
      bad_chars = /[^a-zA-Z0-9\-_.]/
      gist      = gist.gsub bad_chars, ''
      file      = file.gsub bad_chars, ''
      name  = gist
      name += "-#{file}" unless file.empty?
      name
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
      data.body.to_s
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
