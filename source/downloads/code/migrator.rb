#!/usr/bin/env ruby -wKU

raise "Git is required for the migration." if `which git`.empty?
raise "You must run this script from the root of your Octopress blog directory" unless File.exist? File.join(Dir.pwd, '_config.yml') and \
                                                                                       File.exist? File.join(Dir.pwd, 'Rakefile')

require "fileutils"
require "yaml"

LOCAL_OCTOPRESS_INSTALLATION = Dir.pwd

OCTO_GIT = "https://github.com/imathis/octopress.git"
NEW_OCTO = File.join(File.dirname(LOCAL_OCTOPRESS_INSTALLATION), "new-octopress")

OCTO_CONFIG_GIT = "https://github.com/octopress/sample-octopress-configuration"
OCTO_CONFIG_DEST = File.join(NEW_OCTO, "_config")

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

  # Make local copy of octopress/sample-octopress-configuration
  FileUtils.rm_rf OCTO_CONFIG_DEST
  system "git clone #{OCTO_CONFIG_GIT} #{OCTO_CONFIG_DEST}"
  Dir.chdir(OCTO_CONFIG_DEST) do
    FileUtils.rm_rf %(.git .gitignore README.md)
  end
  
  # migrate configuration
  local_config = read_yaml(old_octo_dir("_config.yml"))
  
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
  
  # write deploy configs
  deploy_configs = {}
  rakefile = File.read(old_octo_dir('Rakefile'))
  default_deploy = rakefile.match(/deploy_default\s*=\s*["']([\w-]*)["']/)[1]
  defaults_deploy_file = old_octo_dir('_config', 'defaults', 'deploy', (default_deploy == 'push' ? 'gh_pages.yml' : 'rsync.yml'))
  deploy_configs = YAML.load(File.read(defaults_deploy_file))
  
  rakefile.match(/deploy_branch\s*=\s*["']([\w-]*)["'])[1]/)
  # TODO extract deploy configs from Rakefile
  
  # write configs
  File.open(new_octo_dir('_config', 'site.yml'), 'w') do |f|
    f.write(site_config.to_yaml)
  end
  File.open(new_octo_dir('_config', 'deploy.yml'), 'w') do |f|
    f.write(deploy_configs.to_yaml)
  end
  
  # migrate
  
  # migrate Rakefile
  FileUtils.mv old_octo_dir("Rakefile"), new_octo_dir("Rakefile-old")

  # migrate updated plugins (but leave deprecated ones)
  FileUtils.cp_r new_octo_dir("plugins"), old_octo_dir("plugins")

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

