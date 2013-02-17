require 'minitest/autorun'
require_relative '../../lib/octopress'

describe Octopress::Configuration do
  describe '.read_configuration' do
    subject do
      Octopress::Configuration.read_configuration
    end

    describe "when no override" do
      before do
        Octopress::Configuration::CONFIG_DIR = File.join(File.dirname(__FILE__), '../', 'fixtures', 'no_override')
      end

      it "returns the default config with keys as symbols" do
        expected_config = { :url           => "http://yoursite.com",
                            :title         => "My Octopress Blog",
                            :subtitle      => "A blogging framework for hackers.",
                            :author        => "Your Name",
                            :simple_search => "http://google.com/search",
                            :description   => nil }
        subject.must_equal expected_config
      end
    end

    describe "when override" do
      before do
        Octopress::Configuration::CONFIG_DIR = File.join(File.dirname(__FILE__), '../', 'fixtures', 'override')
      end

      it "returns the default config with keys as symbols" do
        expected_config = { :url           => "http://myownsite.com",
                            :title         => "My Octopress custom Blog",
                            :subtitle      => "How did this get here? I'm not good with computers",
                            :author        => "John Doe",
                            :simple_search => "http://google.com/search",
                            :description   => nil }
        subject.must_equal expected_config
      end
    end
  end
end
