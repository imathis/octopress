require 'logger'

module Octopress
  class Ink < Logger
    def self.build
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      logger.formatter = Formatters::SimpleFormatter.new
      logger
    end
  end
end
