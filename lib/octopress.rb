$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed

require "octopress/core_ext"
require "octopress/logger"
require "octopress/configuration"
require "octopress/inquirable_string"
require "octopress/dependency_installer"
require "octopress/js_asset_manager"

module Octopress
  # Static: Get absolute file path of the octopress lib directory
  #
  # Returns the absolute path to the octopress lib directory
  def self.lib_root
    File.dirname(__FILE__)
  end

  # Static: Get absolute file path of the main octopress installation
  #
  # Returns the absolute path of the main octopress installation
  def self.root
    File.dirname(lib_root)
  end

  # Static: Fetches the Octopress environment
  #
  # Returns the Octopress environment as an InquirableString
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

  # Static: Fetch the logger for Octopress
  #
  # Returns the Logger, based on Ruby's stdlib Logger
  def self.logger
    @@logger ||= Logger.build
  end
end
