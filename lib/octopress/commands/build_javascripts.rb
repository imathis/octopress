module Octopress
  module Commands
    class BuildJavascripts < Command
      class << self
        def run(args, options = {})
          if Dir.exists? "javascripts"
            js_assets = Octopress::JSAssetsManager.new
            puts js_assets.compile
          else
            Octopress.logger.debug "No javascripts to compile. Skipping."
          end
        end
      end
    end
  end
end
