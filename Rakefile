require "rubygems"
require "bundler/setup"
require "stringex"
require "./tasks/task_config"

Dir.glob('tasks/*.rake').each { |r| import r }

desc "Initial setup for Octopress: copies the default theme into the path of Jekyll's generator. Rake install defaults to rake install[classic] to install a different theme run rake install[some_theme_name]"
task :install, :theme do |t, args|
  if File.directory?(TaskConfig::SOURCE_DIR) || File.directory?("sass")
    abort("rake aborted!") if ask("A theme is already installed, proceeding will overwrite existing files. Are you sure?", ['y', 'n']) == 'n'
  end
  # copy theme into working Jekyll directories
  theme = args.theme || 'classic'
  puts "## Copying "+theme+" theme into ./#{TaskConfig::SOURCE_DIR} and ./sass"
  mkdir_p TaskConfig::SOURCE_DIR
  cp_r "#{TaskConfig::THEMES_DIR}/#{theme}/source/.", TaskConfig::SOURCE_DIR
  mkdir_p "sass"
  cp_r "#{TaskConfig::THEMES_DIR}/#{theme}/sass/.", "sass"
  mkdir_p "#{TaskConfig::SOURCE_DIR}/#{TaskConfig::POSTS_DIR}"
  mkdir_p TaskConfig::PUBLIC_DIR
end

#######################
# Working with Jekyll #
#######################

desc "Generate jekyll site"
task :generate do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(TaskConfig::SOURCE_DIR)
  puts "## Generating Site with Jekyll"
  system "compass compile --css-dir #{TaskConfig::SOURCE_DIR}/stylesheets"
  system "jekyll"
end

desc "Watch the site and regenerate when it changes"
task :watch do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(TaskConfig::SOURCE_DIR)
  puts "Starting to watch source with Jekyll and Compass."
  system "compass compile --css-dir #{TaskConfig::SOURCE_DIR}/stylesheets" unless File.exist?("#{TaskConfig::SOURCE_DIR}/stylesheets/screen.css")
  jekyllPid = Process.spawn({"OCTOPRESS_ENV"=>"preview"}, "jekyll --auto")
  compassPid = Process.spawn("compass watch")

  trap("INT") {
    [jekyllPid, compassPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid].each { |pid| Process.wait(pid) }
end

desc "preview the site in a web browser"
task :preview do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(TaskConfig::SOURCE_DIR)
  puts "Starting to watch source with Jekyll and Compass. Starting Rack on port #{TaskConfig::SERVER_PORT}"
  system "compass compile --css-dir #{TaskConfig::SOURCE_DIR}/stylesheets" unless File.exist?("#{TaskConfig::SOURCE_DIR}/stylesheets/screen.css")
  jekyllPid = Process.spawn({"OCTOPRESS_ENV"=>"preview"}, "jekyll --auto")
  compassPid = Process.spawn("compass watch")
  rackupPid = Process.spawn("rackup --port #{TaskConfig::SERVER_PORT}")

  trap("INT") {
    [jekyllPid, compassPid, rackupPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid, rackupPid].each { |pid| Process.wait(pid) }
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{TaskConfig::SOURCE_DIR}/#{TaskConfig::POSTS_DIR}"
task :new_post, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(TaskConfig::SOURCE_DIR)
  mkdir_p "#{TaskConfig::SOURCE_DIR}/#{TaskConfig::POSTS_DIR}"
  filename = "#{TaskConfig::SOURCE_DIR}/#{TaskConfig::POSTS_DIR}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{TaskConfig::NEW_POST_EXT}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "comments: true"
    post.puts "categories: "
    post.puts "---"
  end
end

# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page.markdown")
desc "Create a new page in #{TaskConfig::SOURCE_DIR}/(filename)/index.#{TaskConfig::NEW_PAGE_EXT}"
task :new_page, :filename do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(TaskConfig::SOURCE_DIR)
  args.with_defaults(:filename => 'new-page')
  page_dir = [TaskConfig::SOURCE_DIR]
  if args.filename.downcase =~ /(^.+\/)?(.+)/
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    title = filename
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    if extension.nil?
      page_dir << filename
      filename = "index"
    end
    extension ||= TaskConfig::NEW_PAGE_EXT
    page_dir = page_dir.map! { |d| d = d.to_url }.join('/')                # Sanitize path
    filename = filename.downcase.to_url

    mkdir_p page_dir
    file = "#{page_dir}/#{filename}.#{extension}"
    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "Creating new page: #{file}"
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "layout: page"
      page.puts "title: \"#{title}\""
      page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
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
  TaskConfig::STASH_DIR = "#{TaskConfig::SOURCE_DIR}/#{TaskConfig::STASH_DIR}"
  FileUtils.mkdir(TaskConfig::STASH_DIR) unless File.exist?(TaskConfig::STASH_DIR)
  Dir.glob("#{TaskConfig::SOURCE_DIR}/#{TaskConfig::POSTS_DIR}/*.*") do |post|
    FileUtils.mv post, TaskConfig::STASH_DIR unless post.include?(args.filename)
  end
end

desc "Move all stashed posts back into the posts directory, ready for site generation."
task :integrate do
  FileUtils.mv Dir.glob("#{TaskConfig::SOURCE_DIR}/#{TaskConfig::STASH_DIR}/*.*"), "#{TaskConfig::SOURCE_DIR}/#{TaskConfig::POSTS_DIR}/"
end

desc "Clean out caches: .pygments-cache, .gist-cache, .sass-cache"
task :clean do
  rm_rf [".pygments-cache/**", ".gist-cache/**", ".sass-cache/**", "source/stylesheets/screen.css"]
end

desc "Move sass to sass.old, install sass theme updates, replace sass/custom with sass.old/custom"
task :update_style, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("sass.old")
    puts "removed existing sass.old directory"
    rm_r "sass.old", :secure=>true
  end
  mv "sass", "sass.old"
  puts "## Moved styles into sass.old/"
  cp_r "#{TaskConfig::THEMES_DIR}/"+theme+"/sass/", "sass"
  cp_r "sass.old/custom/.", "sass/custom"
  puts "## Updated Sass ##"
end

desc "Move source to source.old, install source theme updates, replace source/_includes/navigation.html with source.old's navigation"
task :update_source, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{TaskConfig::SOURCE_DIR}.old")
    puts "## Removed existing #{TaskConfig::SOURCE_DIR}.old directory"
    rm_r "#{TaskConfig::SOURCE_DIR}.old", :secure=>true
  end
  mkdir "#{TaskConfig::SOURCE_DIR}.old"
  cp_r "#{TaskConfig::SOURCE_DIR}/.", "#{TaskConfig::SOURCE_DIR}.old"
  puts "## Copied #{TaskConfig::SOURCE_DIR} into #{TaskConfig::SOURCE_DIR}.old/"
  cp_r "#{TaskConfig::THEMES_DIR}/"+theme+"/source/.", TaskConfig::SOURCE_DIR, :remove_destination=>true
  cp_r "#{TaskConfig::SOURCE_DIR}.old/_includes/custom/.", "#{TaskConfig::SOURCE_DIR}/_includes/custom/", :remove_destination=>true
  cp "#{TaskConfig::SOURCE_DIR}.old/favicon.png", TaskConfig::SOURCE_DIR
  mv "#{TaskConfig::SOURCE_DIR}/index.html", "#{blog_index_dir}", :force=>true if blog_index_dir != TaskConfig::SOURCE_DIR
  cp "#{TaskConfig::SOURCE_DIR}.old/index.html", TaskConfig::SOURCE_DIR if blog_index_dir != TaskConfig::SOURCE_DIR && File.exists?("#{TaskConfig::SOURCE_DIR}.old/index.html")
  puts "## Updated #{TaskConfig::SOURCE_DIR} ##"
end

##############
# Deploying  #
##############

desc "Default deploy task"
task :deploy do
  # Check if preview posts exist, which should not be published
  if File.exists?(".preview-mode")
    puts "## Found posts in preview mode, regenerating files ..."
    File.delete(".preview-mode")
    Rake::Task[:generate].execute
  end

  Rake::Task[:copydot].invoke(TaskConfig::SOURCE_DIR, TaskConfig::PUBLIC_DIR)
  Rake::Task["#{TaskConfig::DEPLOY_DEFAULT}"].execute
end

desc "Generate website and deploy"
task :gen_deploy => [:integrate, :generate, :deploy] do
end

desc "copy dot files for deployment"
task :copydot, :source, :dest do |t, args|
  FileList["#{args.source}/**/.*"].exclude("**/.", "**/..", "**/.DS_Store", "**/._*").each do |file|
    cp_r file, file.gsub(/#{args.source}/, "#{args.dest}") unless File.directory?(file)
  end
end

desc "Deploy website via rsync"
task :rsync do
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avze 'ssh -p #{TaskConfig::SSH_PORT}' #{exclude} #{TaskConfig::RSYNC_ARGS} #{"--delete" unless TaskConfig::RSYNC_DELETE == false} #{TaskConfig::PUBLIC_DIR}/ #{TaskConfig::SSH_USER}:#{TaskConfig::DOCUMENT_ROOT}")
end

desc "deploy public directory to github pages"
multitask :push do
  puts "## Deploying branch to Github Pages "
  (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
  Rake::Task[:copydot].invoke(TaskConfig::PUBLIC_DIR, deploy_dir)
  puts "\n## copying #{TaskConfig::PUBLIC_DIR} to #{deploy_dir}"
  cp_r "#{TaskConfig::PUBLIC_DIR}/.", deploy_dir
  cd "#{deploy_dir}" do
    system "git add ."
    system "git add -u"
    puts "\n## Commiting: Site updated at #{Time.now.utc}"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{TaskConfig::DEPLOY_BRANCH} --force"
    puts "\n## Github Pages deploy complete"
  end
end

desc "Update configurations to support publishing to root or sub directory"
task :set_root_dir, :dir do |t, args|
  puts ">>> !! Please provide a directory, eg. rake config_dir[publishing/subdirectory]" unless args.dir
  if args.dir
    if args.dir == "/"
      dir = ""
    else
      dir = "/" + args.dir.sub(/(\/*)(.+)/, "\\2").sub(/\/$/, '');
    end
    rakefile = IO.read(__FILE__)
    rakefile.sub!(/TaskConfig::PUBLIC_DIR(\s*)=(\s*)(["'])[\w\-\/]*["']/, "TaskConfig::PUBLIC_DIR\\1=\\2\\3public#{dir}\\3")
    File.open(__FILE__, 'w') do |f|
      f.write rakefile
    end
    compass_config = IO.read('config.rb')
    compass_config.sub!(/http_path(\s*)=(\s*)(["'])[\w\-\/]*["']/, "http_path\\1=\\2\\3#{dir}/\\3")
    compass_config.sub!(/http_images_path(\s*)=(\s*)(["'])[\w\-\/]*["']/, "http_images_path\\1=\\2\\3#{dir}/images\\3")
    compass_config.sub!(/http_fonts_path(\s*)=(\s*)(["'])[\w\-\/]*["']/, "http_fonts_path\\1=\\2\\3#{dir}/fonts\\3")
    compass_config.sub!(/css_dir(\s*)=(\s*)(["'])[\w\-\/]*["']/, "css_dir\\1=\\2\\3public#{dir}/stylesheets\\3")
    File.open('config.rb', 'w') do |f|
      f.write compass_config
    end
    jekyll_config = IO.read('_config.yml')
    jekyll_config.sub!(/^destination:.+$/, "destination: public#{dir}")
    jekyll_config.sub!(/^subscribe_rss:\s*\/.+$/, "subscribe_rss: #{dir}/atom.xml")
    jekyll_config.sub!(/^root:.*$/, "root: /#{dir.sub(/^\//, '')}")
    File.open('_config.yml', 'w') do |f|
      f.write jekyll_config
    end
    rm_rf TaskConfig::PUBLIC_DIR
    mkdir_p "#{TaskConfig::PUBLIC_DIR}#{dir}"
    puts "## Site's root directory is now '/#{dir.sub(/^\//, '')}' ##"
  end
end

desc "Set up _deploy folder and deploy branch for Github Pages deployment"
task :setup_github_pages, :repo do |t, args|
  if args.repo
    repo_url = args.repo
  else
    puts "Enter the read/write url for your repository"
    puts "(For example, 'git@github.com:your_username/your_username.github.com)"
    repo_url = get_stdin("Repository url: ")
  end
  user = repo_url.match(/:([^\/]+)/)[1]
  branch = (repo_url.match(/\/[\w-]+\.github\.com/).nil?) ? 'gh-pages' : 'master'
  project = (branch == 'gh-pages') ? repo_url.match(/\/([^\.]+)/)[1] : ''
  unless (`git remote -v` =~ /origin.+?octopress(?:\.git)?/).nil?
    # If octopress is still the origin remote (from cloning) rename it to octopress
    system "git remote rename origin octopress"
    if branch == 'master'
      # If this is a user/organization pages repository, add the correct origin remote
      # and checkout the source branch for committing changes to the blog source.
      system "git remote add origin #{repo_url}"
      puts "Added remote #{repo_url} as origin"
      system "git config branch.master.remote origin"
      puts "Set origin as default remote"
      system "git branch -m master source"
      puts "Master branch renamed to 'source' for committing your blog source files"
    else
      unless !TaskConfig::PUBLIC_DIR.match("#{project}").nil?
        system "rake set_root_dir[#{project}]"
      end
    end
  end
  url = "http://#{user}.github.com"
  url += "/#{project}" unless project == ''
  jekyll_config = IO.read('_config.yml')
  jekyll_config.sub!(/^url:.*$/, "url: #{url}")
  File.open('_config.yml', 'w') do |f|
    f.write jekyll_config
  end
  rm_rf deploy_dir
  mkdir deploy_dir
  cd "#{deploy_dir}" do
    system "git init"
    system "echo 'My Octopress Page is coming soon &hellip;' > index.html"
    system "git add ."
    system "git commit -m \"Octopress init\""
    system "git branch -m gh-pages" unless branch == 'master'
    system "git remote add origin #{repo_url}"
    rakefile = IO.read(__FILE__)
    rakefile.sub!(/TaskConfig::DEPLOY_BRANCH(\s*)=(\s*)(["'])[\w-]*["']/, "TaskConfig::DEPLOY_BRANCH\\1=\\2\\3#{branch}\\3")
    rakefile.sub!(/TaskConfig::DEPLOY_DEFAULT(\s*)=(\s*)(["'])[\w-]*["']/, "TaskConfig::DEPLOY_DEFAULT\\1=\\2\\3push\\3")
    File.open(__FILE__, 'w') do |f|
      f.write rakefile
    end
  end
  puts "\n---\n## Now you can deploy to #{url} with `rake deploy` ##"
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

desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
