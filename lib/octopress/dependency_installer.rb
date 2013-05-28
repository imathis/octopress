require 'uri'
require 'open3'
require 'fileutils'

module Octopress
  class DependencyInstaller

    # Static: installs a list of plugins
    #
    # plugins - an Array of plugin names
    #
    # Returns nothing
    def self.install_all(plugins)
      if plugins.is_a?(String)
        plugins = [plugins]
      end
      installer = DependencyInstaller.new
      plugins.each do |plugin|
        installer.install plugin
      end
    end

    CACHE_DIR             = File.join(Octopress.root, ".plugins")
    USERNAME_REPO_REGEXP  = /^([a-z0-9\-_]+)\/([a-z0-9\-_]+)$/
    OCTOPRESS_REPO_REGEXP = /^[a-z0-9\-_]+$/
    GIT_REPO_REGEXP       = /^(git:\/\/|https:\/\/|git@)([a-z0-9.]+)(\/|:)([a-z0-9\-_]+)\/([a-z0-9\-_]+)\.git/

    # Public: Create a new DependencyInstaller and initialize instance variables
    #
    # Returns nothing
    def initialize(plugins = [])
      @plugins = Set.new.merge(plugins)
    end

    # Public: constructs full git URL for a plugin
    #
    # plugin - the plugin name
    #
    # Returns full git URL for a plugin
    def git_url(plugin)
      if OCTOPRESS_REPO_REGEXP.match(plugin)
        "git://github.com/octopress/#{plugin}.git"
      elsif USERNAME_REPO_REGEXP.match(plugin)
        "git://github.com/#{plugin}.git"
      else
        plugin
      end
    end

    # Public: Gets the directory for local storage
    #
    # Returns the directory for the plugin
    def namespace(plugin)
      if manifest(plugin)["type"].to_s == "theme"
        "theme"
      else
        manifest(plugin)["slug"]
      end
    end

    # Public: builds full installation directory path for plugin
    #
    # plugin - the plugin name
    #
    # Returns the full path of the installation directory
    def cache_dir(plugin)
      FileUtils.mkdir_p(CACHE_DIR) unless File.exists?(CACHE_DIR)
      File.join(CACHE_DIR, File.basename(plugin).gsub(/\.git$/, ''))
    end

    # Public: clones the remote repository to the plugin install directory
    #
    # plugin - the plugin name
    #
    # Returns the file path to where the plugin was installed
    def clone(plugin)
      if File.directory?(cache_dir(plugin))
        Open3.popen3("cd #{cache_dir(plugin)} && git pull origin master") do |stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value
          raise RuntimeError, "Error updating #{plugin}".red unless exit_status.exitstatus == 0
        end
      else
        Open3.popen3("git clone #{git_url(plugin)} #{cache_dir(plugin)}") do |stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value
          raise RuntimeError, "Error cloning #{plugin}".red unless exit_status.exitstatus == 0
        end
      end
      cache_dir(plugin)
    end

    # Public: fetches the contents of the manifest file as a Hash
    #
    # plugin - the plugin name
    #
    # Returns a Hash of the contents of the manifest file
    def manifest(plugin)
      @manifests = {} if @manifests.nil?
      if @manifests.has_key?(plugin)
        @manifests[plugin]
      else
        @manifests[plugin] = YAML.load_file(File.join(cache_dir(plugin), "manifest.yml"))
      end
    end

    # Public: build dependency tree for a plugin
    #
    # plugin - the plugin name
    #
    # Returns an array of plugin names that are dependencies of the one specified
    def build_dependencies_tree(plugin)
      unless @plugins.include?(plugin)
        clone(plugin)
        manifest_yml = manifest(plugin)
        Octopress.logger.debug manifest_yml.to_s
        return [plugin] if !manifest_yml.has_key?("dependencies") || manifest_yml["dependencies"].size == 0
        manifest_yml["dependencies"].each do |dep|
          build_dependencies_tree(dep)
        end
      else
        Octopress.logger.warn "Already installed #{plugin}."
      end
    end

    # Public: copy files from the plugin clone to the user's source directory
    #
    # plugin - the plugin name
    #
    # Returns an Array of file paths which were copied
    def copy_files(plugin)
      manifest_yml = manifest(plugin)
      %w[javascripts stylesheets plugins config source includes].each do |type|
        Octopress.logger.debug "Copying #{type} files for #{plugin}..."
        send("copy_#{type}_files", plugin)
      end
    end

    # Public: install a plugin and its dependencies
    #
    # plugin - the plugin name
    #
    # Returns the Array of all plugins installed so far
    def install(plugin)
      @plugins.merge(build_dependencies_tree(plugin))
      @plugins.each do |plugin|
        copy_files(plugin)
      end

      @plugins
    end

    private
    # Private: Copy file to Octopress installation
    #
    # files       - a list of files
    # destination - the directory in which the files should be copied
    #
    # Returns nothing
    def copy_file_list(files, destination)
      if files.size > 0
        FileUtils.mkdir_p(destination, verbose: false) unless File.directory?(destination)
        if files.is_a?(String) && File.directory?(files)
          Octopress.logger.debug "Copying #{files}/. to #{destination} ..."
          FileUtils.cp_r "#{files}/.", destination, verbose: false
        else
          Octopress.logger.debug "Copying #{files.join(", ")} to #{destination} ..."
          FileUtils.cp files, destination, verbose: false
        end
      end
    end

    # Private: Fetch list of files in a file recursively
    #
    # plugin   - plugin name
    # *subdirs - a
    def globbed_filelist(plugin, *subdirs)
      Dir.glob(File.join(cache_dir(plugin), *subdirs, "**", "*")).select do |filename|
        File.file?(filename)
      end
    end

    # Private: Copy source files to local Octopress installation
    #
    # plugin - plugin name
    #
    # Returns nothing
    def copy_source_files(plugin)
      source      = File.join(cache_dir(plugin), "source")
      destination = File.join(Octopress.root, Octopress.configuration[:source])
      destination = File.join(destination, namespace(plugin)) if manifest(plugin)["type"] != "theme"
      if File.directory?(source)
        copy_file_list(source, destination)
      end
    end

    # Private: Copy includes files to local Octopress installation
    #
    # plugin - plugin name
    #
    # Returns nothing
    def copy_includes_files(plugin)
      source      = File.join(cache_dir(plugin), "includes")
      destination = File.join(Octopress.root, Octopress.configuration[:source], "_includes", namespace(plugin))
      if File.directory?(source)
        copy_file_list(source, destination)
      end
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the stylesheet files for this plugin relative to
    #         the stylesheets dir in the plugin's install dir
    #
    # Returns nothing
    def copy_config_files(plugin)
      source      = File.join(cache_dir(plugin), "configs")
      destination = File.join(Octopress.root, "config", "defaults", namespace(plugin))
      if File.directory?(source)
        copy_file_list(source, destination)
      end
    end

    def config_files(plugin)
      globbed_filelist(plugin, "configs")
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    #
    # Returns nothing
    def copy_javascripts_files(plugin)
      source      = File.join(cache_dir(plugin), "javascripts", "lib")
      destination = File.join(Octopress.root, "javascripts", "lib", namespace(plugin))
      if File.directory?(source)
        copy_file_list(source, destination)
      end
      source      = File.join(cache_dir(plugin), "javascripts", "modules")
      destination = File.join(Octopress.root, "javascripts", "modules", namespace(plugin))
      if File.directory?(source)
        copy_file_list(source, destination)
      end
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the stylesheet files for this plugin relative to
    #         the stylesheets dir in the plugin's install dir
    #
    # Returns nothing
    def copy_stylesheets_files(plugin)
      source      = File.join(cache_dir(plugin), "stylesheets")
      sass_dir    = File.join(Octopress.root, "stylesheets")
      namespace   = namespace(plugin)

      if namespace == 'theme'
        destination = File.join(sass_dir, namespace(plugin))
      else
        destination = File.join(sass_dir, 'plugins', namespace(plugin))
      end
      if File.directory?(source)
        copy_file_list(source, destination)
      end
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the Jekyll plugin files for this plugin relative
    #         to the plugin dir in the plugin's install dir
    #
    # Returns nothing
    def copy_plugins_files(plugin)
      source      = File.join(cache_dir(plugin), "plugins")
      install_dir = Octopress.configuration[:plugins].is_a?(Array) ? Octopress.configuration[:plugins].last : Octopress.configuration[:plugins]
      destination = File.join(Octopress.root, install_dir, namespace(plugin))
      if File.directory?(source)
        copy_file_list(source, destination)
      end
    end

    def plugin_files(plugin)
      globbed_filelist(plugin, "plugins")
    end
  end
end
