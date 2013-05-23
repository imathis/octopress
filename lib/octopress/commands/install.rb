module Octopress
  module Commands
    class Install < Command
      class << self
        def run(args, options = {})
          plugins = plugin_list(args)
          if plugins.empty?
            Octopress.logger.warn "No plugin or theme specified."
          else
            DependencyInstaller.install_all(plugins)
          end
        end

        private
        def plugin_list(args)
          case args
          when String
            args.split(" ")
          when Array
            args
          else
            Octopress.logger.warn "Specify the plugin or theme name(s), separated by spaces."
            []
          end
        end
      end
    end
  end
end
