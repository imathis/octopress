$:.unshift File.expand_path("lib", File.dirname(__FILE__)) # For use/testing when no gem is installed

require 'rubygems'
require 'bundler/setup'
require 'stringex'
require 'time'
require 'tzinfo'
require 'yaml'
require 'octopress'
require 'rake/testtask'
require 'colors'

### Configuring Octopress:
###   Under _config/ you will find:
###       site.yml, deploy.yml
###   Here you can override Octopress's default configurations or add your own.
###   This Rakefile uses those config settings to do what it does.
###   Please do not change anything below if you want help --
###   otherwise, you're on your own ;-)

configurator   = Octopress::Configuration.new
configuration  = configurator.read_configuration
full_stash_dir = "#{configuration[:source]}/#{configuration[:stash_dir]}"

desc "Initial setup for Octopress: copies the default theme into the path of Jekyll's generator. Rake install defaults to rake install[classic] to install a different theme run rake install[some_theme_name]"
task :install, :theme do |t, args|
  theme = args.theme || 'classic'
  theme_configuration = configurator.read_theme_configuration(theme)
  if File.directory?(theme_configuration[:source]) || File.directory?(theme_configuration[:theme][:javascripts_dir]) || File.directory?(theme_configuration[:theme][:stylesheets_dir])
    abort("rake aborted!") if ask("A theme is already installed, proceeding will overwrite existing files. Are you sure?", ['y', 'n']) == 'n'
  end
  # copy theme into working Jekyll directories
  puts "## Installing "+theme+" theme"
  Rake::Task["install_template"].invoke(theme)
  Rake::Task["install_stylesheets"].invoke(theme)
  Rake::Task["install_javascripts"].invoke(theme)
  Rake::Task["install_configs"].invoke(theme)
  mkdir_p 'site'
end

task :install_configs, :theme do |t, args|
  theme = args.theme || 'classic'
  mkdir_p "_config"
  if File.directory? ".themes/#{theme}/_config"
    cp_r ".themes/#{theme}/_config/.", "_config/defaults", :remove_destination=>true
    user_config_site = <<-EOF
---
# --------------------------- #
#      User Configuration     #
# --------------------------- #

EOF
    File.open('_config/site.yml', 'w') { |f| f.write user_config_site }

    user_config_deploy = <<-EOF
---
# -------------------------- #
#      Deployment Config     #
# -------------------------- #

deploy_method: rsync
EOF
    File.open('_config/deploy.yml', 'w') { |f| f.write user_config_deploy }
  end
end

desc "Install stylesheets for a theme"
task :install_stylesheets, :theme do |t, args|
  theme = args.theme || 'classic'
  theme_configuration = configurator.read_theme_configuration(theme)
  begin
    stylesheets_dir = File.join(".themes/#{theme}", theme_configuration[:theme][:stylesheets_dir])
  rescue
    "The #{theme} theme must have a configuration file. This theme isn't compatable with Octopress 3.0 installation. You can probably still install it manually.".yellow
  end
  mkdir_p "assets/stylesheets"
  if File.directory? stylesheets_dir
    cp_r "#{stylesheets_dir}/.", "assets/stylesheets"
  end
end

desc "Install javascript assets for a theme"
task :install_javascripts, :theme do |t, args|
  theme = args.theme || 'classic'
  theme_configuration = configurator.read_theme_configuration(theme)
  begin
    javascripts_dir = File.join(".themes/#{theme}", theme_configuration[:theme][:javascripts_dir])
  rescue
    "The #{theme} theme must have a configuration file. This theme isn't compatable with Octopress 3.0 installation. You can probably still install it manually.".yellow
  end
  mkdir_p "assets/javascripts"
  if File.directory? javascripts_dir
    cp_r "#{javascripts_dir}/.", "assets/javascripts"
  end
end

task :install_template, :theme do |t, args|
  theme = args.theme || 'classic'
  mkdir_p "source/_posts"
  cp_r ".themes/#{theme}/source/.", 'source'
end

#######################
# Working with Jekyll #
#######################

desc "Generate jekyll site"
task :generate do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." if configuration[:source].nil? || !File.directory?(configuration[:source])
  configurator.write_configs_for_generation
  puts "## Generating Site with Jekyll"
  system "compass compile --css-dir #{configuration[:source]}/stylesheets"
  system "jekyll --no-server --no-auto #{'--no-future' if Octopress.env == 'production'}"
  unpublished = get_unpublished(Dir.glob("#{configuration[:source]}/#{configuration[:posts_dir]}/*.*"), {env: Octopress.env, message: "\nThese posts were not generated:"})
  puts unpublished unless unpublished.empty?
  configurator.remove_configs_for_generation
end

# usage rake generate_only[my-post]
desc "Generate only the specified post (much faster)"
task :generate_only, :filename do |t, args|
  if args.filename
    filename = args.filename
  else
    filename = get_stdin("Enter a post file name: ")
  end
  puts "## Stashing other posts"
  Rake::Task["isolate"].invoke(filename)
  Rake::Task["generate"].execute
  puts "## Restoring stashed posts"
  Rake::Task["integrate"].execute
end

# - Check to see if site has been installed first rescue properly
desc "Watch the site and regenerate when it changes"
task :watch do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." if configuration[:source].nil? || !File.directory?(configuration[:source])
  puts "Starting to watch source with Jekyll and Compass."
  guardPid = Process.spawn("guard")
  trap("INT") {
    Process.kill(9, guardPid) rescue Errno::ESRCH
    exit 0
  }
  Process.wait guardPid
end

desc "preview the site in a web browser."
task :preview do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." if configuration[:source].nil? || !File.directory?(configuration[:source])
  guardPid = Process.spawn("guard")
  puts "Starting Rack, serving to http://#{configuration[:server_host]}:#{configuration[:server_port]}"
  rackupPid = Process.spawn("rackup --host #{configuration[:server_host]} --port #{configuration[:server_port]}")

  trap("INT") {
    [guardPid, rackupPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [guardPid, rackupPid].each { |pid| Process.wait(pid) }
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{configuration[:source]}/#{configuration[:posts_dir]}"
task :new_post, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(configuration[:source])
  time = now_in_timezone(configuration[:timezone])
  mkdir_p "#{configuration[:source]}/#{configuration[:posts_dir]}"
  filename = "#{configuration[:source]}/#{configuration[:posts_dir]}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{configuration[:new_post_ext]}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{time.iso8601}"
    post.puts "comments: true"
    post.puts "external-url: "
    post.puts "categories: "
    post.puts "---"
  end
end

# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page.markdown")
desc "Create a new page in #{configuration[:source]}/(filename)/index.#{configuration[:new_page_ext]}"
task :new_page, :filename do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(configuration[:source])
  args.with_defaults(:filename => 'new-page')
  page_dir = [configuration[:source]]
  if args.filename.downcase =~ /(^.+\/)?(.+)/
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    title = filename
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    if extension.nil?
      page_dir << filename
      filename = "index"
    end
    extension ||= configuration[:new_page_ext]
    page_dir = page_dir.map! { |d| d = d.to_url }.join('/')                # Sanitize path
    filename = filename.downcase.to_url

    mkdir_p page_dir
    file = "#{page_dir}/#{filename}.#{extension}"
    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "Creating new page: #{file}"
    time = now_in_timezone(configuration[:timezone])
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "layout: page"
      page.puts "title: \"#{title}\""
      page.puts "date: #{time.iso8601}"
      page.puts "comments: true"
      page.puts "sharing: true"
      page.puts "footer: true"
      page.puts "---"
    end
  else
    puts "Syntax error: #{args.filename} contains unsupported characters"
  end
end

# usage rake isolate[my-post]
desc "Move all other posts than the one currently being worked on to a temporary stash location (stash) so regenerating the site happens much more quickly."
task :isolate, :filename do |t, args|
  if args.filename
    filename = args.filename
  else
    filename = get_stdin("Enter a post file name: ")
  end
  FileUtils.mkdir(full_stash_dir) unless File.exist?(full_stash_dir)
  Dir.glob("#{configuration[:source]}/#{configuration[:posts_dir]}/*.*") do |post|
    FileUtils.mv post, full_stash_dir unless post.include?(filename)
  end
end

desc "Move all stashed posts back into the posts directory, ready for site generation."
task :integrate do
  FileUtils.mv Dir.glob("#{full_stash_dir}/*.*"), "#{configuration[:source]}/#{configuration[:posts_dir]}/"
end

desc "Clean out caches: .pygments-cache, .gist-cache, .sass-cache, and Compass-generated files."
task :clean do
  rm_rf [".pygments-cache", ".gist-cache"]
  system "compass clean"
  puts "## Cleaned Compass-generated files, and various caches ##"
end

desc "Update theme source and style"
task :update, :theme do |t, args|
  theme = args.theme || 'classic'
  Rake::Task[:update_template].invoke(theme)
  Rake::Task[:update_stylesheets].invoke(theme)
  Rake::Task[:update_javascripts].invoke(theme)
end

desc "Move stylesheets to stylesheets.old, install stylesheets theme updates, replace stylesheets/custom with stylesheets.old/custom"
task :update_stylesheets, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{configuration[:assets]}.old/stylesheets")
    rm_r "#{configuration[:assets]}.old/stylesheets", :secure=>true
    puts "Removed existing assets.old/stylesheets directory"
  end
  mkdir "#{configuration[:assets]}.old" 
  mv "#{configuration[:assets]}/stylesheets", "#{configuration[:assets]}.old/stylesheets"
  puts "Moved styles into #{configuration[:assets]}.old/stylesheets"
  install_stylesheets(theme)
  cp_r "#{configuration[:assets]}.old/stylesheets/custom", "#{configuration[:assets]}/stylesheets/custom"
  puts "## Updated Stylesheets ##"
  rm_r ".sass-cache", :secure=>true if File.directory?(".sass-cache")
end

desc "Move javascripts to #{configuration[:assets]}.old/javascripts, install javascripts theme updates."
task :update_javascripts, :theme do |t, args|
  if File.directory?(".themes/#{theme}/javascripts")
    theme = args.theme || 'classic'
    if File.directory?("#{configuration[:assets]}.old/javascripts")
      rm_r "#{configuration[:assets]}.old/javascripts", :secure=>true
      puts "Removed existing assets.old/javascripts directory"
    end
    mkdir "#{configuration[:assets]}.old" 
    cp_r "#{configuration[:assets]}/javascripts/.", "#{configuration[:assets]}.old/javascripts"
    puts "Copied styles into #{configuration[:assets]}.old/javascripts"
    install_javascripts(theme)
    puts "## Updated Javascripts ##"
  end
end

desc "Move source to source.old, install source theme updates, replace source/_includes/navigation.html with source.old's navigation"
task :update_template, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{configuration[:source]}.old")
    puts "Removed existing #{configuration[:source]}.old directory"
    rm_r "#{configuration[:source]}.old", :secure=>true
  end
  mkdir "#{configuration[:source]}.old"
  cp_r "#{configuration[:source]}/.", "#{configuration[:source]}.old"
  puts "## Copied #{configuration[:source]} into #{configuration[:source]}.old/"
  cp_r ".themes/"+theme+"/source/.", configuration[:source], :remove_destination=>true
  cp_r "#{configuration[:source]}.old/_includes/custom/.", "#{configuration[:source]}/_includes/custom/", :remove_destination=>true
  mv "#{configuration[:source]}/index.html", "#{configuration[:blog_index_dir]}", :force=>true if configuration[:blog_index_dir] != configuration[:source]
  cp "#{configuration[:source]}.old/index.html", configuration[:source] if configuration[:blog_index_dir] != configuration[:source] && File.exists?("#{configuration[:source]}.old/index.html")
  if File.exists?("#{configuration[:source]}/blog/archives/index.html")
    puts "## Moving blog/archives to /archives (standard location as of 2.1) ##"
    file = "#{configuration[:source]}/_includes/custom/navigation.html"
    navigation = IO.read(file)
    navigation = navigation.gsub(/(.*)\/blog(\/archives)(.*$)/m, '\1\2\3')
    File.open(file, 'w') do |f|
      f.write navigation
    end
    rm_r "#{configuration[:source]}/blog/archives"
    rm_r "#{configuration[:source]}/blog" if Dir.entries("#{configuration[:source]}/blog").join == "..."
  end
  puts "## Updated #{configuration[:source]} ##"
end

##############
# Deploying  #
##############

desc "Default deploy task"
task :deploy do
  Rake::Task["#{configuration[:deploy_default]}"].execute
end

desc "Generate website and deploy"
task :gen_deploy => [:integrate, :generate, :deploy] do
end

desc "Deploy website via rsync"
task :rsync do
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avze 'ssh -p #{configuration[:ssh_port]} #{'-i' + configuration[:ssh_key] unless configuration[:ssh_key].empty?}' #{exclude} #{configuration[:rsync_args]} #{"--delete" unless configuration[:rsync_delete] == false} #{configuration[:destination]}/ #{configuration[:ssh_user]}:#{configuration[:document_root]}")
end

desc "deploy public directory to github pages"
multitask :push do
  if File.directory?(configuration[:deploy_dir])
    puts "## Deploying branch to GitHub Pages "
    (Dir["#{configuration[:deploy_dir]}/*"]).each { |f| rm_rf(f) }
    puts "Attempting pull, to sync local deployment repository"
    cd "#{configuration[:deploy_dir]}" do
      system "git pull origin #{configuration[:deploy_branch]}"
    end
    puts "\n## copying #{configuration[:destination]} to #{configuration[:deploy_dir]}"
    cp_r "#{configuration[:destination]}/.", configuration[:deploy_dir]
    cd "#{configuration[:deploy_dir]}" do
      File.new(".nojekyll", "w").close
      system "git add ."
      system "git add -u"
      message = "Site updated at #{Time.now.utc}"
      puts "\n## Commiting: #{message}"
      system "git commit -m \"#{message}\""
      puts "\n## Pushing generated #{configuration[:deploy_dir]} website"
      if system "git push origin #{configuration[:deploy_branch]}"
        puts "\n## GitHub Pages deploy complete"
      else
        remote = `git remote -v`
        repo_url = case remote
                   when /(http[^\s]+)/
                     $1
                   when /(git@[^\s]+)/
                     $1
                   else
                     ""
                   end
        raise "\n## Octopress could not push to #{repo_url}"
      end
    end
  else
    puts "This project isn't configured for deploying to GitHub Pages\nPlease run `rake setup_github_pages[your-deployment-repo-url]`."
  end
end

desc "Update configurations to support publishing to root or sub directory"
task :set_root_dir, :dir do |t, args|
  if args.dir
    dir = args.dir
  else
    dir = get_stdin("Please provide a directory: ")
  end
  if dir
    if dir == "/"
      dir = ""
    else
      dir = "/" + args.dir.sub(/(\/*)(.+)/, "\\2").sub(/\/$/, '');
    end
    # update personal configuration
    site_configs = configurator.read_configuration('site.yml')
    site_configs[:destination] = "public#{dir}"
    site_configs[:subscribe_rss] = "#{dir}/atom.xml"
    site_configs[:root] = "/#{dir.sub(/^\//, '')}"
    configurator.write_config('site.yml', site_configs)

    rm_rf configuration[:destination]
    mkdir_p site_configs[:destination]
    puts "\n========================================================"
    puts "Site's root directory is now '/#{dir.sub(/^\//, '')}'"
    puts "Don't forget to update your url in _config.yml"
    puts "\n========================================================"
  end
end

desc "Set up _deploy folder and deploy branch for GitHub Pages deployment"
task :setup_github_pages, :repo do |t, args|
  if args.repo
    repo_url = args.repo
  else
    puts "Enter the read/write url for your repository"
    puts "(For example, 'git@github.com:your_username/your_username.github.com)"
    repo_url = get_stdin("Repository url: ")
  end
  unless repo_url[-4..-1] == ".git"
    repo_url << ".git"
  end
  raise "!! The repo URL that was input was malformed." unless (repo_url =~ /https:\/\/github\.com\/[^\/]+\/[^\/]+/).nil? or (repo_url =~ /git@github\.com:[^\/]+\/[^\/]+/).nil?
  user_match = repo_url.match(/(:([^\/]+)|(github\.com\/([^\/]+)))/)
  user = user_match[2] || user_match[4]
  branch = (repo_url =~ /\/[\w-]+\.github\.com/).nil? ? 'gh-pages' : 'master'
  project = (branch == 'gh-pages') ? repo_url.match(/\/(.+)(\.git)/)[1] : ''
  url = "http://#{user}.github.com"
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
      unless !configuration[:destination].match("#{project}").nil?
        Rake::Task[:set_root_dir].invoke(project)
      end
    end
  end

  # Configure deployment repository
  rm_rf configuration[:deploy_dir]
  mkdir configuration[:deploy_dir]
  cd "#{configuration[:deploy_dir]}" do
    system "git init"
    system "git remote add origin #{repo_url}"
    puts   "Attempting to pull from repository"
    system "git pull origin #{branch}"
    unless File.exist?('index.html')
      system "echo 'My Octopress Page is coming soon &hellip;' > index.html"
      system "git add ."
      system "git commit -m \"Octopress init\""
      system "git branch -m gh-pages" unless branch == 'master'
    end
  end

  # Configure deployment setup in deploy.yml
  deploy_configuration = configurator.read_config('deploy.yml')
  deploy_configuration[:deploy_default] = "push"
  deploy_configuration[:deploy_branch]  = branch
  deploy_configuration = configurator.read_config('defaults/deploy/gh_pages.yml').deep_merge(deploy_configuration)
  puts deploy_configuration
  configurator.write_config('deploy.yml', deploy_configuration)

  # Configure published url
  site_configuration = configurator.read_config('site.yml')
  site_configuration[:url] = url if site_configuration.has_key?(:url) && site_configuration[:url] == 'http://yoursite.com'
  site_configuration = configurator.read_config('defaults/jekyll.yml').deep_merge(site_configuration)

  puts "\n========================================================"
  has_cname = File.exists?("#{configuration[:source]}/CNAME")
  if has_cname
    cname = IO.read("#{configuration[:source]}/CNAME").chomp
    current_short_url = /\/{2}(.*$)/.match(current_url)[1]
    if cname != current_short_url
      puts "!! WARNING: Your CNAME points to #{cname} but your _config.yml url is set to #{current_short_url} !!"
      puts "For help with setting up a CNAME follow the guide at http://help.github.com/pages/#custom_domains"
    else
      puts "GitHub Pages will host your site at http://#{cname}"
    end
  else
    puts "GitHub Pages will host your site at #{url}."
    puts "To host at \"your-site.com\", configure a CNAME: `echo \"your-domain.com\" > #{configuration[:source]}/CNAME`"
    puts "Then change the url in _config.yml from #{current_url} to http://your-domain.com"
    puts "Finally, follow the guide at http://help.github.com/pages/#custom_domains for help pointing your domain to GitHub Pages"
  end
  puts "Deploy to #{repo_url} with `rake deploy`"
  puts "Note: generated content is copied into _deploy/ which is not in version control."
  puts "If starting with a fresh clone of this project you should re-run setup_github_pages."
  puts "========================================================"
end

# usage rake list_posts or rake list_posts[pub|unpub]
desc "List all unpublished/draft posts"
task :list_drafts do
  posts = Dir.glob("#{configuration[:source]}/#{configuration[:posts_dir]}/*.*")
  unpublished = get_unpublished(posts)
  puts unpublished.empty? ? "There are no posts currently in draft" : unpublished
end

#
# Run tests for Octopress module, found in lib/.
#
Rake::TestTask.new do |t|
  t.pattern = "lib/spec/**/*_spec.rb"
end

def get_unpublished(posts, options={})
  result = ""
  message = options[:message] || "These Posts will not be published:"
  posts.sort.each do |post|
    file = File.read(post)
    data = YAML.load file.match(/(^-{3}\n)(.+?)(\n-{3})/m)[2]
    
    if options[:env] == 'production'
      future = Time.now < Time.parse(data['date'].to_s) ? "future date: #{data['date']}" : false
    end
    draft = data['published'] == false ? 'published: false' : false
    result << "- #{data['title']} (#{draft or future})\n" if draft or future
  end
  result = "#{message}\n" + result unless result.empty?
  result
end

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

def ask(message, valid_options)
  if valid_options
    answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
  else
    answer = get_stdin(message)
  end
  answer
end

def now_in_timezone(timezone)
  time = Time.now
  unless timezone.nil? || timezone.empty? || timezone == 'local'
    tz = TZInfo::Timezone.get(timezone) #setup Timezone object
    adjusted_time = tz.utc_to_local(time.utc) #time object without correct offset
    #time object with correct offset
    time = Time.new(
      adjusted_time.year,
      adjusted_time.month,
      adjusted_time.day,
      adjusted_time.hour,
      adjusted_time.min,
      adjusted_time.sec,
      tz.period_for_utc(time.utc).utc_total_offset())
    #convert offset to utc instead of just ±0 if that was specified
    if ['utc','zulu','universal','uct','gmt','gmt0','gmt+0','gmt-0'].include? timezone.downcase
      time = time.utc
    end
  end
  time
end

desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
