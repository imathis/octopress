require "spec_helper"

describe Octopress do
  describe ".configurator" do
    before do
      Octopress.clear_config!
      @old_env = ENV['OCTOPRESS_ENV']
      ENV['OCTOPRESS_ENV'] = nil
    end

    after do
      ENV['OCTOPRESS_ENV'] = @old_env
    end

    it "should accept a path pointing to a config directory" do
      Octopress.configurator(File.join(File.dirname(__FILE__), '../', 'fixtures', 'env'))

      Octopress.env.should eq('config_specified_environment')
    end
  end

  describe ".configuration" do
    before do
      Octopress.clear_config!
      @old_env = ENV['OCTOPRESS_ENV']
      ENV['OCTOPRESS_ENV'] = nil
      Octopress.configurator(File.join(File.dirname(__FILE__), '../', 'fixtures', 'env'))
    end

    after do
      ENV['OCTOPRESS_ENV'] = @old_env
    end

    let(:configuration) { Octopress.configuration }

    it "should provide access to the specified configuration" do
      configuration[:env].should eq('config_specified_environment')
    end
  end
end

describe Octopress::Configuration do
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
                            :description   => nil }
        configuration.should eq(expected_config)
      end
    end
  end
end
