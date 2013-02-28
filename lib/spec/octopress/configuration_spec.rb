require 'minitest/autorun'
require_relative '../../octopress'

describe Octopress::Configuration do
  describe '#read_configuration' do
    describe "when no override" do
      before do
        @octo_config = Octopress::Configuration.new(File.join(File.dirname(__FILE__), '../', 'fixtures', 'no_override'))
      end

      subject do
        @octo_config.read_configuration
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
        @octo_config = Octopress::Configuration.new(File.join(File.dirname(__FILE__), '../', 'fixtures', 'override'))
      end

      subject do
        @octo_config.read_configuration
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
