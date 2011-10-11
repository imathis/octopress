require 'spec_helper'
require 'lib/octopress/config'

describe "Octopress::Configuration" do
  before(:all) do
    module Octopress
      ROOT = File.expand_path '../', File.dirname(__FILE__)
    end
  end

  after(:all) do
    begin
      File.delete('spec/$test.yml') if File.exists?('spec/$test.yml')
    rescue
      puts "Could not delete 'spec/$test.yml'"
    end
  end

  context "for existing files" do
    it "should load the file" do
      config_yml = Octopress::Configuration.new('_config.yml')
      config_yml.config.should_not be_nil
    end
  end

  context "for not nonexistant files" do
    it "should return nil for #config" do
      nonexistant = Octopress::Configuration.new('nonexistant.yml')
      nonexistant.config.should be_nil
    end
  end
  
  it "should write a Hash to a file" do
    hash1 = Octopress::Configuration.new('spec/$test.yml')
    hash1.write({
      'string' => 'value',
      :symbol  => 'value'
    })
    hash2 = Octopress::Configuration.new('spec/$test.yml')
    hash2.config['string'].should eql('value')
    hash2.config['symbol'].should eql('value')
  end
end
