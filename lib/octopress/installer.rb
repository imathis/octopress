module Octopress
  class Installer

    def initalize(plugin_name)
      begin
        require "#{plugin_name}"
      rescue LoadError
        Octopress.logger.error "We can't load the plugin '#{plugin_name}'. Please add it" +
                               " to your Gemfile and run 'bundle install' and try" +
                               " installing the plugin again."
        raise LoadError
      end

      @plugin_name  = plugin_name
      @class_name   = plugin_name.gsub(/-_\ /, "_").split("_").map(&:capitalize).join("")
      @plugin_class = Object.const_get(@class_name)
    end

    def config_folder
      File.join(@plugin_class.root, "configs", "")
    end

    def install_configs
      FileUtils.cp_r config_folder, File.join(Dir.pwd, "config", plugin_slug)
    end

    def install
      %w[configs].each do |thing|
        send("install_#{thing}")
      end
    end

    def type
      manifest_yml.fetch('type') || "plugin"
    end

    def plugin_slug
      type == "plugin" ? manifest_yml.fetch('slug') : "theme"
    end

    private
    def manifest_yml
      YAML.safe_load_file(File.join(@plugin_class.root, "MANIFEST.yml")) || {}
    end

  end
end
