desc "Install scaffold for a new site"
task :new do
  source = File.join(Octopress.root, 'lib/octopress/scaffold/site')
  destination = Octopress.root
  cp_r "#{source}/.", "#{destination}/"
end

task :install, :plugin do |t, args|
  plugin = args.plugin
  if plugin.nil? || plugin == ""
    plugin = "classic-theme"
  end
  Octopress::DependencyInstaller.install_all(plugin)
end
