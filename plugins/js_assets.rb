$:.unshift File.expand_path("../lib", File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'octopress'

class JavascriptAssets < Liquid::Tag
  def initialize(tag_name, options, tokens)
    super
  end

  def render(context)
    js_assets = Octopress::JSAssetsManager.new
    js_assets.url
  end
end

Liquid::Template.register_tag('javascript_assets_tag', JavascriptAssets)
