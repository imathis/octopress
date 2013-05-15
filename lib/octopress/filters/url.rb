# Liquid filters for Octopress

module Octopress
  module UrlFilters
    
    # Replaces relative urls with full urls
    
    def expand_urls(input, url='')
      url ||= '/'
      input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/(?!\/)[^\"'>]*)/ do
        $1+url+$3
      end
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

    # Removes trailing forward slash from a string for easily appending url segments

    def strip_slash(input)
      input.sub(/\/\s*$/, '')
    end

    # Returns a url without the protocol (http://)

    def shorthand_url(input)
      input.gsub /(https?:\/\/)(\S+)/ do
        $2
      end
    end
  end
end

Liquid::Template.register_filter Octopress::UrlFilters

