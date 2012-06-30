require 'guard'
require 'guard/guard'

require 'uglifier'

module Guard
  class Uglify < Guard

    VERSION = '0.0.1'

    def initialize(watchers=[], options={})
      super
      # make input an array if it isn't already
      options[:input] = [options[:input]] unless options[:input].is_a?(Array)

      @input = options[:input]
      @output = options[:output]
    end

    def start
      UI.info "Guard::Uglify is watching for file changes..."
    end

    def run_all
      uglify
    end

    def run_on_changes(paths)
      uglify
    end

    private

    def uglify
      begin
        joined_contents = @input.reduce("") { |memo, filename|
          memo + "\n;" + File.read(filename)
        }

        uglified = Uglifier.new.compile(joined_contents)

        # Ensure directoy exists before creating the file
        unless File.directory? File.dirname(@output)
          FileUtils.mkdir_p(File.dirname(@output))
        end

        File.open(@output, 'w'){ |f| f.write(uglified) }

        UI.info         "Uglified #{@input} to #{@output}"
        Notifier.notify "Uglified #{@input} to #{@output}", :title => 'Uglify'
        true
      rescue Exception => e
        UI.error        "Uglifying #{@input} failed: #{e}"
        Notifier.notify "Uglifying #{@input} failed: #{e}", :title => 'Uglify', :image => :failed
        false
      end
    end
  end
end

