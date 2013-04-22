module Octopress
  module Logger
    def self.info(msg)
      message(msg)
    end

    def self.warn(msg)
      message(msg.yellow)
    end

    def self.error(msg)
      message(msg.red)
    end

    def self.message(msg)
      $stdout.puts msg
    end
  end
end
