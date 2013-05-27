desc "Set up _deploy folder and deploy branch for GitHub Pages deployment"
task :setup_github_pages, :repo do |t, args|
  puts Octopress.configuration
  if args.repo
    repo_url = args.repo
  else
    puts "Enter the read/write url for your repository"
    puts "(For example, 'git@github.com:your_username/your_username.github.io)"
    repo_url = get_stdin("Repository url: ")
  end
  unless repo_url[-4..-1] == ".git"
    repo_url << ".git"
  end
  raise "!! The repo URL that was input was malformed." unless (repo_url =~ /https:\/\/github\.(?:io|com)\/[^\/]+\/[^\/]+/).nil? or (repo_url =~ /git@github\.(?:io|com):[^\/]+\/[^\/]+/).nil?
  user_match = repo_url.match(/(:([^\/]+)|(github\.(?:io|com)\/([^\/]+)))/)
  user = user_match[2] || user_match[4]
  branch = (repo_url =~ /\/[\w-]+\.github\.(?:io|com)/).nil? ? 'gh-pages' : 'master'
  project = (branch == 'gh-pages') ? repo_url.match(/\/(.+)(\.git)/)[1] : ''
  url = "http://#{user}.github.io"
  url += "/#{project}" unless project == ''
  unless (`git remote -v` =~ /origin.+?octopress(?:\.git)?/).nil?
    # If octopress is still the origin remote (from cloning) rename it to octopress
    system "git remote rename origin octopress"
    if branch == 'master'
      # If this is a user/organization pages repository, add the correct origin remote
      # and checkout the source branch for committing changes to the website's source.
      system "git remote add origin #{repo_url}"
      puts "Added remote #{repo_url} as origin"
      system "git config branch.master.remote origin"
      puts "Set origin as default remote"
      system "git branch -m master source"
      puts "Master branch renamed to 'source' for committing your website's source files"
    else
      unless !Octopress.configuration[:destination].match("#{project}").nil?
        Rake::Task[:set_root_dir].invoke(project)
      end
    end
  end

  # Configure deployment repository
  rm_rf Octopress.configuration[:deploy_dir], :verbose=>false
  cmd = "git clone #{repo_url} --branch #{branch} #{Octopress.configuration[:deploy_dir]}"
  Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
    exit_status = wait_thr.value
    unless exit_status.success?
      error = ''
      while line = stdout_err.gets do error << line end
      puts "Be sure your repo (#{repo_url}) is set up properly and try again".red
      abort error
    end
  end
  cd "#{Octopress.configuration[:deploy_dir]}", :verbose=>false do
    unless File.exist?('index.html')
      `echo 'My Octopress Page is coming soon &hellip;' > index.html`
      `git add . && git commit -m 'Octopress init'`
      `git branch -m gh-pages` unless branch == 'master'
    end
  end

  # Configure deployment setup in deploy.yml
  deploy_configuration = Octopress.configurator.read_config('deploy.yml')
  config_message = ""

  unless deploy_configuration[:deploy_default] == "push"
    deploy_configuration[:deploy_default] = "push"
    config_message << "\n  deploy_default: push"
  end

  unless deploy_configuration[:deploy_branch] == branch
    deploy_configuration[:deploy_branch] = branch
    config_message << "\n  deploy_branch: #{branch}"
  end

  # Mention updated configs if any
  unless config_message.empty?
    deploy_configuration = Octopress.configurator.read_config('defaults/deploy/gh_pages.yml').deep_merge(deploy_configuration)
    Octopress.configurator.write_config('deploy.yml', deploy_configuration)
    puts "\nYour deployment configuration (_config/deploy.yml) has been updated to:"
    puts config_msg.yellow
  end

  # Configure published url
  site_configuration = Octopress.configurator.read_config('site.yml')
  if !site_configuration.has_key?(:url) or site_configuration[:url] == 'http://yoursite.com'
    site_configuration[:url] = url
    Octopress.configurator.write_config('site.yml', site_configuration)
    puts "\nYour site configuration (_config/site.yml) has been updated to:"
    puts "\n  url: #{url}".yellow
  end
  jekyll_configuration = Octopress.configurator.read_config('defaults/jekyll.yml').deep_merge(site_configuration)

  cname_path = "#{jekyll_configuration[:source]}/CNAME"
  has_cname = File.exists?(cname_path)
  output = ""
  if has_cname
    cname = IO.read(cname_path).chomp
    current_url = site_configuration[:url]
    if cname != current_short_url
      output << "\nYour CNAME points to #{cname} but your _config/site.yml is setting the url to #{current_short_url}".red
      output << "\nIf you need help, get it here: https://help.github.com/articles/setting-up-a-custom-domain-with-pages"
    else
      url = cname
    end
  else
    output << "\nTo use a custom domain:".bold
    output << "\n  Follow this guide: https://help.github.com/articles/setting-up-a-custom-domain-with-pages"
    output << "\n  Then remember to update the url in _config/site.yml from #{url} to http://your-domain.com"
  end

  puts "Configured successfully:".green.bold
  puts "  Github Pages will host your site at #{url}.".green
  puts "\nTo deploy:".bold
  puts "  Run `rake deploy` which will copy your site to _deploy/, commit then push to #{repo_url}"
  puts output
end
