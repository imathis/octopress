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
      installer = Installer.new(plugins)
      plugins.each do |plugin|
        installer.install plugin
      end
    end
    INSTALL_DIR           = File.join(Dir.pwd, ".plugins")
    USERNAME_REPO_REGEXP  = /^([a-z0-9\-_]+)\/([a-z0-9\-_]+)$/
    OCTOPRESS_REPO_REGEXP = /^[a-z0-9\-_]+$/
    GIT_REPO_REGEXP       = /^(git:\/\/|https:\/\/|git@)[a-z0-9.]+(\/|:)([a-z0-9\-_]+)\/([a-z0-9\-_]+)\.git/

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

    # Public: builds full installation directory path for plugin
    #
    # plugin - the plugin name
    #
    # Returns the full path of the installation directory
    def install_dir(plugin)
      File.join(INSTALL_DIR, File.basename(plugin).rstrip('.git'))
    end

    # Public: clones the remote repository to the plugin install directory
    #
    # plugin - the plugin name
    #
    # Returns the file path to where the plugin was installed
    def clone(plugin)
      unless File.directory?(install_dir(plugin))
        Open3.popen3("git clone #{git_url(plugin)} #{install_dir(plugin)}") do |stdin, stdout, stderr, wait_thr|
          while (in_line = stdin.readline) || (err_line = stderr.readline)
            STDOUT.puts in_line if in_line
            STDERR.puts err_line if err_line
          end
          exit_status = wait_thr.value
          raise RuntimeError, "Error cloning #{plugin}" unless exit_status.exitstatus == 0
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
      return [plugin]
      unless @plugins.include?(plugin)
        clone(plugin)
        mainfest_yml = manifest(plugin)
        return [plugin] if !mainfest_yml.has_key?("dependencies") || manifest_yml["dependencies"].size == 0
        manifest_yml["dependencies"].each do |dep|
          build_dependencies_tree(dep)
        end
      end
    end

    # Public: copy files from the plugin clone to the user's source directory
    #
    # plugin - the plugin name
    #
    # Returns an Array of file paths which were copied
    def copy_files(plugin)
      manifest_yml = manifest(plugin)
      files = manifest_yml["assets"]
      copy_javascript_files(plugin, files["javascripts"])
      copy_stylesheets_files(plugin, files["stylesheets"])
      copy_plugins_files(plugin, files["plugins"])
    end

    # Public: install a plugin and its dependencies
    #
    # plugin - the plugin name
    #
    # Returns the Array of all plugins installed so far
    def install(plugin)
      @plugins += build_dependencies_tree(plugin)
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
    def copy_file(plugin, file)
      source = File.join(install_dir(plugin), file)
      destination = File.join(Octopress.root, file)
      FileUtils.cp_r source, destination
    end

    # Private: Copy javascript files to local Octopress installation
    #
    # plugin - plugin name
    # files - the filenames of the javascript files for this plugin relative to
    #         the javascripts dir in the plugin's install dir
    #
    # Returns nothing
    def copy_javascript_files(plugin, files)
      files["globals"].each do |file|
        copy_file(plugin, File.join("assets", "javascripts", "lib", file))
      end
      files["modules"].each do |file|
        copy_file(plugin, File.join("assets", "javascripts", file))
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
      files.each do |file|
        copy_file(plugin, File.join("assets", "stylesheets", "custom", file))
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
      files.each do |file|
        copy_file(plugin, File.join(Octopress.configuration[:plugins], file))
      end
    end
  end
end