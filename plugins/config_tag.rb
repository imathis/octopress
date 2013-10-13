require 'json'

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
    config_tag(context.registers[:site].config, @key, @tag, @classname)
  end
end

def config_tag(config, key, tag=nil, classname=nil)
  options     = key.split('.').map { |k| config[k] }.last #reference objects with dot notation
  tag       ||= 'div'
  classname ||= key.sub(/_/, '-').sub(/\./, '-')
  output      = "<#{tag} class='#{classname}'"

  if options.respond_to? 'keys'
    options.each do |k,v|
      unless v.nil?
        v = v.join ',' if v.respond_to? 'join'
        v = v.to_json if v.respond_to? 'keys'
        output += " data-#{k.sub'_','-'}='#{v}'"
      end
    end
  elsif options.respond_to? 'join'
    output += " data-value='#{config[key].join(',')}'"
  else
    output += " data-value='#{config[key]}'"
  end
  output += "></#{tag}>"
end

Liquid::Template.register_tag('config_tag', ConfigTag)

