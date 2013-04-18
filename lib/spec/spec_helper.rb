# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path("../../octopress", __FILE__)
require 'rspec'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Octopress.lib_root.concat("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # Include FactoryGirl helpers
  # config.include FactoryGirl::Syntax::Methods

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

module Octopress
  module Test
    module Environment
      def self.included(target)
        target.instance_eval do
          before do
            Octopress.clear_config!
            @old_env = ENV['OCTOPRESS_ENV']
            ENV['OCTOPRESS_ENV'] = nil
          end

          after do
            ENV['OCTOPRESS_ENV'] = @old_env
          end
        end
      end
    end
  end
end
