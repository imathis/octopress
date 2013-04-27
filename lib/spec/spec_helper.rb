# This file is copied to spec/ when you run 'rails generate rspec:install'

# We load SimpleCov first otherwise it won't see our code.  It only looks at
# files loaded AFTER it...
require File.expand_path("../support/simplecov", __FILE__)
require File.expand_path("../../octopress", __FILE__)

# For testing plugins...
require 'jekyll'
require 'rubypants'
Dir[Octopress.plugin_root.concat("**/*.rb")].each {|f| require f}

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
