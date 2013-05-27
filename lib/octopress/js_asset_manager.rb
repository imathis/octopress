$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'digest/md5'
require 'stitch-rb'
require 'uglifier'
require 'coffee-script'

module Octopress
  class JSAssetsManager

    attr_reader :config

    def initialize
      @js_assets_path = File.join(Octopress.root, "javascripts")

      if Dir.exists? @js_assets_path
        unless Octopress.configuration.has_key? :require_js
          abort "No :require_js key in configuration. Cannot proceed.".red
        end
        unless Octopress.configuration[:require_js].has_key? :lib
          abort "No :lib key in :require_js configuration. Cannot proceed.".red
        end
        unless Octopress.configuration[:require_js].has_key? :modules
          abort "No :modules key in :require_js configuration. Cannot proceed.".red
        end

        @lib_config = Octopress.configuration[:require_js][:lib]
        @lib_config = [@lib_config] unless @lib_config.kind_of?(Array)
        modules_config = Octopress.configuration[:require_js][:modules]

        # Read js dependencies from require_js.yml configuration
        @lib = @lib_config.collect {|item| Dir.glob("#{@js_assets_path}/lib/#{item}") }
        @lib.concat(Dir.glob("#{@js_assets_path}/lib/**/*")).flatten.uniq

        @modules = modules_config.collect {|item| "#{@js_assets_path}/#{item}" }.flatten.uniq
        @module_files = @modules.collect {|item| Dir[item+'/**/*'] }.flatten.uniq

      else
        @js_assets_path = false
      end
    end


    def get_fingerprint
      Digest::MD5.hexdigest(@module_files.concat(@lib).flatten.uniq.map! { |path| "#{File.mtime(path).to_i}" }.join + @lib_config.join)
    end

    def url
      @js_assets_path ?  "/javascripts/build/" + filename : false
    end

    def filename
      if @js_assets_path
        Octopress.env == 'production' ?  "all-#{@fingerprint || get_fingerprint}.js" : "all.js"
      else
        false
      end
    end

    def identical(file)
      File.size?(file) && File.open(file) {|f| f.readline} =~ /#{@fingerprint}/
    end

    def compile
      if @js_assets_path
        @fingerprint = get_fingerprint

        relative_dir = File.join(Octopress.configuration[:source], "javascripts/build")
        dir = File.join(Octopress.root, relative_dir)

        relative_file = File.join(relative_dir, filename)
        file = File.join(dir, filename)

        if identical(file)
          "identical ".green + relative_file
        else
          write_msg = (File.exists?(file) ? "overwrite " : "   create ").green + relative_file
          puts "compiling javascripts..."

          js = Stitch::Package.new(:dependencies => @lib.flatten, :paths => @modules.flatten).compile
          js = Uglifier.new.compile js if Octopress.env == 'production'
          js = "/* Octopress fingerprint: #{@fingerprint} */\n" + js

          FileUtils.rm_rf dir
          FileUtils.mkdir_p dir
          File.open(file, 'w') { |f| f.write js }

          write_msg
        end
      else
        '' # return no message no javascripts to compile 
      end
    rescue Exception => e
      Octopress.logger.fatal "failed to compile javascripts".red
      raise e
    end
  end
end

