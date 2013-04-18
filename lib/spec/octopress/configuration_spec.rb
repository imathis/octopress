require "spec_helper"

describe Octopress do
  include Octopress::Test::Environment

  CONFIG_PATH_OVERRIDE = File.join(File.dirname(__FILE__), '../', 'fixtures', 'no_override')
  before do
    Octopress.configurator(CONFIG_PATH_OVERRIDE)
  end

  describe ".configurator" do
    subject do
      Octopress.configurator
    end

    it "should use the path it was initialized with for its configuration" do
      subject.config_dir.should eq(File.expand_path(CONFIG_PATH_OVERRIDE))
    end
  end

  describe ".configuration" do
    subject do
      Octopress.configuration[:title]
    end

    it "should provide access to the specified configuration" do
      should eq('My Octopress Blog')
    end
  end
end

describe Octopress::Configuration do
  include Octopress::Test::Environment

  describe '#read_configuration' do
    describe "when no override" do
      before do
        @octo_config = Octopress::Configuration.new(File.join(File.dirname(__FILE__), '../', 'fixtures', 'no_override'))
      end
      let(:configuration) { @octo_config.read_configuration }

      it "returns the default config with keys as symbols" do
        expected_config = { :url           => "http://yoursite.com",
                            :title         => "My Octopress Blog",
                            :subtitle      => "A blogging framework for hackers.",
                            :author        => "Your Name",
                            :simple_search => "http://google.com/search",
                            :env           => "development",
                            :description   => nil }
        configuration.should eq(expected_config)
      end
    end

    describe "when override" do
      before do
        @octo_config = Octopress::Configuration.new(File.join(File.dirname(__FILE__), '../', 'fixtures', 'override'))
      end
      let(:configuration) { @octo_config.read_configuration }

      it "returns the default config with keys as symbols" do
        expected_config = { :url           => "http://myownsite.com",
                            :title         => "My Octopress custom Blog",
                            :subtitle      => "How did this get here? I'm not good with computers",
                            :author        => "John Doe",
                            :simple_search => "http://google.com/search",
                            :env           => "development",
                            :description   => nil }
        configuration.should eq(expected_config)
      end
    end
  end
end
