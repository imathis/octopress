require 'stringex'

module Octopress
  class Templates
    def self.post(configuration, time, title)
      raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(configuration[:source])
      time = Octopress::Utilities.time_in_timezone(time, configuration[:timezone])
      FileUtils.mkdir_p "#{configuration[:source]}/#{configuration[:posts_dir]}"
      filename = "#{configuration[:source]}/#{configuration[:posts_dir]}/#{time.strftime('%Y-%m-%d')}-#{title.to_url}.#{configuration[:new_post_ext]}"
      overwrite = false
      if(block_given?)
        # Provide caller an opportunity to announce that the file will be
        # created, and inquire about overwriting it it already exists.
        overwrite = yield filename
      end
      raise("File '#{filename}' already exists!") unless(overwrite) if File.exist?(filename)

      File.open(filename, 'w') do |post|
        post.puts "---"
        post.puts "layout: post"
        post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
        post.puts "date: #{time.iso8601}"
        post.puts "comments: true"
        post.puts "external-url: "
        post.puts "categories: "
        post.puts "---"
      end

      return filename
    end
  end
end
