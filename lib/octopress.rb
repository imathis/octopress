$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed

require "octopress/core_ext"
require "octopress/configuration"
require "octopress/dependency_installer"
require "octopress/js_asset_manager"

module Octopress
  # Static: Get absolute file path of the octopress lib directory
  #
  # Returns the absolute path to the octopress lib directory
  def self.lib_root
    File.dirname(__FILE__)
  end

  # Static: Fetches the Octopress environment
  def self.env
    configurator   = Octopress::Configuration.new
    ENV["OCTOPRESS_ENV"] || configurator.read_config("defaults/jekyll.yml").deep_merge(configurator.read_config("site.yml"))[:env]
  end
end
