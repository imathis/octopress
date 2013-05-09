module Octopress
  module Formatters
    class VerboseFormatter < Logger::Formatter
      def call(severity, timestamp, progname, msg)
        "[#{timestamp}] #{severity}: #{msg}\n"
      end
    end
  end
end
