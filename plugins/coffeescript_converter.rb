# Author: Devin Weaver
# Allows .coffee files to be converted to .js files.
# Caveat: You have to escape the string literal "</script>" or RubyPants will
# start filtering. Do so with "<"+"/"+"script>"
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
        content = CoffeeScript.compile content
        # OctoPress will pass all content though a RubyPants filter.
        # RubyPants will conver quotes to smart quotes.
        # RubyPants will ignore any convertions when content is surrounded by HTML <script> tags
        # This adds HTML <script> tags to the output to prevent RubyPants from processing the JavaScript code.
        <<EOS
// <script> To prevent OctoPress filtering through RubyPants ([See Gist][1])
#{content}
// [1]: https://gist.github.com/2925325
// </script>
EOS
      rescue StandardError => e
        puts "CoffeeScript error:" + e.message
      end
    end
  end
end
