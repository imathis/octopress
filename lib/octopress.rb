$:.unshift File.dirname(__FILE__)

require 'yaml'
require 'octopress/setup_deployment'
require 'octopress/deployment'

module Octopress
  extend SetupDeployment::ClassMethods
  extend Deployment::ClassMethods
  
  def self.config
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

        # Write out a combined configuration file (for jekyllL)
        combined_config_file = File.expand_path config['jekyll_config'], File.dirname(File.dirname(__FILE__))
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
