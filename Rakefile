require "rubygems"
require "bundler/setup"
require "stringex"
require "right_aws"
require "digest/md5"
require "mime/types"

## -- Rsync Deploy config -- ##
# Be sure your public key is listed in your server's ~/.ssh/authorized_keys file
ssh_user       = "user@domain.com"
document_root  = "~/website.com/"
deploy_default = "rsync"

# This will be configured for you when you run config_deploy
deploy_branch  = "gh-pages"

## -- Misc Configs -- ##

public_dir      = "public"    # compiled site directory
source_dir      = "source"    # source file directory
blog_index_dir  = 'source'    # directory for your blog's index page (if you put your index in source/blog/index.html, set this to 'source/blog')
deploy_dir      = "_deploy"   # deploy directory (for Github pages deployment)
stash_dir       = "_stash"    # directory to stash posts for speedy generation
posts_dir       = "_posts"    # directory for blog files
themes_dir      = ".themes"   # directory for blog files
new_post_ext    = "markdown"  # default new post file extension when using the new_post task
new_page_ext    = "markdown"  # default new page file extension when using the new_page task
server_port     = "4000"      # port for preview server eg. localhost:4000


desc "Initial setup for Octopress: copies the default theme into the path of Jekyll's generator. Rake install defaults to rake install[classic] to install a different theme run rake install[some_theme_name]"
task :install, :theme do |t, args|
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
  system "jekyll"
end

desc "Watch the site and regenerate when it changes"
task :watch do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "Starting to watch source with Jekyll and Compass."
  jekyllPid = spawn("jekyll --auto")
  compassPid = spawn("compass watch")

  trap("INT") {
	Process.kill(9, jekyllPid)
	Process.kill(9, compassPid)
	exit 0
  }

  Process.wait
end

desc "preview the site in a web browser"
task :preview do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  puts "Starting to watch source with Jekyll and Compass. Starting Rack on port #{server_port}"
  jekyllPid = spawn("jekyll --auto")
  compassPid = spawn("compass watch")
  rackupPid = spawn("rackup --port #{server_port}")

  trap("INT") {
	Process.kill(9, jekyllPid)
	Process.kill(9, compassPid)
	Process.kill(9, rackupPid)
	exit 0
  }

  Process.wait
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  require './plugins/titlecase.rb'
  mkdir_p "#{source_dir}/#{posts_dir}"
  args.with_defaults(:title => 'new-post')
  title = args.title
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  puts "Creating new post: #{filename}"
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
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
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
    puts "Creating new page: #{file}"
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
    puts "Syntax error: #{args.filename} contains unsupported characters"
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

desc "Clean out caches: _code_cache, _gist_cache, .sass-cache"
task :clean do
  rm_rf ["_code_cache/**", "_gist_cache/**", ".sass-cache/**", "source/stylesheets/screen.css"]
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
end

desc "Move source to source.old, install source theme updates, replace source/_includes/navigation.html with source.old's navigation"
task :update_source, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{source_dir}.old")
    puts "removed existing #{source_dir}.old directory"
    rm_r "#{source_dir}.old", :secure=>true
  end
  mv source_dir, "#{source_dir}.old"
  puts "moved #{source_dir} into #{source_dir}.old/"
  mkdir_p source_dir
  cp_r "#{themes_dir}/"+theme+"/source/.", source_dir
  cp_r "#{source_dir}.old/.", source_dir, :preserve=>true
  cp_r "#{source_dir}.old/_includes/custom/.", "#{source_dir}/_includes/custom/"
  mv "#{source_dir}/index.html", "#{blog_index_dir}", :force=>true if blog_index_dir != source_dir
  cp "#{source_dir}.old/index.html", source_dir if blog_index_dir != source_dir
  puts "## Updated #{source_dir} ##"
end

##############
# Deploying  #
##############

desc "Default deploy task"
multitask :deploy => [:copydot, "#{deploy_default}"] do
end

desc "copy dot files for deployment"
task :copydot do
  cd "#{source_dir}" do
    exclusions = [".", "..", ".DS_Store"]
    Dir[".*"].each do |file|
      if !File.directory?(file) && !exclusions.include?(file)
        cp(file, "../#{public_dir}");
      end
    end
  end
end

desc "Deploy website via rsync"
task :rsync do
  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avz --delete #{public_dir}/ #{ssh_user}:#{document_root}")
end

namespace :aws do 
  
  def aws_init
    config = YAML::load(File.open('_config.yml'))
    return {
      :access_key_id      => config['aws_access_key_id'],
      :secret_access_key  => config['aws_secret_access_key'],
      :s3_bucket          => URI.parse(config['url']).host
    }
  end
  
  def s3_deploy(aws_access_key_id, aws_secret_access_key, s3_bucket, public_dir)
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN
    s3 = RightAws::S3.new(aws_access_key_id, aws_secret_access_key, { :logger => logger })
    paths_to_invalidate = []
    # Retreive bucket or create it if not available
    bucket = s3.bucket(s3_bucket, true, 'public-read')
    Dir.glob("#{public_dir}/**/*").each do |file|
      if File.file?(file)
        remote_file = file.gsub("#{public_dir}/", "")
        key = bucket.key(remote_file, true)
        if !key || (key.e_tag != ("\"" + Digest::MD5.hexdigest(File.read(file))) + "\"")
          puts "Deploying file #{remote_file}"
          bucket.put(key, open(file), {}, 'public-read', {
            'content-type'        => MIME::Types.type_for(file).first.to_s,
            'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
          })
          paths_to_invalidate << "/#{remote_file}"
        end
      end
    end
    return paths_to_invalidate
  end
  
  def cloudfront_init(aws_access_key_id, aws_secret_access_key, s3_bucket)
    puts "Checking Amazon CloudFront environment"
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN
    acf = RightAws::AcfInterface.new(aws_access_key_id, aws_secret_access_key, { :logger => logger })
    distributions = acf.list_distributions
    # Locate distribution by CNAME
    distributions = distributions.select { |distribution| distribution[:cnames].include?(s3_bucket) }
    # Create distribution if not found
    if (distributions.empty?) then
      puts "Creating Amazon CloudFront distribution... This usually requires a few minutes, please be patient!"
      config = {
        :enabled              => true,
        :comment              => "http://#{s3_bucket}",
        :cnames               => [ s3_bucket ],
        :s3_origin            => {
          :dns_name           => "#{s3_bucket}.s3.amazonaws.com"
        },
        :default_root_object  => 'index.html'
      }
      distributionID = acf.create_distribution(config)[:aws_id]
      # Wait for distribution to be created... This can take a while!
      while (acf.get_distribution(distributionID)[:status] == 'InProgress')
        puts "Still waiting for CloudFront distribution to be started..."
        sleep 30
      end
      distribution = distributions.select { |distribution| distribution[:cnames].include?(s3_bucket) }.first
      puts "Distribution #{distributionID} created and ready to serve your blog"
    else
      distribution = distributions.first
      puts "Distribution #{distribution[:aws_id]} found"
    end
    return distribution
  end
  
  def cloudfront_invalidate(aws_access_key_id, aws_secret_access_key, distribution, paths_to_invalidate)
    if (paths_to_invalidate.empty?) then
      return;
    end
    puts "Invalidating CloudFront caches"
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN
    acf = RightAws::AcfInterface.new(aws_access_key_id, aws_secret_access_key, { :logger => logger })
    acf.create_invalidation distribution[:aws_id], :path => paths_to_invalidate
  end
  
  desc "Deploy website to Amazon S3"
  task :s3 do
    puts "## Deploying website to Amazon S3"
    aws = aws_init
    s3_deploy(aws[:access_key_id], aws[:secret_access_key], aws[:s3_bucket], public_dir)
    puts "\n## Amazon S3 deploy complete"
  end

  desc "Deploy website to Amazon CloudFront"
  task :cloudfront do
    puts "## Deploying website to Amazon CloudFront"
    aws = aws_init
    distribution = cloudfront_init(aws[:access_key_id], aws[:secret_access_key], aws[:s3_bucket])
    paths_to_invalidate = s3_deploy(aws[:access_key_id], aws[:secret_access_key], aws[:s3_bucket], public_dir)
    cloudfront_invalidate(aws[:access_key_id], aws[:secret_access_key], distribution, paths_to_invalidate)
    puts "\n## Amazon CloudFront deploy complete"
  end
end

desc "deploy public directory to github pages"
multitask :push do
  puts "## Deploying branch to Github Pages "
  (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
  system "cp -R #{public_dir}/* #{deploy_dir}"
  puts "\n## copying #{public_dir} to #{deploy_dir}"
  cd "#{deploy_dir}" do
    system "git add ."
    system "git add -u"
    puts "\n## Commiting: Site updated at #{Time.now.utc}"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m '#{message}'"
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch}"
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
    puts "## Site's root directory is now '/#{dir.sub(/^\//, '')}' ##"
  end
end

desc "Setup _deploy folder and deploy branch"
task :config_deploy, :branch do |t, args|
  puts "!! Please provide a deploy branch, eg. rake init_deploy[gh-pages] !!" unless args.branch
  puts "## Creating a clean #{args.branch} branch in ./#{deploy_dir} for Github pages deployment"
  cd "#{deploy_dir}" do
    system "git symbolic-ref HEAD refs/heads/#{args.branch}"
    system "rm .git/index"
    system "git clean -fdx"
    system "echo 'My Octopress Page is coming soon &hellip;' > index.html"
    system "git add ."
    system "git commit -m 'Octopress init'"
    rakefile = IO.read(__FILE__)
    rakefile.sub!(/deploy_branch(\s*)=(\s*)(["'])[\w-]*["']/, "deploy_branch\\1=\\2\\3#{args.branch}\\3")
    rakefile.sub!(/deploy_default(\s*)=(\s*)(["'])[\w-]*["']/, "deploy_default\\1=\\2\\3push\\3")
    File.open(__FILE__, 'w') do |f|
      f.write rakefile
    end
  end
  puts "## Deployment configured. Now you can deploy to the #{args.branch} branch with `rake deploy` ##"
end

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
