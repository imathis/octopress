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

    INSTALL_DIR           = File.join(Dir.pwd, ".plugins")
    USERNAME_REPO_REGEXP  = /^([a-z0-9\-_]+)\/([a-z0-9\-_]+)$/
    OCTOPRESS_REPO_REGEXP = /^[a-z0-9\-_]+$/
    GIT_REPO_REGEXP       = /^(git:\/\/|https:\/\/|git@)([a-z0-9.]+)(\/|:)([a-z0-9\-_]+)\/([a-z0-9\-_]+)\.git/

    # Public: Create a new DependencyInstaller and initialize instance variables
    #
    # Returns nothing
    def initialize
      @plugins = Set.new
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
    # plugin - the plugin name
    #
    # Returns the directory for the plugin
    def namespace(plugin)
      url = git_url(plugin)
      match = url.match(GIT_REPO_REGEXP)
      if match[1] == "git@"
        url = "git://#{match[2]}/#{match[4]}/#{match[5]}.git"
      end
      path = URI(url).path
      path[/([a-z0-9\-_]+)\/([a-z0-9\-_]+)\.git$/]
        .gsub(/\.git$/, '')
        .gsub(/octopress\//, '')
        .gsub(/\s+/, '-')
        .gsub(/\//, '-')
        .gsub(/-+/, '-')
    end

    # Public: builds full installation directory path for plugin
    #
    # plugin - the plugin name
    #
    # Returns the full path of the installation directory
    def install_dir(plugin)
      FileUtils.mkdir_p(INSTALL_DIR) unless File.exists?(INSTALL_DIR)
      File.join(INSTALL_DIR, File.basename(plugin).gsub(/\.git$/, ''))
    end

    # Public: clones the remote repository to the plugin install directory
    #
    # plugin - the plugin name
    #
    # Returns the file path to where the plugin was installed
    def clone(plugin)
      if File.directory?(install_dir(plugin))
        Open3.popen3("cd #{install_dir(plugin)} && git pull origin master") do |stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value
          raise RuntimeError, "Error updating #{plugin}".red unless exit_status.exitstatus == 0
        end
      else
        Open3.popen3("git clone #{git_url(plugin)} #{install_dir(plugin)}") do |stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value
          raise RuntimeError, "Error cloning #{plugin}".red unless exit_status.exitstatus == 0
        end
      end
      install_dir(plugin)
    end

    # Public: fetches the contents of the manifest file as a Hash
    #
    # plugin - the plugin name
    #
    # Returns a Hash of the contents of the manifest file
    def manifest(plugin)
      YAML.load_file(File.join(install_dir(plugin), "manifest.yml"))
    end

    # Public: build dependency tree for a plugin
    #
    # plugin - the plugin name
    #
    # Returns an array of plugin names that are dependencies of the one specified
    def build_dependencies_tree(plugin)
      unless @plugins.include?(plugin)
        clone(plugin)
        mainfest_yml = manifest(plugin)
        return [plugin] if !mainfest_yml.has_key?("dependencies") || manifest_yml["dependencies"].size == 0
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
      copy_javascript_files(plugin, manifest_yml["javascripts"]) if manifest_yml["javascripts"]
      copy_stylesheets_files(plugin, manifest_yml["stylesheets"]) if manifest_yml["stylesheets"]
      copy_plugins_files(plugin, manifest_yml["plugins"]) if manifest_yml["plugins"]
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
    # plugin - plugin name
    # file - the file destination relative to the Octopress installation root
    #
    # Returns nothing
    def copy_file(plugin, repo_files, file)
      source = File.join(install_dir(plugin), repo_files)
      destination = File.join(Octopress.root, file)
      FileUtils.rm_rf(destination)
      FileUtils.cp_r(source, destination)
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the javascript files for this plugin relative to
    #         the javascripts dir in the plugin's install dir
    #
    # Returns nothing
    def copy_javascript_files(plugin, files)
      [files["lib"]].flatten.each do |file|
        copy_file(plugin, file, File.join("assets", file))
      end
      [files["modules"]].flatten.each do |file|
        copy_file(plugin, file, File.join("assets", file))
      end
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the stylesheet files for this plugin relative to
    #         the stylesheets dir in the plugin's install dir
    #
    # Returns nothing
    def copy_stylesheets_files(plugin, files)
      [files].flatten.each do |file|
        copy_file(plugin, file, File.join("assets", "stylesheets", "plugins", namespace(plugin)))
      end
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the Jekyll plugin files for this plugin relative
    #         to the plugin dir in the plugin's install dir
    #
    # Returns nothing
    def copy_plugins_files(plugin, files)
      [files].flatten.each do |file|
        copy_file(plugin, file, File.join(Octopress.configuration[:plugins], File.basename(file)))
      end
    end
  end
end
