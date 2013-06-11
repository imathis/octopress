module Octopress
  class Plugin
    def self.included(subclass)
      @plugins ||= []
      @plugins << subclass
      Octopress.logger.debug "Registering Plugin: #{subclass}"
    end

    def self.init!(context)
      @plugins.each do |plugin|
        plugin_tasks = File.join(plugin.root, 'lib', plugin.name, 'tasks.rake')
        if(File.exist?(plugin_tasks))
          context.instance_eval do
            load plugin_tasks
          end
        end
      end
    end

    def self.root; return self.const_get(:ROOT); end
    def self.name; return self.to_s.underscore; end
  end
end
