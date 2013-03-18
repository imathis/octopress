$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed

require "octopress/core_ext"
require "octopress/configuration"
require "octopress/js_asset_manager"

module Octopress

  # Static: Fetches the Octopress environment
  def self.env
    configurator   = Octopress::Configuration.new
    ENV["OCTOPRESS_ENV"] || configurator.read_config("defaults/jekyll.yml").deep_merge(configurator.read_config("site.yml"))[:env]
  end
end
