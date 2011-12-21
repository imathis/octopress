class Octopress::Commands::Create
  include FileUtils

  def initialize(project_path)
    @project_root = File.expand_path project_path
    @template_root = Octopress.template_root
    puts @template_root
  end

  def execute
    mkdir_p @project_root
    Dir.glob(File.join(@template_root, '*'), File::FNM_DOTMATCH).each do |template_path|
      basename = File.basename template_path
      next if %w(. ..).include?(basename)
      puts "File: #{basename}"
      cp template_path, @project_root
    end
  end
end
