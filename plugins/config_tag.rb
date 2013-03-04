$:.unshift File.expand_path("../lib", File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'octopress'
require 'json'

class ConfigTag < Liquid::Tag
  def initialize(tag_name, options, tokens)
    super
    config = Octopress::Configuration.read_configuration
    options = options.split(',').map {|i| i.strip }
    options.first.split('.').each { |k| config = config[k] } #reference objects with dot notation
    @config = vars
    @key = options.first.sub(/_/, '-').sub(/\./, '-')
    @tag = (options.last || 'div')
  end

  def render(context)
    tag  = "<#{@tag} class='#{@key}'"
    @config.each do |k,v|
      unless v.nil?
        v = v.join ',' if v.respond_to? 'join'
        v = v.to_json if v.respond_to? 'keys'
        tag += " data-#{k.sub'_','-'}='#{v}'"
      end
    end
    tag += "></#{@tag}>"
  end
end

Liquid::Template.register_tag('config_tag', ConfigTag)
