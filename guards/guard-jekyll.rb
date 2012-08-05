require 'guard'
require 'guard/guard'

require 'jekyll'

module Guard
  class Jekyll < Guard

    VERSION = '0.0.1'

    def initialize(watchers=[], options={})
      super

      @working_path = Pathname.pwd

      config = ::Jekyll.configuration({})
      @jekyll_site = ::Jekyll::Site.new(config)
    end

    def start
      UI.info "Guard::Jekyll is watching for file changes..."
    end

    def run_all
      jekyll
    end

    def run_on_changes(paths)
      jekyll
    end

    private

    def jekyll
      begin
        @jekyll_site.process
        UI.info "Jekyll build complete."
        Notifier.notify "Jekyll build complete", :title => 'Jekyll'
        true
      rescue Exception => e
        UI.error        "Jekyll build failed: #{e}"
        Notifier.notify "Jekyll build failed: #{e}", :title => 'Jekyll', :image => :failed
        false
      end
    end
  end
end
