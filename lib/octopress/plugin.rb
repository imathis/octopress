module Octopress
  class Plugin
    def self.included(subclass)
      @plugins ||= []
      @plugins << subclass
      Octopress.logger.debug "Registering Plugin: #{subclass}"
    end

    def self.init!(context)
      @plugins.each do |plugin|
        if plugin.tasks.size > 0
          plugin.tasks.each do |task_file|
            context.instance_eval do
              load task_file
            end
          end
        end
      end
    end

    def self.root
      self.const_get(:ROOT)
    end

    def self.name
      self.to_s.underscore
    end

    def self.tasks
      Dir[File.join(self.root, 'lib', self.name, 'rake', '*.rake')]
    end
  end
end
