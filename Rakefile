require "rubygems"
require "bundler/setup"
require "stringex"
require "./lib/octopress.rb"

config          = Octopress.config

# --------------------------------- #
#   get configs from _config.yml    #
# --------------------------------- #
#
deploy_config   = config['deploy_config']

public_dir      = config['destination']     # compiled site directory
style_dir       = config['stylesheets']     # stylesheet directory
source_dir      = config['source']          # source file directory
blog_index_dir  = config['blog_index_dir']  # directory for your blog's index page (if you put your index in source/blog/index.html, set this to 'source/blog')
new_post_ext    = config['new_post_ext']    # default new post file extension when using the new_post task
new_page_ext    = config['new_page_ext']    # default new page file extension when using the new_page task
server_port     = config['4000']            # port for preview server eg. localhost:4000


## -- Misc Rakefile Configs -- ##

themes_dir      = '.themes'   # directory for blog files
stash_dir       = '_stash'    # directory to stash posts for speedy generation
posts_dir       = '_posts'    # directory for blog files

desc "Initial setup for Octopress: copies the default theme into the path of Jekyll's generator. Rake install defaults to rake install[classic] to install a different theme run rake install[some_theme_name]"
task :install, :theme do |t, args|
  if File.directory?(source_dir) || File.directory?("sass")
    abort("rake aborted!") if Octopress.ask("A theme is already installed, proceeding will overwrite existing files. Are you sure?", ['y', 'n']) == 'n'
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
  raise "!! You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "## Generating Site with Jekyll"
  style_dir.sub!(/#{public_dir}/, source_dir)
  system "jekyll"
end

desc "Watch the site and regenerate when it changes"
task :watch do
  raise "!! You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "## Starting to watch source with Jekyll and Compass."
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
  raise "!! You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "## Starting to watch source with Jekyll and Compass. Starting Rack on port #{server_port}"
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
  raise "!! You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  require './plugins/titlecase.rb'
  mkdir_p "#{source_dir}/#{posts_dir}"
  args.with_defaults(:title => 'new-post')
  title = args.title
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if Octopress.ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "## Creating new post: #{filename}"
  open(filename, 'w') do |post|
    system "mkdir -p #{source_dir}/#{posts_dir}/";
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;').titlecase}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "comments: true"
    post.puts "categories: "
    post.puts "---"
  end
end

# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page.markdown")
desc "Create a new page in #{source_dir}/(filename)/index.#{new_page_ext}"
task :new_page, :filename do |t, args|
  raise "!! You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  require './plugins/titlecase.rb'
  args.with_defaults(:filename => 'new-page')
  page_dir = source_dir
  if args.filename =~ /(^.+\/)?([\w_-]+)(\.)?(.+)?/
    page_dir += $4 ? "/#{$1}" : "/#{$1}#{$2}/"
    name = $4 ? $2 : "index"
    extension = $4 || "#{new_page_ext}"
    filename = "#{name}.#{extension}"
    mkdir_p page_dir
    file = page_dir + filename
    if File.exist?(file)
      abort("rake aborted!") if Octopress.ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "## Creating new page: #{file}"
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "layout: page"
      page.puts "title: \"#{$2.gsub(/[-_]/, ' ').titlecase}\""
      page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
      page.puts "comments: true"
      page.puts "sharing: true"
      page.puts "footer: true"
      page.puts "---"
    end
  else
    raise "!! Syntax error: #{args.filename} contains unsupported characters"
  end
end

# usage rake isolate[my-post]
desc "Move all other posts than the one currently being worked on to a temporary stash location (stash) so regenerating the site happens much quicker."
task :isolate, :filename do |t, args|
  stash_dir = "#{source_dir}/#{stash_dir}"
  FileUtils.mkdir(stash_dir) unless File.exist?(stash_dir)
  Dir.glob("#{source_dir}/#{posts_dir}/*.*") do |post|
    FileUtils.mv post, stash_dir unless post.include?(args.filename)
  end
end

desc "Move all stashed posts back into the posts directory, ready for site generation."
task :integrate do
  FileUtils.mv Dir.glob("#{source_dir}/#{stash_dir}/*.*"), "#{source_dir}/#{posts_dir}/"
end

desc "Clean out caches: .pygments-cache, .gist-cache, .sass-cache"
task :clean do
  rm_rf [".pygments-cache/**", ".gist-cache/**", ".sass-cache/**", "source/stylesheets/screen.css"]
end

desc "Move sass to sass.old, install sass theme updates, replace sass/custom with sass.old/custom"
task :update_style, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("sass.old")
    puts "## Removed existing sass.old directory"
    rm_r "sass.old", :secure=>true
  end
  mv "sass", "sass.old"
  puts "## Moved styles into sass.old/"
  cp_r "#{themes_dir}/"+theme+"/sass/", "sass"
  cp_r "sass.old/custom/.", "sass/custom"
  puts "## Updated Sass"
end

desc "Move source to source.old, install source theme updates, replace source/_includes/navigation.html with source.old's navigation"
task :update_source, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{source_dir}.old")
    puts "## Removed existing #{source_dir}.old directory"
    rm_r "#{source_dir}.old", :secure=>true
  end
  cp_r "#{source_dir}/.", "#{source_dir}.old"
  puts "## Copied #{source_dir} into #{source_dir}.old/"
  cp_r "#{themes_dir}/"+theme+"/source/.", source_dir, :remove_destination=>true
  cp_r "#{source_dir}.old/_includes/custom/.", "#{source_dir}/_includes/custom/", :remove_destination=>true
  mv "#{source_dir}/index.html", "#{blog_index_dir}", :force=>true if blog_index_dir != source_dir
  cp "#{source_dir}.old/index.html", source_dir if blog_index_dir != source_dir
  puts "## Updated #{source_dir}"
end

##############
# Deploying  #
##############

desc "Setup deploy configuration"
task :setup_deploy, :platform do |t, args|
  valid_platforms = Octopress.get_deployment_platforms
  platform = args.platform
  platform = Octopress.ask('Please select your deployment platform.', valid_platforms) if platform.nil? || !valid_platforms.include?(platform)

  Octopress.send("setup_#{platform}")
end


desc "Deploy task"
task :deploy do
  raise "!! Please setup your deployment environment first with `rake setup_deploy`" if deploy_config.nil?
  Rake::Task[:copydot].execute
  Octopress.send("deploy_#{deploy_config}")
end

desc "Generate website and deploy"
task :gen_deploy => [:integrate, :generate, :deploy] do
end


desc "copy dot files for deployment"
task :copydot do
  exclusions = [".", "..", ".DS_Store"]
  Dir["#{source_dir}/**/.*"].each do |file|
    if !File.directory?(file) && !exclusions.include?(File.basename(file))
      cp(file, file.gsub(/#{source_dir}/, "#{public_dir}"));
    end
  end
end


desc "Update configurations to support publishing to root or sub directory"
task :set_root_dir, :dir do |t, args|
  raise "!! Please provide a directory, eg. rake config_dir[publishing/subdirectory]" unless args.dir
  if args.dir
    if args.dir == "/"
      dir = ""
    else
      dir = "/" + args.dir.sub(/(\/*)(.+)/, "\\2").sub(/\/$/, '');
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
    puts "## Site's root directory is now '/#{dir.sub(/^\//, '')}'"
  end
end

def ok_failed(condition)
  puts condition ? "OK" : "FAILED"
end


desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
