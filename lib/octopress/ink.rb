module Octopress
  class Ink < Logger
    def self.build
      logger = Ink.new(STDOUT)
      logger.level = Ink::WARN
      logger.formatter = Formatters::SimpleFormatter.new
      logger
    end

    def warn(message)
      add(WARN, message.yellow)
    end


    def error(message)
      add(ERROR, message.red)
    end

    def fatal(message)
      add(FATAL, message.red)
    end
  end
end
