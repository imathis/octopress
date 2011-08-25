require 'thor'
require 'yaml'

module Octopress
  class CLI < Thor
    include Thor::Actions

    default_task :help

    desc 'help [task]', 'Explain available tasks or one specific task'
    def help(*args)
      puts "http://octopress.org/docs/"
    end

    desc 'install [theme]', 'Install a theme for Octopres. Defaults to classic theme.'
    def install(theme = 'classic')
      puts "## Copying #{theme} theme into ./#{source_dir} and ./sass"
      mkdir_p source_dir
      cp_r "#{themes_dir}/#{theme}/source/.", source_dir
      mkdir_p "sass"
      cp_r "#{themes_dir}/#{theme}/sass/.", "sass"
      mkdir_p "#{source_dir}/#{posts_dir}"
      mkdir_p public_dir
    end

    private

    def method_missing(method_name, *args)
      if config.key? method_name.to_s
        config[method_name.to_s]
      else
        super
      end
    end

    def config
      @config ||= YAML::load(File.open('_config.yml'))
    end
  end
end
