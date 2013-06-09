require "erb"

module Octopress
  module UrlHelpers
    include ERB::Util

    def page_url(context)
      url = (context['post'] || context['page'])['url']
      prepend_url(url, context['site']['url'])
    end

    def encode_url(input)
      url_encode input
    end
    
    # Prepend a local url with a file path
    # remote urls and urls beginning with ! will be ignored
    
    def prepend_url(input, path='')
      path += '/' unless path.match /\/$/
      if input.match /^!/
        input.gsub(/^(!)(.+)/, '\2')
      else
        input.gsub(/^(\/)?([^:]+?)$/, "#{path}"+'\2')
      end
    end

  end
end
