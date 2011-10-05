$:.unshift File.dirname(__FILE__)

def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each { |f| require f }
end


require_all 'octopress'
require_all 'octopress/deployment'


module Octopress
  ROOT = File.expand_path '../', File.dirname(__FILE__)

  def self.config
    @config ||= lambda do
      config = Octopress::Configuration.new('_config.yml').config

      # Include optional configuration file for deployment settings
      deploy_config = Octopress::Configuration.new('deploy.yml').config
      config.merge! deploy_config unless deploy_config.nil?

      config
    end.call
  end


  def self.get_stdin(message)
    print message
    STDIN.gets.chomp
  end


  def self.ask(message, args)
    if args.kind_of?(Array)
      # args is a selection of values
      #args.to_s.gsub(/\"/, '').gsub(/, /,'/')
      answer = self.get_stdin("#{message} [#{args.join('/')}] ") while !args.include?(answer)
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