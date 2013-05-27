desc "Initial setup for Octopress: copies the default theme into the path of Jekyll's generator. Rake install defaults to rake install[classic] to install a different theme run rake install[some_theme_name]"
task :install, :plugin do |t, args|
  plugin = args.plugin
  if plugin.nil? || plugin == ""
    plugin = "classic-theme"
  end
  Octopress::DependencyInstaller.install_all(plugin)
end
