require 'logger'

module Octopress
  class Logger < Logger
    def self.build
      logger = Logger.new(STDOUT)
      logger.formatter = Formatters::SimpleFormatter.new
      logger
    end
  end
end
