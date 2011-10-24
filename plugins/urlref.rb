#
# Author: Yasuhiro Matsumoto
# Include reference of text.
#
# Outputs a string with a given URL
#
#   {% urlref http://google.com/search?q=pants %}
#   ...
#   <blockquote>
#     <a href="http://google.com/search?q=pants">The Search For Bobby's Pants</p>
#     <p>...</p>
#     <cite><a href="http://google.com/search?q=pants">The Search For Bobby's Pants</a></cite>
#   </blockquote>
#
require 'cgi'
require 'digest/md5'
require 'net/https'
require 'uri'
require 'iconv'

module Jekyll

  class UrlRef < Liquid::Tag
    def initialize(tag_name, args, tokens)
      super
      if pair = args.match(/(\S+)\s+([\d\.]+)/)
        @url = pair[1].strip
        @per = pair[2].strip.to_f
      else
        @url = args
        @per = 0.1
      end
      @cache_disabled = false
      @cache_folder   = File.expand_path "../.urlref-cache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      if text = get_cached_text(@url, @per) || get_text_from_url(@url, @per)
        lines = text.split(/\n/, 3)
        title = CGI.escapeHTML lines[1]
        body = CGI.escapeHTML lines[2]
        <<-HTML
<blockquote>
<a href="#{@url}">#{title}</a>
<p>#{body}</p>
<cite>#{@url}</cite>
</blockquote>
        HTML
      else
        ""
      end
    end

    def cache(url, text, per)
      cache_file = get_cache_file_for url, per
      File.open(cache_file, "w") do |io|
        io.write text
      end
    end

    def get_cached_text(url, per)
      return nil if @cache_disabled
      cache_file = get_cache_file_for url, per
      File.read cache_file if File.exist? cache_file
    end

    def get_cache_file_for(url, per)
      md5 = Digest::MD5.hexdigest url
      File.join @cache_folder, "#{md5}-#{per}.cache"
    end

    def decode_html(s)
      s = s.gsub(/<[^>]*?>/, "")
      s = s.gsub("&#39;", "'")
      s = s.gsub("&#39;", "'")
      s = s.gsub("&quot;", "\"")
      s = s.gsub("&lt;", "<")
      s = s.gsub("&gt;", ">")
      s = s.gsub("&nbsp;", " ")
      s = s.gsub("&laquo;", "<<")
      s = s.gsub("&raquo;", ">>")
      s = s.gsub("&copy;", "(C)")
      s = s.gsub("&amp;", "&")
      s
    end

    def get_text_from_url(url, threshold_per)
      raw_uri = URI.parse url
      proxy = ENV['http_proxy']
      if proxy
        proxy_uri = URI.parse proxy
        http = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new raw_uri.host, raw_uri.port
      else
        http = Net::HTTP.new raw_uri.host, raw_uri.port
      end
      if raw_uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new raw_uri.request_uri
      data = http.request request
      data = data.body
      data.gsub!(/<!--.*?-->/, '')
      data.gsub!(/[\t\r\n]/, ' ')
      title = data.match(/<title[^>]*?>(.*?)<\/title>/i)
      title = title ? title[1] : ''
      title = decode_html title
      data.gsub!(/<(script|style)[^>]*>.*?<\/\1>/, '')
      max = 0
      body = ''
      data.split(/(<td[^>]*?>)|(<\/td>)|(<div[^>]*?>)|(<\/div>)/).each do |html|
        text = decode_html html.dup
        text.strip!
        text.gsub!(/[\s\t\r\n]+/, " ")
        next if text == "" 
        l = text.length
        if l > 100
          per = l.to_f / html.length
          if max < l and per < threshold_per
            max = l
            body = text.strip
          end
        end
      end
      if body.length > 200
        body = "#{body.slice(0, 200)}..."
      end
      text = "#{url}\n#{title}\n#{body}\n"
      text = Iconv.new('UTF-8//IGNORE', 'UTF-8').iconv(text)
      cache url, text, threshold_per unless @cache_disabled
      text
    end

  end
end

Liquid::Template.register_tag('urlref', Jekyll::UrlRef)
