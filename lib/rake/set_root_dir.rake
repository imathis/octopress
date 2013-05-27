desc "Update configurations to support publishing to root or sub directory"
task :set_root_dir, :dir do |t, args|
  path = args.dir || nil
  if path.nil?
    path = get_stdin("Please provide a directory: ")
  end
  if path
    if path == "/"
      path = ""
    else
      path = "/" + path.sub(/(\/*)(.+)/, "\\2").sub(/\/$/, '');
    end
    # update personal configuration
    site_configs = Octopress.configurator.read_config('site.yml')
    site_configs[:destination] = "public#{path}"
    root = "/#{path.sub(/^\//, '')}"
    url = $1 if site_configs[:url] =~ /(https?:\/\/[^\/]+)/i
    site_configs[:url] = url + path
    site_configs[:subscribe_rss] = "#{path}/atom.xml"
    site_configs[:root] = "#{root}"
    Octopress.configurator.write_config('site.yml', site_configs)

    rm_rf Octopress.configuration[:destination]
    mkdir_p site_configs[:destination]
    puts "\nYour _config/site.yml has been updated to the following"
    output = <<-EOF

  url: #{url + path}
  destination: public#{path}
  subscribe_rss: #{path}/atom.xml
  root: #{root}
EOF
    puts output.yellow
  end
end
