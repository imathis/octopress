require 'spec_helper'
require 'lib/octopress/deployment'

describe "Octopress::Deployment" do
  before(:all) do
      class Test
      end
  end

  it "should initially return an empty Hash" do
    Octopress::Deployment.platforms.should eql({})
  end

  it "should register a class" do
    Octopress::Deployment.register_platform('test', Test)
    Octopress::Deployment.platforms['test'].should be_kind_of(Test)
  end
end
