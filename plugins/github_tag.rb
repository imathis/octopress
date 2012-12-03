# A Liquid tag for Jekyll sites that allows embedding files from GitHub.
# by: Ian Davis
# based on work by Brandon Tilly for the CodeBlock and Gist plugins.
#
# Usage: {% github user repo sha [title/filename [link linkText]]] [/lang:value] %}
#
# You can get the sha hash for a file by:
#   git rev-parse HEAD:filenamegi
# or
#   git rev-parse <SHA of commit>:filename
#
# Examples
# All - Gives a title, link to current code version, and coloring.
#{% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 haml.rb https://github.com/imathis/octopress/blob/master/plugins/haml.rb Current Version %}
# No Caption - Gives a title/filename and coloring.
# {% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 haml.rb https://github.com/imathis/octopress/blob/master/plugins/haml.rb %}
# No Url, with Caption - Gives a title and coloring.
# {% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 haml.rb Current Version %}
# No Url, No Caption - Gives a title and coloring.
# {% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 haml.rb %}
# No FileName - Don't do this. You shouldn't specify a url for the file without a filename.
# {% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 https://github.com/imathis/octopress/blob/master/plugins/haml.rb Current Version %}
# No FileName, No Url, No Caption - No caption block, no tile, no coloring, has line numbers
# {% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 %}
# No FileName, No Url, No Caption, Add Lang Spec (rakefiles and such) - No caption block, no tile, has coloring, has line numbers
# {% github imathis octopress 7e548dec97365691571d3b6e3c880717129692b9 /lang:rb %} 

require './plugins/pygments_code'
require './plugins/raw'

require 'cgi'
require 'net/https'
require 'uri'
require 'base64'
require 'json'

module Jekyll
  class GitHubTag < Liquid::Tag
    include HighlightCode
    include TemplateWrapper
    Pattern = /^(\w+)\s+(\w+)\s+(\w+)\s*(\.?\w+.?\w*)?\s*(http[s]*:\/\/\S+)?\s*(\S[\S\s]*)?$/i
    def initialize(tag_name, text, token)
      super
      @text           = text
      @cache_disabled = false
      @cache_folder   = File.expand_path "../.github-cache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cache_folder
      @title = nil
      @caption = nil
      @filetype = nil
      @highlight = true
      if text =~ /\s*lang:(\w+)/i
        @filetype = $1
        text = text.sub(/lang:\w+/i,'')
      end
      if text =~ Pattern
        @user = $1
        @repo = $2
        @sha = $3
        @caption = $4
        @file = @caption
        @link = $5
        @linkTitle = $6
    
        # this tries to get the filename from url, but
        # this won't work until I can get a better regex or refactor
        # as the $4, $5, $6 variables are populated correctly if you skip
        # the caption.
        #if @caption.nil? && !@link.nil?
        #  fileFromUrl = File.basename(@link)
        #  @caption = fileFromUrl unless fileFromUrl.nil?
        #end
    
        if @caption.nil?
          @caption = "<figcaption><span></span>"
        else
          @caption = "<figcaption><span>#{@caption}</span>"
        end
        unless @link.nil? || @linkTitle.nil?
          @caption += "<a href='#{@link}'>#{@linkTitle}</a>"
        end
        @caption += "</figcaption>"
      end

      if @file =~ /\S[\S\s]*\w+\.(\w+)/ && @filetype.nil?
        @filetype = $1
      end
    end

    def render(context)
      @filetype.strip unless @filetype.nil?
      @script_url = script_url_for 
      @code       = get_cached_blob || get_blob_from_web

      source = "<figure class='code'>"
      source += @caption if @caption
      if @filetype
        source += " #{highlight(@code, @filetype)}</figure>"
      else
        source += "#{tableize_code(@code.lstrip.rstrip.gsub(/</,'&lt;'))}</figure>"
      end
      source = safe_wrap(source)
      source = context['pygments_prefix'] + source if context['pygments_prefix']
      source = source + context['pygments_suffix'] if context['pygments_suffix']
      source
    end
  
    def script_url_for
      "https://api.github.com/repos/#{@user}/#{@repo}/git/blobs/#{@sha}"
    end

    def cache(data)
      cache_file = get_cache_file_for
      File.open(cache_file, "w") do |io|
        io.write data
      end
    end

    def get_cached_blob
      return nil if @cache_disabled
      cache_file = get_cache_file_for
      File.read cache_file if File.exist? cache_file
    end

    def get_cache_file_for
      bad_chars = /[^a-zA-Z0-9\-_.]/
      user      = @user.gsub bad_chars, ''
      repo      = @repo.gsub bad_chars, ''
      File.join @cache_folder, "#{user}-#{repo}-#{@sha}.cache"
    end

    def get_blob_from_web
      blob_url          = script_url_for
      raw_uri           = URI.parse blob_url
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
      response          = https.request request
      doc               = JSON.parse response.body
      content           = doc['content']
      data              = Base64.decode64(content)
      cache data unless @cache_disabled
      data
    end
  end

  class GitHubTagNoCache < GitHubTag
    def initialize(tag_name, text, token)
      super
      @cache_disabled = true
    end
  end
end

Liquid::Template.register_tag('github', Jekyll::GitHubTag)
Liquid::Template.register_tag('githubnocache', Jekyll::GitHubTagNoCache)
