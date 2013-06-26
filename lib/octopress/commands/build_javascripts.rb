module Octopress
  module Commands
    class BuildJavascripts < Command
      class << self
        def process(args, options)
          puts Octopress::JSAssetsManager.new.compile if Dir.exists?("javascripts")
        end
      end
    end
  end
end
