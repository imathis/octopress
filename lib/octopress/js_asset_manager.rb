$:.unshift File.expand_path(File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'digest/md5'
require 'stitch-rb'
require 'uglifier'
require 'coffee-script'

module Octopress
  class JSAssetsManager

    attr_reader :config

    def initialize
      configurator   = Octopress::Configuration.new
      @configuration  = configurator.read_configuration
      @js_assets_path = File.expand_path("../../assets/javascripts", File.dirname(__FILE__))
      
      # Read js dependencies from require_js.yml configuration
      @globals = @configuration[:require_js][:globals].collect {|item| Dir.glob("#{@js_assets_path}/#{item}") }.flatten.uniq
      @modules = @configuration[:require_js][:modules].collect {|item| Dir.glob("#{@js_assets_path}/#{item}") }.flatten.uniq

      @template_path = File.expand_path("../../#{@configuration[:source]}", File.dirname(__FILE__))
      @build_path = "/javascripts/build"
    end


    def get_fingerprint
      Digest::MD5.hexdigest(@modules.concat(@globals).uniq.map! do |path|
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
        modules = @modules.delete_if { |f| @globals.include? f }
        js = Stitch::Package.new(:dependencies => @globals, :paths => modules).compile
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

