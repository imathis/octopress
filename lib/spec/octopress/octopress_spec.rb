require "spec_helper"

describe Octopress do
  include Octopress::Test::Environment

  describe '#env' do
    context "when ENV['OCTOPRESS_ENV'] is specified as 'some_environment'" do
      before do
        ENV['OCTOPRESS_ENV'] = 'some_environment'
        Octopress.configurator(File.join(File.dirname(__FILE__), '..', 'fixtures', 'env'))
      end

      subject do
        Octopress.env
      end

      it "returns the environment as something that quacks like a String" do
        should eq('some_environment')
      end

      it "returns the environment as something that quacks like a Symbol" do
        should eq(:some_environment)
      end

      # For the InquirableString functionality...
      describe "#some_environment?" do
        subject do
          Octopress.env.some_environment?
        end

        it "returns true when the environment is set to 'some_environment'" do
          should be_true
        end
      end

      describe "#some_other_environment?" do
        subject do
          Octopress.env.some_other_environment?
        end

        it "returns false when the environment is set to 'some_environment'" do
          should be_false
        end
      end
    end

    describe "when the configuration value changes mid-execution" do
      before do
        ENV['OCTOPRESS_ENV'] = 'value_a'
      end

      it "returns the initial environment value, then after it's changed, returns the new one" do
        Octopress.env.should eq('value_a')
        ENV['OCTOPRESS_ENV'] = 'value_b'
        Octopress.env.should eq('value_b')
      end
    end
  end
end
