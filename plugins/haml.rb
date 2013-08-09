require 'colorator'
begin
  require 'haml'
rescue LoadError
end

module Jekyll
  class HamlConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /haml/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      begin
        engine = Haml::Engine.new(content)
        engine.render
      rescue StandardError => e
        $stderr.puts ("!!! HAML Error: " + e.message).red
      end
    end
  end
end
