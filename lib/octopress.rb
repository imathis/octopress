$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

require "octopress/core_ext"
require "octopress/configuration"

module Octopress
  class InquirableString < String
    def method_missing(name, *args, &block)
      if(name =~ /^.*\?$/)
        val = name.to_s.sub(/\?$/, '')
        return self == val
      else
        super
      end
    end
  end

  # Static: Fetches the Octopress environment
  def self.env
    # Not simply memoizing the result in case the configuration changes out
    # from under us at runtime...  Not sure if that can happen, but just in
    # case let's be conservative in our behavior here.
    env_raw_tmp = ENV["OCTOPRESS_ENV"] || self.configuration[:env]
    if(env_raw_tmp != @env_raw)
      @env = nil
    end
    @env_raw = env_raw_tmp
    @env = InquirableString.new(@env_raw)
  end
end
