require 'slim'
module Jekyll
  class SlimConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /slim/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      begin
        ::Slim::Template.new{content}.render
      rescue Exception => e
        puts "!!! Slim Error:" + e.message
      end
    end
  end
end
