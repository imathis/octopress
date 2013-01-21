$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

module Octopress
end

require "octopress/core_ext"
require "octopress/configuration"
