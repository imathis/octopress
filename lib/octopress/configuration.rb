require 'yaml'

module Octopress
  def self.configurator(root_dir = Octopress.default_config_root)
    @configurator ||= Configuration.new(root_dir)
  end

  def self.configuration(default_environment = nil)
    # If we're being given a hint about using an environment other than the one
    # presently active, wipe the memoization and let the configs be re-read.
    #
    # This may be a *touch* wasteful, but ensures proper semantics across the
    # board.
    if(@configuration && default_environment != @configuration[:env])
      @configuration = nil
    end
    @configuration ||= self.configurator.read_configuration(default_environment)
  end

  def self.clear_config!
    @configurator = nil
    @configuration = nil
  end

  class Configuration
    # The active configuration directory.
    attr_accessor :config_directory

    def initialize(config_dir = Octopress.default_config_root)
      self.config_directory = File.expand_path(config_dir)
    end

    def config_dir(*subdirs)
      File.absolute_path(File.join(self.config_directory, *subdirs))
    end

    def theme_config_dir(theme, *subdirs)
      File.absolute_path(File.join(Octopress.themes_root, theme, '_config', *subdirs))
    end

    # Static: Reads the configuration of the specified file
    #
    # path - the String path to the configuration file, relative to ./_config
    #
    # Returns a Hash of the items in the configuration file (symbol keys)
    def read_config(path)
      full_path = path.start_with?('/') ? path : self.config_dir(path)
      if File.exists? full_path
        begin
          configs = YAML.load(File.open(full_path))
          if configs.nil?
            Hash.new
          else
            configs.to_symbol_keys
          end
        rescue => e
          puts "Error reading configuration file '#{full_path}':"
          puts e.message, e.backtrace
          exit(-1)
        end
      else
        raise ArgumentError, "File at '#{full_path}' does not exist."
      end
    end

    # Static: Writes the contents of a set of configurations to a path in the config directory
    #
    # path - the String path to the configuration file, relative to ./_config
    # obj  - the object to be dumped into the specified file in YAML form
    #
    # Returns the Hash for the configuration file.
    def write_config(path, obj)
      File.open(self.config_dir(path), 'w') do
        YAML.dump(obj.to_string_keys, fh)
      end
    end

    # Static: Reads all the configuration files into one hash
    #
    # Returns a Hash of all the configuration files, with each key being a symbol
    def read_configuration(default_environment = nil)
      configs = {}
      Dir.glob(self.config_dir('defaults', '**', '*.yml')) do |filename|
        file_yaml = read_config(filename)
        configs = file_yaml.deep_merge(configs)
      end
      Dir.glob(self.config_dir('*.yml')) do |filename|
        file_yaml = read_config(filename)
        configs = configs.deep_merge(file_yaml)
      end
      env = ENV["OCTOPRESS_ENV"] || default_environment || 'development'
      if(env)
        configs[:env] = env
        # If we don't have an explicit OCTOPRESS_ENV and we DO have an explicit
        # hint about what the environment should default to, then set
        # OCTOPRESS_ENV so downstream processes will see the right value.
        # However, don't bother setting it if we weren't given a hint and just
        # fell through to the last-resort fallback.
        ENV['OCTOPRESS_ENV'] = env if(default_environment)
      end
      env_path = self.config_dir('environments', "#{configs[:env]}.yml")
      if(File.exist?(env_path))
        file_yaml = YAML.load(File.read(env_path))
        unless file_yaml.nil?
          configs = configs.deep_merge(file_yaml)
        end
      end

      configs.to_symbol_keys
    end

    # Static: Reads all the theme's configuration files into one hash
    #
    # Returns a Hash of all the configuration files, with each key being a symbol
    def read_theme_configuration(theme)
      configs = {}
      Dir.glob(self.theme_config_dir(theme, '**', '*.yml')) do |filename|
        file_yaml = YAML.load(File.read(filename))
        unless file_yaml.nil?
          configs = file_yaml.deep_merge(configs)
        end
      end

      configs.to_symbol_keys
    end

    # Static: Writes configuration files necessary for generation of the Jekyll site
    #
    # Returns a Hash of the items which were written to the Jekyll configuration file
    def write_configs_for_generation
      jekyll_configs = {}
      File.open("_config.yml", "w") do |f|
        jekyll_configs = Octopress.configuration.to_string_keys.to_yaml :canonical => false
        f.write(jekyll_configs)
      end

      jekyll_configs
    end

    # Static: Removes configuration files required for site generation
    #
    # Returns the number of files deleted
    def remove_configs_for_generation
      File.unlink("_config.yml")
    end
  end
end
