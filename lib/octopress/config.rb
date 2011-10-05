require 'yaml'

module Octopress

  class Configuration
    attr_reader :config

    def initialize(filename)
      @filename = File.expand_path filename, Octopress::ROOT
      load(@filename) if File.exists?(@filename)
    end

    def load(filename)
      begin
        @config = YAML::load(File.open(@filename))
      rescue
        raise "YAML Exception reading Octopress config '#{@filename}'"
      end
    end

    def write(config)
      config = config.to_yaml.sub('---', '').gsub(/:(\w)/, '\1').lstrip unless config.kind_of?(String)
      File.open(@filename, 'w') { |f| f.write config }
    end

  end

end
