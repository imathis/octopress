#!/usr/bin/env ruby -wKU

raise "Git is required for the migration." if `which git`.empty?
raise "You must run this script from the root of your Octopress blog directory" unless File.exist? File.join(Dir.pwd, '_config.yml') and \
                                                                                       File.exist? File.join(Dir.pwd, 'Rakefile')

require "fileutils"
require "yaml"

LOCAL_OCTOPRESS_INSTALLATION = Dir.pwd

OCTO_GIT = "https://github.com/imathis/octopress.git"
NEW_OCTO = File.join(File.dirname(LOCAL_OCTOPRESS_INSTALLATION), ["octopress", Time.now.year, Time.now.month, Time.now.day].join('-'))

def old_octo_dir(*subdirs)
  File.join(LOCAL_OCTOPRESS_INSTALLATION, *subdirs)
end

def new_octo_dir(*subdirs)
  File.join(NEW_OCTO, *subdirs)
end

def read_yaml(path)
  YAML.load(File.read(path))
end

begin
  # Make local copy of imathis/octopress
  FileUtils.rm_rf new_octo_dir
  system "git clone #{OCTO_GIT} #{new_octo_dir}; cd #{new_octo_dir}; git checkout 2.1"
  
  # Copy .git from old to new
  FileUtils.rm_rf new_octo_dir('.git')
  FileUtils.cp_r  old_octo_dir('.git'), new_octo_dir
  
  #
  # migrate configuration
  #
  local_config      = read_yaml(old_octo_dir("_config.yml"))
  rakefile_contents = File.read(old_octo_dir('Rakefile'))
  
  # grab configs
  %w(public_dir source_dir blog_index_dir stash_dir posts_dir themes_dir new_post_ext new_page_ext server_port).each do |var|
    matched = rakefile_contents.match(/#{var}\s*=\s*["']([^"']*)["']/)
    begin
      local_configs[var] = matched[1]
    rescue
      puts "No value could be found for '#{var}' in the old Rakefile."
    end
  end

  # build site configs
  site_config = {}
  %w(classic.yml disqus.yml gauges_analytics.yml github_repos_sidebar.yml google_analytics.yml
    google_plus.yml jekyll.yml share_posts.yml tweets_sidebar.yml).each do |yaml_file|
    this_yaml = read_yaml(new_octo_dir('_config', 'defaults', yaml_file))
    this_yaml.each_key do |key|
      if local_config.has_key?(key) and this_yaml[key] != local_config[key]
        site_config[key] = local_config[key]
      end
    end
  end
  
  # build deploy configs
  deploy_configs         = {}
  deploy_default         = rakefile_contents.match(/deploy_default\s*=\s*["']([\w-]*)["']/)[1]
  deploy_default_file    = new_octo_dir('_config', 'defaults', 'deploy', (deploy_default == 'push' ? 'gh_pages.yml' : 'rsync.yml'))
  deploy_default_configs = read_yaml(deploy_default_file)
  
  # read in deploy configs from rakefile
  %w(deploy_dir deploy_branch ssh_user document_root ssh_port deploy_default).each do |var|
    matched = rakefile_contents.match(/#{var}\s*=\s*["']([^"']*)["']/)
    begin
      deploy_configs[var] = matched[1] if deploy_default_configs.has_key?(var) && deploy_default_configs[var] != matched[1]
    rescue
      puts "No value could be found for '#{var}' in the old Rakefile."
    end
  end
  deploy_configs["rsync_delete"] = rakefile_contents.match(/rsync_delete\s*=\s*(true|false)/)[1] == "true"
  
  # write configs
  File.open(new_octo_dir('_config', 'site.yml'), 'w') do |f|
    f.write(site_config.to_yaml)
  end
  File.open(new_octo_dir('_config', 'deploy.yml'), 'w') do |f|
    f.write(deploy_configs.to_yaml)
  end
  
  # migrate old source to new
  FileUtils.mv old_octo_dir("source"), new_octo_dir
  
  # migrate old sass to new
  FileUtils.mv old_octo_dir("sass"), new_octo_dir
  
  # migrate custom themes
  custom_themes = Dir.glob(old_octo_dir('.themes', '*')).delete_if { |theme| theme =~ /\.themes\/classic/ }
  FileUtils.cp_r custom_themes, new_octo_dir('.themes')
  
  # migrate Rakefile
  FileUtils.mv old_octo_dir("Rakefile"), new_octo_dir("Rakefile-old")

  # migrate updated plugins (but leave deprecated ones)
  octopress_plugins = Dir.glob(new_octo_dir('plugins', '*')).map { |path| path.match(/([\w]*\/[\w]*.rb)$/)[1] }
  custom_plugins    = Dir.glob(old_octo_dir('plugins', '*')).map { |path| path.match(/([\w]*\/[\w]*.rb)$/)[1] } - octopress_plugins
  FileUtils.cp_r custom_plugins.map { |rel_path| old_octo_dir(rel_path) }, new_octo_dir('plugins')

  # move new to old's location
  FileUtils.rm_rf old_octo_dir
  FileUtils.mv new_octo_dir, old_octo_dir

  # cleanup
  FileUtils.rm_rf new_octo_dir
  
  puts "Your Octopress site has been successfully upgraded."
  puts "Happy blogging!"
  
rescue => e
  puts "An error occurred: #{e}."
  exit 1
end

