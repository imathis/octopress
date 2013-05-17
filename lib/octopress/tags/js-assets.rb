$:.unshift File.expand_path("../../../lib", File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'octopress'

module Octopress
  class JavascriptAssetsTag < Liquid::Tag
    def initialize(tag_name, options, tokens)
      super
    end

    def render(context)
      js_assets = Octopress::JSAssetsManager.new
      js_assets.url
    end
  end
end

Liquid::Template.register_tag('js-assets', Octopress::JavascriptAssetsTag)
