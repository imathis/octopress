def config_tag(config, key, tag=nil, classname=nil)
  keys = key.split('.')
  options     = keys.map { |k| config = config[k] }.last #reference objects with dot notation
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
    output += " data-#{keys.last}='#{options.join(',')}'"
  else
    output += " data-#{keys.last}='#{options}'"
  end
  output += "></#{tag}>"
end
