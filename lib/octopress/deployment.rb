$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed
require 'config'

module Octopress

  class Deployment
    @@platforms = {}

    class << self
      
      def register_platform(name, klass)
        @@platforms[name.to_s] = klass
      end
      
      def platforms
        @@platforms ||= {}
      end

      def write_config(config)
        deploy_config = Configuration.new('deploy.yml')
        deploy_config.write(config)
        puts "Configuration written to deploy.yml"
      end

      # Interface methods
      def setup; raise "Method 'setup' must be overridden"; end
      def deploy; raise "Method 'deploy' must be overridden"; end

    end

  end

end
