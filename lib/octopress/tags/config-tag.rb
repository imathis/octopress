require 'json'

module Octopress
  class ConfigTag < Liquid::Tag
    def initialize(tag_name, options, tokens)
      super
      options = options.split(' ').map {|i| i.strip }
      @key = options.slice!(0)
      @tag = nil
      @classname = nil
      options.each do |option|
        @tag = $1 if option =~ /tag:(\S+)/
        @classname = $1 if option =~ /classname:(\S+)/
      end
    end

    def render(context)
      config_tag(context, @key, @tag, @classname)
    end
  end
end

Liquid::Template.register_tag('config_tag', Octopress::ConfigTag)
