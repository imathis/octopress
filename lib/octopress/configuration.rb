require 'yaml'

module Octopress
  module Configuration
    CONFIG_DIR = File.join(File.dirname(__FILE__), '../', '../' '_config')

    def self.config_dir(*subdirs)
      File.absolute_path(File.join(CONFIG_DIR, *subdirs))
    end

    # Static: Reads the configuration of the specified file
    #
    # path - the String path to the configuration file, relative to ./_config
    #
    # Returns a Hash of the items in the configuration file (symbol keys)
    def self.read_config(path)
      full_path = self.config_dir(path)
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
    def self.write_config(path, obj)
      YAML.dump(obj.to_string_keys, File.open(self.config_dir(path), 'w'))
    end

    # Static: Reads all the configuration files into one hash
    #
    # Returns a Hash of all the configuration files, with each key being a symbol
    def self.read_configuration
      configs = {}
      Dir.glob(self.config_dir('defaults', '**', '*.yml')) do |filename|
        file_yaml = YAML.load(File.read(filename))
        unless file_yaml.nil?
          configs = file_yaml.deep_merge(configs)
        end
      end
      Dir.glob(self.config_dir('*.yml')) do |filename|
        file_yaml = YAML.load(File.read(filename))
        unless file_yaml.nil?
          configs = configs.deep_merge(file_yaml)
        end
      end

      configs.to_symbol_keys
    end

    # Static: Writes configuration files necessary for generation of the Jekyll site
    #
    # Returns a Hash of the items which were written to the Jekyll configuration file
    def self.write_configs_for_generation
      config = self.read_configuration
      jekyll_configs = {}
      File.open("_config.yml", "w") do |f|
        jekyll_configs = config.to_string_keys.to_yaml :canonical => false
        f.write(jekyll_configs)
      end
      
      jekyll_configs
    end

    # Static: Removes configuration files required for site generation
    #
    # Returns the number of files deleted
    def self.remove_configs_for_generation
      File.unlink("_config.yml")
    end
  end
end
