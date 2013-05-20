module Octopress
  module Commands
    class BuildStylesheets < Command
      class << self
        def run(args, options)
          if Dir.exists? "stylesheets"
            system "compass compile --css-dir #{options[:source]}/stylesheets"
          else
            Octopress.logger.debug "No stylesheets to compile. Skipping."
          end
        end
      end
    end
  end
end
