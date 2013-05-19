$:.unshift File.expand_path("../../../lib", File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'octopress'

module Octopress
  class JavascriptAssetsTag < Liquid::Tag
    def initialize(tag_name, options, tokens)
      super
    end

    def render(context)
      js_assets = Octopress::JSAssetsManager.new
      url = js_assets.url
      if url
        url = context['site.root'].sub(/\/\s*$/, '') + url
        "<script src='#{url}' type='text/javascript'></script>"
      else
        ''
      end
    end
  end
end

Liquid::Template.register_tag('javascript_tag', Octopress::JavascriptAssetsTag)
