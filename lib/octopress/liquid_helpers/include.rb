module Octopress
  module IncludeHelper
    include Conditional

    def render_include(file, context)
      tag = Jekyll::Tags::IncludeTag.new('', file, [])
      tag.render(context)
    end

    def exists(file, context)
      base = Pathname.new(context.registers[:site].source || 'source').expand_path
      File.exists? File.join(base, "_includes", file)
    end

    def get_files(files, context)
      files = files.split("||").map do |file|
        file = file.strip
        context[file].nil? ? file : context[file]
      end
    end

    def get_include(files, context)
      files = get_files(files, context)
      files.each_with_index do |f, i|
        if exists(f, context)
          return f
        elsif i == files.size - 1
          return f == 'none' ? false : f
        end
      end
    end
  end
end
