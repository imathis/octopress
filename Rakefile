require "rubygems"
require "bundler/setup"
require "stringex"
require 'rake/minify'

## -- Rsync Deploy config -- ##
# Be sure your public key is listed in your server's ~/.ssh/authorized_keys file
ssh_user       = "user@domain.com"
ssh_port       = "22"
document_root  = "~/website.com/"
rsync_delete   = false
deploy_default = "rsync"

# Hidden "dot" files that should be included with the deployed site (see task copydot)
copy_dot_files = []

# This will be configured for you when you run config_deploy
deploy_branch  = "gh-pages"

## -- Misc Configs -- ##

public_dir      = "public"    # compiled site directory
source_dir      = "source"    # source file directory
blog_index_dir  = 'source'    # directory for your blog's index page (if you put your index in source/blog/index.html, set this to 'source/blog')
deploy_dir      = "_deploy"   # deploy directory (for GitHub pages deployment)
stash_dir       = "_stash"    # directory to stash posts for speedy generation
posts_dir       = "_posts"    # directory for blog files
themes_dir      = ".themes"   # directory for blog files
new_post_ext    = "markdown"  # default new post file extension when using the new_post task
new_page_ext    = "markdown"  # default new page file extension when using the new_page task
server_port     = "4000"      # port for preview server eg. localhost:4000


desc "Initial setup for Octopress: copies the default theme into the path of Jekyll's generator. Rake install defaults to rake install[classic] to install a different theme run rake install[some_theme_name]"
task :install, :theme do |t, args|
  if File.directory?(source_dir) || File.directory?("sass")
    abort("rake aborted!") if ask("A theme is already installed, proceeding will overwrite existing files. Are you sure?", ['y', 'n']) == 'n'
  end
  # copy theme into working Jekyll directories
  theme = args.theme || 'classic'
  puts "## Copying "+theme+" theme into ./#{source_dir} and ./sass"
  mkdir_p source_dir
  cp_r "#{themes_dir}/#{theme}/source/.", source_dir
  mkdir_p "sass"
  cp_r "#{themes_dir}/#{theme}/sass/.", "sass"
  mkdir_p "#{source_dir}/#{posts_dir}"
  mkdir_p public_dir
end

#######################
# Working with Jekyll #
#######################

desc "Generate jekyll site"
task :generate do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "## Generating Site with Jekyll"
  system "compass compile --css-dir #{source_dir}/stylesheets"
  Rake::Task['minify_and_combine'].execute
  system "jekyll"
end

Rake::Minify.new(:minify_and_combine) do
  files = FileList.new("#{source_dir}/javascripts/group/*.*")

  output_file =  "#{source_dir}/javascripts/octopress.min.js"

  puts "BEGIN Minifying #{output_file}"
  group(output_file) do
    files.each do |filename|
      puts "Minifying- #{filename} into #{output_file}"
      if filename.include? '.min.js'
        add(filename, :minify => false)
      else
        add(filename)
      end
    end
  end
  puts "END Minifying #{output_file}"
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

desc "Watch the site and regenerate when it changes"
task :watch do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "Starting to watch source with Jekyll and Compass."
  system "compass compile --css-dir #{source_dir}/stylesheets"
  Rake::Task['minify_and_combine'].execute
  jekyllPid = Process.spawn("jekyll --auto")
  compassPid = Process.spawn("compass watch")
  trap("INT") {
    [jekyllPid, compassPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }
  [jekyllPid, compassPid].each { |pid| Process.wait(pid) }
end

desc "preview the site in a web browser"
task :preview do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "Starting to watch source with Jekyll and Compass. Starting Rack on port #{server_port}"
  system "compass compile --css-dir #{source_dir}/stylesheets"
  jekyllPid = Process.spawn("jekyll --auto")
  compassPid = Process.spawn("compass watch")
  rackupPid = Process.spawn("rackup --port #{server_port}")

  trap("INT") {
    [jekyllPid, compassPid, rackupPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid, rackupPid].each { |pid| Process.wait(pid) }
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  mkdir_p "#{source_dir}/#{posts_dir}"
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
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
    post.puts "external-url: "
    post.puts "categories: "
    post.puts "---"
  end
end

# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page.markdown")
desc "Create a new page in #{source_dir}/(filename)/index.#{new_page_ext}"
task :new_page, :filename do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  args.with_defaults(:filename => 'new-page')
  page_dir = [source_dir]
  if args.filename.downcase =~ /(^.+\/)?(.+)/
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    title = filename
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    if extension.nil?
      page_dir << filename
      filename = "index"
    end
    extension ||= new_page_ext
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
desc "Move all other posts than the one currently being worked on to a temporary stash location (stash) so regenerating the site happens much quicker."
task :isolate, :filename do |t, args|
  if args.filename
    filename = args.filename
  else
    filename = get_stdin("Enter a post file name: ")
  end
  full_stash_dir = "#{source_dir}/#{stash_dir}"
  FileUtils.mkdir(full_stash_dir) unless File.exist?(full_stash_dir)
  Dir.glob("#{source_dir}/#{posts_dir}/*.*") do |post|
    FileUtils.mv post, full_stash_dir unless post.include?(filename)
  end
end

desc "Move all stashed posts back into the posts directory, ready for site generation."
task :integrate do
  FileUtils.mv Dir.glob("#{source_dir}/#{stash_dir}/*.*"), "#{source_dir}/#{posts_dir}/"
end

desc "Clean out caches: .pygments-cache, .gist-cache, .sass-cache"
task :clean do
  [".pygments-cache/**", ".gist-cache/**"].each { |dir| rm_rf Dir.glob(dir) }
  rm "#{source_dir}/stylesheets/screen.css" if File.exists?("#{source_dir}/stylesheets/screen.css")
  system "compass clean"
  puts "## Cleaned Sass, Pygments and Gist caches, removed generated stylesheets ##"
end

desc "Update theme source and style"
task :update, :theme do |t, args|
  theme = args.theme || 'classic'
  Rake::Task[:update_source].invoke(theme)
  Rake::Task[:update_style].invoke(theme)
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
  cp_r "#{themes_dir}/"+theme+"/sass/", "sass"
  cp_r "sass.old/custom/.", "sass/custom"
  puts "## Updated Sass ##"
  rm_r ".sass-cache", :secure=>true if File.directory?(".sass-cache")
end

desc "Move source to source.old, install source theme updates, replace source/_includes/navigation.html with source.old's navigation"
task :update_source, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{source_dir}.old")
    puts "## Removed existing #{source_dir}.old directory"
    rm_r "#{source_dir}.old", :secure=>true
  end
  mkdir "#{source_dir}.old"
  cp_r "#{source_dir}/.", "#{source_dir}.old"
  puts "## Copied #{source_dir} into #{source_dir}.old/"
  cp_r "#{themes_dir}/"+theme+"/source/.", source_dir, :remove_destination=>true
  cp_r "#{source_dir}.old/_includes/custom/.", "#{source_dir}/_includes/custom/", :remove_destination=>true
  mv "#{source_dir}/index.html", "#{blog_index_dir}", :force=>true if blog_index_dir != source_dir
  cp "#{source_dir}.old/index.html", source_dir if blog_index_dir != source_dir && File.exists?("#{source_dir}.old/index.html")
  if File.exists?("#{source_dir}/blog/archives/index.html")
    puts "## Moving blog/archives to /archives (standard location as of 2.1) ##"
    file = "#{source_dir}/_includes/custom/navigation.html"
    navigation = IO.read(file)
    navigation = navigation.gsub(/(.*)\/blog(\/archives)(.*$)/m, '\1\2\3')
    File.open(file, 'w') do |f|
      f.write navigation
    end
    rm_r "#{source_dir}/blog/archives"
    rm_r "#{source_dir}/blog" if Dir.entries("#{source_dir}/blog").join == "..."
  end
  puts "## Updated #{source_dir} ##"
end


##############
# Deploying  #
##############

desc "Default deploy task"
task :deploy do
  Rake::Task[:copydot].invoke(source_dir, public_dir)
  Rake::Task["#{deploy_default}"].execute
end

desc "Generate website and deploy"
task :gen_deploy => [:integrate, :generate, :deploy] do
end

desc "copy dot files for deployment"
task :copydot, :source, :dest do |t, args|
  files = [".htaccess"] | copy_dot_files
  Dir["#{args.source}/.*"].each do |file|
    if !File.directory?(file) && files.include?(File.basename(file))
      cp(file, file.gsub(/#{args.source}/, "#{args.dest}"));
    end
  end
end

desc "Deploy website via rsync"
task :rsync do
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avze 'ssh -p #{ssh_port}' #{exclude} #{"--delete" unless rsync_delete == false} #{public_dir}/ #{ssh_user}:#{document_root}")
end

desc "deploy public directory to github pages"
multitask :push do
  if File.directory?(deploy_dir)
    puts "## Deploying branch to GitHub Pages "
    (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
    Rake::Task[:copydot].invoke(public_dir, deploy_dir)
    puts "Attempting pull, to sync local deployment repository"
    cd "#{deploy_dir}" do
      system "git pull origin #{deploy_branch}"
    end
    puts "\n## copying #{public_dir} to #{deploy_dir}"
    cp_r "#{public_dir}/.", deploy_dir
    cd "#{deploy_dir}" do
      File.new(".nojekyll", "w").close
      system "git add ."
      system "git add -u"
      message = "Site updated at #{Time.now.utc}"
      puts "\n## Commiting: #{message}"
      system "git commit -m \"#{message}\""
      puts "\n## Pushing generated #{deploy_dir} website"
      system "git push origin #{deploy_branch}"
      puts "\n## GitHub Pages deploy complete"
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
    rakefile = IO.read(__FILE__)
    rakefile.sub!(/public_dir(\s*)=(\s*)(["'])[\w\-\/]*["']/, "public_dir\\1=\\2\\3public#{dir}\\3")
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
    rm_rf public_dir
    mkdir_p "#{public_dir}#{dir}"
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
    repo_url = get_stdin("Enter the read/write url for your repository: ")
  end
  user = repo_url.match(/:([^\/]+)/)[1]
  branch = (repo_url.match(/\/[\w-]+.github.com/).nil?) ? 'gh-pages' : 'master'
  project = (branch == 'gh-pages') ? repo_url.match(/\/([^\.]+)/)[1] : ''
  url = "http://#{user}.github.com"
  url += "/#{project}" unless project == ''
  unless `git remote -v`.match(/origin.+?octopress.git/).nil?
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
      unless !public_dir.match("#{project}").nil?
        Rake::Task[:set_root_dir].invoke(project)
      end
    end
  end

  # Configure deployment repository
  rm_rf deploy_dir
  mkdir deploy_dir
  cd "#{deploy_dir}" do
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

  # Configure deployment setup in Rakefile
  rakefile = IO.read(__FILE__)
  rakefile.sub!(/deploy_branch(\s*)=(\s*)(["'])[\w-]*["']/, "deploy_branch\\1=\\2\\3#{branch}\\3")
  rakefile.sub!(/deploy_default(\s*)=(\s*)(["'])[\w-]*["']/, "deploy_default\\1=\\2\\3push\\3")
  File.open(__FILE__, 'w') do |f|
    f.write rakefile
  end

  # Configure published url 
  jekyll_config = IO.read('_config.yml')
  current_url = /^url:\s?(.*$)/.match(jekyll_config)[1]
  has_cname = File.exists?("#{source_dir}/CNAME")
  if current_url == 'http://yoursite.com'
    jekyll_config.sub!(/^url:.*$/, "url: #{url}") 
    File.open('_config.yml', 'w') do |f|
      f.write jekyll_config
    end
    current_url = url
  end

  puts "\n========================================================"
  if has_cname
    cname = IO.read("#{source_dir}/CNAME").chomp
    current_short_url = /\/{2}(.*$)/.match(current_url)[1]
    if cname != current_short_url
      puts "!! WARNING: Your CNAME points to #{cname} but your _config.yml url is set to #{current_short_url} !!"
      puts "For help with setting up a CNAME follow the guide at http://help.github.com/pages/#custom_domains"
    else
      puts "GitHub Pages will host your site at http://#{cname}"
    end
  else
    puts "GitHub Pages will host your site at #{url}."
    puts "To host at \"your-site.com\", configure a CNAME: `echo \"your-domain.com\" > #{source_dir}/CNAME`"
    puts "Then change the url in _config.yml from #{current_url} to http://your-domain.com"
    puts "Finally, follow the guide at http://help.github.com/pages/#custom_domains for help pointing your domain to GitHub Pages"
  end
  puts "Deploy to #{repo_url} with `rake deploy`"
  puts "Note: generated content is copied into _deploy/ which is not in version control."
  puts "If starting with a fresh clone of this project you should re-run setup_github_pages."
  puts "========================================================"
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
