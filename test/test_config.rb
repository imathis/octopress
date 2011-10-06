require '../lib/octopress/config'

describe "Octopress::Configuration" do
  before(:all) do
    module Octopress
      ROOT = File.expand_path '../', File.dirname(__FILE__)
    end
  end

  after(:all) do
    begin
      File.delete('$test.yml') if File.exists?('$test.yml')
    rescue; end
  end

  it "should load _config.yml" do
    config_yml = Octopress::Configuration.new('_config.yml')
    config_yml.config.should_not eql(nil)
  end

  it "should not load a nonexistant file" do
    nonexistant = Octopress::Configuration.new('nonexistant.yml')
    nonexistant.config.should eql(nil)
  end
  
  it "should write a Hash to a file" do
    hash1 = Octopress::Configuration.new('test/$test.yml')
    hash1.write({
      'string' => 'value',
      :symbol  => 'value'
    })
    hash2 = Octopress::Configuration.new('test/$test.yml')
    hash2.config['string'].should eql('value')
    hash2.config['symbol'].should eql('value')
  end
end
