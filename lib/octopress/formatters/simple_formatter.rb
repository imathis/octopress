module Octopress
  module Formatters
    class SimpleFormatter < Logger::Formatter
      def call(severity, timestamp, progname, msg)
        "#{msg}\n"
      end
    end
  end
end
