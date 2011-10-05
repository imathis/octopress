# http://rspec.info/
# https://www.relishapp.com/rspec/
require '../lib/octopress/deployment'

describe "Octopress::Deployment" do
  before(:all) do
      class Test

      end
  #   module Octopress
  #     ROOT = File.expand_path '../', File.dirname(__FILE__)
  #   end
  end

  # after(:all) do
  #   begin
  #     File.delete('$test.yml') if File.exists?('$test.yml')
  #   rescue; end
  # end

  it "should initially return an empty Hash" do
    Octopress::Deployment.platforms.should eql({})
  end

  it "should register a class" do
    Octopress::Deployment.register_platform('test', Test)
    Octopress::Deployment.platforms['test'].should eql(Test)
  end
  
end
