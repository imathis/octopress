module Octopress
  module ConfigHelper

    # Static: Reads a configuration.
    #
    # context   - The current site configuration passed from a Liquid tag's context.
    # key       - The configuration key, eg, url, or twitter.username
    #
    # Returns a the value for the key, eg: site.key

    def config(context, key)
      config = context.registers[:site].config
      key.split('.').map { |k| config = config[k] }.last
    end

    # Static: Reads a configuration.
    #
    # context   - The current site configuration passed from a Liquid tag's context.
    # key       - The configuration key, eg, url, or twitter.username
    # tag       - The name of tag to generate, defaults to 'div'.
    # classname - String for classname(s), default to dasherized key, eg foo.bar is foo-bar.
    #
    # Returns a tag with config values stored as data attributes.

    def config_tag(context, key, tag='div', classname=nil)
      value       = config(context, key)
      key         = key.split('.').last
      classname ||= key.sub(/_/, '-').sub(/\./, '-')
      
      "<#{tag} class='#{classname}' #{config_data(key, value)} ></#{tag}>"
    end

    # Static: Maps values to data attributes
    #
    # key   - A string used to create "data-#{key}" if values is not an object.
    # value - A string or object used to populate values for data attributes.
    #
    # Returns a string of data attributes.

    def config_data(key, value)
      if value.respond_to? 'keys'
        data = ''
        value.each do |k,v|
          data << unless v.nil?
            v = v.join ',' if v.respond_to? 'join'
            v = v.to_json if v.respond_to? 'keys'
            " data-#{k.sub'_','-'}='#{v}'"
          end
        end
        data
      elsif value.respond_to? 'join'
        " data-#{key}='#{value.join(',')}'"
      else
        " data-#{key}='#{value}'"
      end
    end
  end
end
