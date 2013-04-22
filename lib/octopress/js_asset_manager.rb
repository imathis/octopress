$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'digest/md5'
require 'stitch-rb'
require 'uglifier'
require 'coffee-script'

module Octopress
  class JSAssetsManager

    attr_reader :config

    def initialize
      @js_assets_path = File.expand_path("../../assets/javascripts", File.dirname(__FILE__))

      unless Octopress.configuration.has_key? :require_js
        abort "No :require_js key in configuration. Cannot proceed.".red
      end
      unless Octopress.configuration[:require_js].has_key? :lib
        abort "No :lib key in :require_js configuration. Cannot proceed.".red
      end
      unless Octopress.configuration[:require_js].has_key? :modules
        abort "No :modules key in :require_js configuration. Cannot proceed.".red
      end

      # Read js dependencies from require_js.yml configuration
      @lib = Octopress.configuration[:require_js][:lib].collect {|item| Dir.glob("#{@js_assets_path}/#{item}") }.flatten.uniq
      @modules = Octopress.configuration[:require_js][:modules].collect {|item| "#{@js_assets_path}/#{item}" }.flatten.uniq
      @module_files = @modules.collect {|item| Dir[item+'/**/*'] }.flatten.uniq

      @template_path = File.expand_path("../../#{Octopress.configuration[:source]}", File.dirname(__FILE__))
      @build_path = "/javascripts/build"
    end


    def get_fingerprint
      Digest::MD5.hexdigest(@module_files.concat(@lib).uniq.map! do |path|
        "#{File.mtime(path).to_i}"
      end.join)
    end

    def url
      fingerprint = @fingerprint || get_fingerprint
      Octopress.env == 'production' ?  "#{@build_path}/all-#{fingerprint}.js" : "#{@build_path}/all.js"
    end

    def compile
      @fingerprint = get_fingerprint

      filename = url
      file = "#{@template_path + filename}"

      if File.exists?(file) and File.open(file) {|f| f.readline} =~ /#{@fingerprint}/
        false
      else
        js = Stitch::Package.new(:dependencies => @lib, :paths => @modules).compile
        js = "/* Octopress fingerprint: #{@fingerprint} */\n" + js
        js = Uglifier.new.compile js if Octopress.env == 'production'
        write_path = "#{@template_path}/#{@build_path}"

        (Dir["#{write_path}/*"]).each { |f| FileUtils.rm_rf(f) }
        FileUtils.mkdir_p write_path
        File.open(file, 'w') { |f| f.write js }

        "Javascripts compiled to #{filename}."
      end
    end
  end
end

