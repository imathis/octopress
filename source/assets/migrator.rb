#!/usr/bin/env ruby -wKU

raise "Git is required for the migration." if `which git`.empty?
raise "You must run this script from the root of your Octopress blog directory" unless File.exist? File.join(Dir.pwd, '_config.yml') and \
                                                                                       File.exist? File.join(Dir.pwd, 'Rakefile')

require "fileutils"
require "yaml"

OCTO_GIT = "https://github.com/imathis/octopress.git"
TMP_OCTO = "/tmp/octopress"

OCTO_CONFIG_GIT = "https://github.com/octopress/sample-octopress-configuration"
TMP_OCTO_CONFIG = "/tmp/sample-octopress-configuration"

begin
  # copy new theme to current directory
  system "git clone #{OCTO_GIT} #{TMP_OCTO}"
  FileUtils.rm_rf "#{Dir.pwd}/.themes/classic"
  FileUtils.cp_r "#{TMP_OCTO}/.themes/classic", "#{Dir.pwd}/.themes/classic"
  
  # migrate configuration
  local_config = YAML.load(File.read("#{Dir.pwd}/_config.yml"))
  
  FileUtils.rm_rf TMP_OCTO_CONFIG
  system "git clone #{OCTO_CONFIG_GIT} #{TMP_OCTO_CONFIG}"
  FileUtils.mkdir_p File.join(Dir.pwd, '_config')
  FileUtils.cp_r File.join(TMP_OCTO_CONFIG, 'defaults'), File.join(Dir.pwd, '_config'), :verbose => true, :remove_destination => true
  
  # build site configs
  site_config = {}
  %w(classic.yml disqus.yml gauges_analytics.yml github_repos_sidebar.yml google_analytics.yml
    google_plus.yml jekyll.yml share_posts.yml tweets_sidebar.yml).each do |yaml_file|
    this_yaml = YAML.load(File.read(File.join(Dir.pwd, 'defaults', yaml_file)))
    this_yaml.each_key do |key|
      if local_config.has_key?(key) and this_yaml[key] != local_config[key]
        site_config[key] = local_config[key]
    end
  end
  
  # write deploy configs
  deploy_configs = {}
  rakefile = File.read(File.join(Dir.pwd, 'Rakefile'))
  default_deploy = rakefile.match(/deploy_default\s*=\s*["']([\w-]*)["']/)[1]
  defaults_deploy_file = File.join(Dir.pwd, '_config', 'defaults', 'deploy', (default_deploy == 'push' ? 'gh_pages.yml' : 'rsync.yml'))
  deploy_configs = YAML.load(File.read(defaults_deploy_file))
  
  rakefile.match(/deploy_branch\s*=\s*["']([\w-]*)["'])[1]/)
  # TODO extract deploy configs from Rakefile
  
  # write configs
  File.open(File.join(Dir.pwd, '_config', 'site.yml'), 'w') do |f|
    f.write(site_config.to_yaml)
  end
  File.open(File.join(Dir.pwd, '_config', 'deploy.yml'), 'w') do |f|
    f.write(deploy_configs.to_yaml)
  end
  
  # migrate Rakefile
  FileUtils.mv "#{Dir.pwd}/Rakefile", "#{Dir.pwd}/Rakefile-old"
  FileUtils.cp "#{TMP_OCTO}/Rakefile", "#{Dir.pwd}/Rakefile"
  
  # migrate updated plugins (but leave deprecated ones)
  
  # cleanup
  FileUtils.rm_rf TMP_OCTO
  
  puts "Your Octopress site has been successfully upgraded."
  puts "Happy blogging!"
  
rescue => e
  puts "An error occurred #{e}."
  exit 1
end