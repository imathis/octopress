# A Liquid tag for Jekyll sites that allows embedding tweets using Twitter's
# oEmbed API, and showing the tweet as a blockquote for non-JavaScript enabled
# browsers and readers.
#
# Author: Scott W. Bradley
# Source URL: https://github.com/scottwb/jekyll-tweet-tag
#
# Example usage:
#   {% tweet https://twitter.com/DEVOPS_BORAT/status/159849628819402752 %}
#
# Documentation:
#   https://github.com/scottwb/jekyll-tweet-tag/blob/master/README.md
#
require 'json'

module Jekyll
  class TweetTag < Liquid::Tag

    TWITTER_OEMBED_URL = "https://api.twitter.com/1/statuses/oembed.json"

    def initialize(tag_name, text, tokens)
      super
      @text           = text
      @cache_disabled = false
      @cache_folder   = File.expand_path "../.tweet-cache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      args       = @text.split(/\s+/).map(&:strip)
      api_params = {'url' => args.shift}

      args.each do |arg|
        k,v = arg.split('=').map(&:strip)
        if k && v
          if v =~ /^'(.*)'$/
            v = $1
          end
          api_params[k] = v
        end
      end

      html_output_for(api_params)
    end

    def html_output_for(api_params)
      body = "Tweet could not be processed"
      if response = cached_response(api_params) || live_response(api_params)
        body = response['html'] || response['error'] || body
      end
      "<div class='embed tweet'>#{body}</div>"
    end

    def cache(api_params, data)
      cache_file = cache_file_for(api_params)
      File.open(cache_file, "w") do |f|
        f.write(data)
      end
    end

    def cached_response(api_params)
      return nil if @cache_disabled
      cache_file = cache_file_for(api_params)
      JSON.parse(File.read(cache_file)) if File.exist?(cache_file)
    end

    def url_params_for(api_params)
      api_params.keys.sort.map do |k|
        "#{CGI::escape(k)}=#{CGI::escape(api_params[k])}"
      end.join('&')
    end

    def cache_file_for(api_params)
      filename = "#{Digest::MD5.hexdigest(url_params_for(api_params))}.cache"
      File.join(@cache_folder, filename)
    end

    def live_response(api_params)
      api_uri = URI.parse(TWITTER_OEMBED_URL + "?#{url_params_for(api_params)}")
      response = Net::HTTP.get(api_uri.host, api_uri.request_uri)
      cache(api_params, response) unless @cache_disabled
      JSON.parse(response)
    end
  end

  class TweetTagNoCache < TweetTag
    def initialize(tag_name, text, token)
      super
      @cache_disabled = true
    end
  end
end

Liquid::Template.register_tag('tweet', Jekyll::TweetTag)
Liquid::Template.register_tag('tweetnocache', Jekyll::TweetTagNoCache)
