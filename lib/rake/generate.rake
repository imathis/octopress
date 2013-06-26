desc "Generate Jekyll site"
task :generate do
  Octopress::Commands::Build.process(nil, nil)
end
