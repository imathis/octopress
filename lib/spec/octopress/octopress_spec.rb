require 'minitest/autorun'
require_relative '../../octopress'

describe Octopress do
  describe '#env' do
    describe "when ENV['OCTOPRESS_ENV'] is specified" do
      before do
        @old_value = ENV['OCTOPRESS_ENV']
        ENV['OCTOPRESS_ENV'] = 'some_environment'
      end

      after do
        ENV['OCTOPRESS_ENV'] = @old_value
      end

      subject do
        Octopress.env
      end

      it "returns the environment as something that quacks like a string" do
        subject.must_equal 'some_environment'
      end

      # For the InquirableString functionality...
      describe "#some_environment?" do
        subject do
          Octopress.env.some_environment?
        end

        it "returns true when the environment is set to 'some_environment'" do
          subject.must_equal true
        end
      end

      describe "#some_other_environment?" do
        subject do
          Octopress.env.some_other_environment?
        end

        it "returns false when the environment is set to 'some_environment'" do
          subject.must_equal false
        end
      end
    end

    describe "when ENV['OCTOPRESS_ENV'] is NOT specified and a value is specified in config files" do
      before do
        @old_value = ENV['OCTOPRESS_ENV']
        ENV['OCTOPRESS_ENV'] = nil
        Octopress.configurator(File.join(File.dirname(__FILE__), '..', 'fixtures', 'env'))
      end

      after do
        ENV['OCTOPRESS_ENV'] = @old_value
        Octopress.clear_config!
      end

      subject do
        Octopress.env
      end

      it "returns the environment as something that quacks like a string" do
        subject.must_equal 'config_specified_environment'
      end

      # For the InquirableString functionality...
      describe "#config_specified_environment?" do
        subject do
          Octopress.env.config_specified_environment?
        end

        it "returns true when the environment is set to 'config_specified_environment'" do
          subject.must_equal true
        end
      end

      describe "#some_other_environment?" do
        subject do
          Octopress.env.some_other_environment?
        end

        it "returns false when the environment is set to 'config_specified_environment'" do
          subject.must_equal false
        end
      end
    end

    describe "when the configuration value changes mid-execution" do
      before do
        @old_value = ENV['OCTOPRESS_ENV']
        ENV['OCTOPRESS_ENV'] = 'value_a'
      end

      after do
        ENV['OCTOPRESS_ENV'] = @old_value
      end

      it "returns the initial environment value, then after it's changed, returns the new one" do
        Octopress.env.must_equal 'value_a'
        ENV['OCTOPRESS_ENV'] = 'value_b'
        Octopress.env.must_equal 'value_b'
      end
    end
  end
end
