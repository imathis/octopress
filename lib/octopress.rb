$:.unshift File.dirname(__FILE__)

require 'yaml'
require 'octopress/setup_deployment'
require 'octopress/deployment'

module Octopress
  extend SetupDeployment::ClassMethods
  extend Deployment::ClassMethods
  
  def self.config(dir_string = nil)
    dir_string ||= File.dirname(File.dirname(__FILE__))
    @config ||= lambda do
      begin
        config_file = File.expand_path "../_config.yml", File.dirname(__FILE__)
        config = YAML::load(File.open(config_file))

        # Include optional configuration containing local settings
        localconfig_file = File.expand_path "../_localconfig.yml", File.dirname(__FILE__)
        config.merge! YAML::load(File.open(localconfig_file)) if File.exists?(localconfig_file)

        # Include optional configuration file for deployment settings
        if config['deploy_config']
          deployconfig_file = File.expand_path "../#{config['deploy_config']}.yml", File.dirname(__FILE__)
          config.merge! YAML::load(File.open(deployconfig_file)) if File.exists?(deployconfig_file)
        end
        
        config['octopress_paths_source'] = File.expand_path "#{config['octopress_project_path']}/#{config['octopress_project_source_name']}", dir_string
        config['octopress_paths_public'] = File.expand_path "#{config['octopress_core_path']}/#{config['octopress_core_destination_name']}", dir_string
        config['octopress_paths_stylesheets'] = File.expand_path "#{config['octopress_paths_source']}/#{config['octopress_project_stylesheets_name']}", dir_string
        config['octopress_paths_plugins'] = File.expand_path "#{config['octopress_core_path']}/#{config['octopress_core_plugins_name']}", dir_string
        config['octopress_paths_jekyll_config'] = File.expand_path "#{config['octopress_project_path']}/#{config['octopress_project_source_name']}/_config.yml", dir_string
        config['octopress_paths_sass'] = File.expand_path "#{config['octopress_project_path']}/#{config['octopress_project_sass_dir_name']}", dir_string
        config['octopress_paths_sass_project_path'] = File.expand_path "#{config['octopress_project_path']}", dir_string
        config['octopress_sass_dir_name'] = config['octopress_project_sass_dir_name']
        config['octopress_sass_images_dir_name'] = config['octopress_project_sass_images_dir_name']
        config['octopress_sass_fonts_dir_name'] = config['octopress_project_sass_fonts_dir_name']
        config['octopress_paths_themes'] = File.expand_path "#{config['octopress_core_path']}/#{config['octopress_core_themes_name']}"
        config['octopress_source_dir_name'] = config['octopress_project_source_name']
        config['octopress_stylesheets_dir_name'] = config['octopress_project_stylesheets_name']

        # These settings are very important to Jekyll.
        config['source'] = config['octopress_paths_source']
        config['plugins'] = config['octopress_paths_plugins']
        config['destination'] = config['octopress_paths_plugins']

        # Write out a combined configuration file (for jekyllL)
        combined_config_file = config['octopress_paths_jekyll_config']
        if !File.exists?(File.dirname(combined_config_file))
          mkdir_p File.dirname(combined_config_file)
        end
        File.open(combined_config_file, 'w') do |f|
          f.write "# This file is automatically generated.\n"
          f.write config.to_yaml
        end

        config
      rescue
        puts "YAML Exception reading Octopress config"
      end
    end.call
  end


  def self.get_stdin(message)
    print message
    STDIN.gets.chomp
  end
   

  def self.ask(message, args)
    if args.kind_of?(Array)
      # args is a selection of values
      answer = self.get_stdin("#{message} #{args.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !args.include?(answer)
    elsif args.kind_of?(String)
      # args is a default value
      answer = self.get_stdin("#{message} [#{args}] ")
      answer = args if answer.empty?
    else
      # just read from STDIN
      answer = self.get_stdin(message)
    end
    answer
  end

end
