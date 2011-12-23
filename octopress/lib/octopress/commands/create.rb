class Octopress::Commands::Create
  include FileUtils

  def initialize(project_path)
    @project_root = File.expand_path project_path
    @template_root = Octopress.template_root
  end

  def execute
    mkdir_p @project_root
    cp_r File.join(@template_root, '.'), @project_root
  end
end
