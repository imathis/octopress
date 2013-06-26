module Octopress
  module Commands
    class Build < Command
      class << self
        def process(args, options)
          if Dir.exists?("stylesheets")
            system "compass compile --css-dir #{Octopress.configuration[:source]}/stylesheets"
          end
        end
      end
    end
  end
end
