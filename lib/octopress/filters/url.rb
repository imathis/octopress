# Liquid filters for Octopress

module Octopress
  module UrlFilters
    include UrlHelpers
    
    # Replaces relative urls with full urls
    
    def expand_urls(input, url='')
      url ||= '/'
      input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/(?!\/)[^\"'>]*)/ do
        $1+url+$3
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

