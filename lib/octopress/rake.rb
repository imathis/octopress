$:.unshift File.expand_path("../", File.dirname(__FILE__))

require 'helpers/titlecase'

module Octopress
  class Rake
    def self.init!(ctx)
      ctx.instance_eval do
        tasks_path = File.join(Octopress.lib_root, "rake", "*.rake")
        Dir[tasks_path].each do |f|
          load f
        end
      end
    end
  end
end
