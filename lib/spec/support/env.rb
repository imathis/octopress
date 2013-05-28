module Octopress
  # Infrastructure for simplifying test setup and teardown for Octopress.
  module Test
    # Manage the `OCTOPRESS_ENV` environment variable to prevent
    # cross-test-method tainting.
    #
    # Simply put the following in the top of your outer-most `describe` block
    # and the rest will be taken care of automatically:
    #
    # ```ruby
    # include Octopress::Test::Environment
    # ```
    module Environment
      def fixture_path(fixture=nil)
        @base_fixture_path ||= File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures'))
        path = @base_fixture_path
        path = File.join(path, fixture) if fixture
        return path
      end

      def self.included(target)
        target.instance_eval do
          before do
            Octopress.clear_config!
            @old_env = ENV['OCTOPRESS_ENV']
            ENV['OCTOPRESS_ENV'] = nil
          end

          after do
            ENV['OCTOPRESS_ENV'] = @old_env
          end
        end
      end
    end
  end
end
