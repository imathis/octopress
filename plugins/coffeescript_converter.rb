# Author: Devin Weaver
# Allows .coffee files to be converted to .js files.
# Original code from [phaer](https://gist.github.com/959938) 
# To process the file you must have YAML front matter in the file:
# ---
# layout: nil
# ---
module Jekyll
  require 'coffee-script'
  class CoffeeScriptConverter < Converter
    safe true
    priority :normal

    def matches(ext)
      ext =~ /coffee/i
    end

    def output_ext(ext)
      ".js"
    end

    def convert(content)
      begin
        CoffeeScript.compile content
      rescue StandardError => e
        puts "CoffeeScript error:" + e.message
      end
    end
  end
end
