module Octopress
  module Commands
    class Build < Command
      class << self
        def run(args, options)
          BuildJavascripts.run(args, options)
          BuildStylesheets.run(args, options)
          BuildJekyll.run(args, options)
        end
      end
    end
  end
end
