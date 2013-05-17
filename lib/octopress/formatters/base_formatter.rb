module Octopress
  module Formatters
    class BaseFormatter < Logger::Formatter
      def call(severity, timestamp, progname, msg)
        "#{severity} #{timestamp} #{progname} #{msg}"
      end

      def colorized_output(severity, msg)
        puts "#{severity.inspect}"
      end
    end
  end
end
