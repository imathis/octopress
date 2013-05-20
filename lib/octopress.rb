$:.unshift File.expand_path(File.dirname(__FILE__))

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
    Dir.pwd
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
    @@logger ||= Ink.build
  end
end

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# stdlib
require 'logger'

# gems
require 'colorator'
require 'open3'
require 'stringex'
require 'time'
require 'tzinfo'
require 'safe_yaml'

# octopress
require "octopress/command"
require_all "octopress/commands"
require "octopress/configuration"
require "octopress/core_ext"
require "octopress/dependency_installer"
require_all "octopress/formatters"
require "octopress/ink"
require "octopress/inquirable_string"
require "octopress/js_asset_manager"
require "octopress/version"
