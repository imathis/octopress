desc "Generate Jekyll site"
task :generate do
  if Octopress.configuration[:source].nil? || !File.directory?(Octopress.configuration[:source])
    raise "### You haven't set anything up yet. First run `rake install[theme]` to set up an Octopress theme."
  end
  Octopress.configurator.write_configs_for_generation
  puts "## Generating Site with Jekyll - ENV: #{Octopress.env}"
  if Dir.exists? "javascripts"
    js_assets = Octopress::JSAssetsManager.new
    puts js_assets.compile
  end
  if Dir.exists? "stylesheets"
    system "compass compile --css-dir #{Octopress.configuration[:source]}/stylesheets" if Dir.exists? "stylesheets"
  end
  system "jekyll build #{"--drafts --trace" unless Octopress.env == 'production'}"
  unpublished = get_unpublished(Dir.glob("#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}/*.*"), {env: Octopress.env, message: "\nThese posts were not generated:"})
  puts unpublished unless unpublished.empty?
  Octopress.configurator.remove_configs_for_generation
end
