class Octopress::Commands::Create
  include Octopress::Util

  def initialize(project_path)
    @project_root = File.expand_path project_path
    @project_tmp = File.join @project_root, 'tmp'
    @template_root = Octopress.template_root
  end

  def execute
    FileUtils.mkdir_p @project_root
    FileUtils.cp_r File.join(@template_root, '.'), @project_root
    FileUtils.mkdir File.join(@project_root, '_posts')
    install_plugins
    install_theme
  end

  def install_plugins
    plugins_path = download Octopress.plugins_url, @project_tmp
    plugins = YAML.load_file plugins_path

    plugins_root = File.join(@project_root, '_plugins')
    FileUtils.mkdir_p plugins_root
    plugins.each do |plugin_url|
      install_plugin plugin_url, plugins_root
    end
  end

  def install_plugin(url, destination)
    zip_file_path = download url, @project_tmp
    extracted_root = unzip zip_file_path, @project_tmp
    FileUtils.cp_r Dir.glob(File.join(extracted_root, '*.rb')), destination
  end

  def install_theme
    zip_file_path = download 'https://github.com/octopress/theme-classic/zipball/master', @project_tmp
    extracted_root = unzip zip_file_path, @project_tmp
    FileUtils.cp_r Dir.glob(File.join(extracted_root, '*')), @project_root
  end

end
