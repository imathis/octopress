require 'guard'
require 'guard/guard'
require 'guard/watcher'

$:.unshift File.expand_path("..", File.dirname(__FILE__))
require 'octopress'

module Guard
  class Jekyll < Guard

    VERSION = '0.0.2'

    # Calls #run_all if the :all_on_start option is present.
    def start
      run_all if options[:all_on_start]
    end

    # Call #run_on_change for all files which match this guard.
    def run_all
      if Watcher.match_files(self, Dir.glob('{,**/}*{,.*}').uniq).size > 0
        Octopress.configurator.write_configs_for_generation
        system "jekyll build #{"--drafts" unless Octopress.env == 'production'}"
        Octopress.configurator.remove_configs_for_generation
      end
    end

    def run_on_changes(_)
      Octopress.configurator.write_configs_for_generation
      system "jekyll build #{"--drafts" unless Octopress.env == 'production'}"
      Octopress.configurator.remove_configs_for_generation
    end
  end
end
