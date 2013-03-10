require 'json'

class ConfigTag < Liquid::Tag
  def initialize(tag_name, options, tokens)
    super
    @options = options.split(' ').map {|i| i.strip }
    @key = @options.first
    @tag = (@options[1] || 'div')
  end

  def render(context)
    config = context.registers[:site].config
    options = @options.first.split('.').map { |k| config = config[k] }.last #reference objects with dot notation
    keyclass = @key.sub(/_/, '-').sub(/\./, '-')
    tag  = "<#{@tag} class='#{keyclass}'"
    options.each do |k,v|
      unless v.nil?
        v = v.join ',' if v.respond_to? 'join'
        v = v.to_json if v.respond_to? 'keys'
        tag += " data-#{k.sub'_','-'}='#{v}'"
      end
    end
    tag += "></#{@tag}>"
    p tag
    tag
  end
end

Liquid::Template.register_tag('config_tag', ConfigTag)
