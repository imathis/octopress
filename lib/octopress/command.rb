module Octopress
  class Command
    class << self
      def perform
        raise NotImplementedError
      end
    end
  end
end
