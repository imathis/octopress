$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed

require "octopress/core_ext"
require "octopress/configuration"
require "octopress/inquirable_string"
require "octopress/js_asset_manager"

module Octopress
  # Static: Get absolute file path of the octopress lib directory.
  #
  # Returns the absolute path to the octopress lib directory.
  def self.lib_root
    File.dirname(__FILE__)
  end

  # Static: Get absolute file path of the octopress themes directory.
  #
  # Returns the absolut path to the octopress themes directory.
  def self.themes_root
    File.expand_path(File.join(File.dirname(__FILE__), '../', '.themes'))
  end

  # Static: Get absolute file path of the octopress config directory.
  #
  # Returns the absolut path to the octopress config directory.
  def self.default_config_root
    File.expand_path(File.join(File.dirname(__FILE__), '../', '_config'))
  end

  # Static: Fetches the Octopress environment.
  #
  # Returns an object that can be queried for the environment by treating it as
  # a string, a symbol, or using a Rails-style `.foo?` method call.
  def self.env
    # Not simply memoizing the result in case the configuration changes out
    # from under us at runtime...  Not sure if that can happen, but just in
    # case let's be conservative in our behavior here.
    env_raw_tmp = (ENV["OCTOPRESS_ENV"] || self.configuration[:env]).to_s
    if(env_raw_tmp != @env_raw)
      @env = nil
    end
    @env_raw = env_raw_tmp
    @env ||= InquirableString.new(@env_raw)
  end
end
