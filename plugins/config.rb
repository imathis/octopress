# read and write to the _config.yml
require 'yaml'

module SiteConfig
  ConfigFile = File.expand_path "../_config.yml", File.dirname(__FILE__)

  def get_config (key)
    config_data = YAML::load(File.open(ConfigFile))
    config_data[key]
  end
  def set_config (key, val)
    old_val = get_config(key)
    config = IO.read(ConfigFile)
    config.sub!(/#{key}:\s*#{old_val}/, "#{key}: #{val}")
    File.open(ConfigFile, 'w') do |f|
      f.write config
    end
  end
end
