require 'thor'
require 'yaml'
require 'stringex'

module Octopress
  class CLI < Thor
    include Thor::Actions
    include FileUtils

    ## -- Misc Configs -- ##
    DEFAULT_CONFIG = {
      "public_dir"      => "public",    # compiled site directory
      "source_dir"      => "source",    # source file directory
      "blog_index_dir"  => 'source',    # directory for your blog's index page (if you put your index in source/blog/index.html, set this to 'source/blog')
      "deploy_dir"      => "_deploy",   # deploy directory (for Github pages deployment)
      "stash_dir"       => "_stash",    # directory to stash posts for speedy generation
      "posts_dir"       => "_posts",    # directory for blog files
      "themes_dir"      => ".themes",   # directory for blog files
      "new_post_ext"    => "markdown",  # default new post file extension when using the new_post task
      "new_page_ext"    => "markdown",  # default new page file extension when using the new_page task
      "server_port"     => "4000"      # port for preview server eg. localhost:4000
    }

    default_task :help

    desc 'help [task]', 'Explain available tasks or one specific task'
    def help(*args)
      puts "http://octopress.org/docs/"
    end

    desc 'install [theme]', 'Install a theme for Octopres. Defaults to classic theme.'
    def install(theme = 'classic')
      puts "## Copying #{theme} theme into ./#{source_dir} and ./sass"
      mkdir_p source_dir
      cp_r "#{themes_dir}/#{theme}/source/.", source_dir
      mkdir_p "sass"
      cp_r "#{themes_dir}/#{theme}/sass/.", "sass"
      mkdir_p "#{source_dir}/#{posts_dir}"
      mkdir_p public_dir
    end

    desc 'new_post "title"', "Begin a new post in source/posts"
    def new_post(title = "new-post")
      raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
      require './plugins/titlecase.rb'
      mkdir_p "#{source_dir}/#{posts_dir}"
      filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
      puts "Creating new post: #{filename}"
      open(filename, 'w') do |post|
        system "mkdir -p #{source_dir}/#{posts_dir}/";
        post.puts "---"
        post.puts "layout: post"
        post.puts "title: \"#{title.gsub(/&/,'&amp;').titlecase}\""
        post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
        post.puts "comments: true"
        post.puts "categories: "
        post.puts "---"
      end
    end

    desc "new_page", "Create a new page in source/(filename)/index.markdown"
    def new_page(filename = "new-page")
      raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
      page_dir = source_dir
      if filename =~ /(^.+\/)?([\w_-]+)(\.)?(.+)?/
        page_dir += $4 ? "/#{$1}" : "/#{$1}#{$2}/"
        name = $4 ? $2 : "index"
        extension = $4 || "#{new_page_ext}"
        filename = "#{name}.#{extension}"
        mkdir_p page_dir
        file = page_dir + filename
        if File.exist?(file)
          abort("thor aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
        end
        puts "Creating new page: #{file}"
        open(file, 'w') do |page|
          page.puts "---"
          page.puts "layout: page"
          page.puts "title: \"#{$2.gsub(/[-_]/, ' ')}\""
          page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
          page.puts "comments: true"
          page.puts "sharing: true"
          page.puts "footer: true"
          page.puts "---"
        end
      else
        puts "Syntax error: #{filename} contains unsupported characters"
      end
    end

    private
    def method_missing(method_name, *args)
      if config.key? method_name.to_s
        config[method_name.to_s]
      else
        super
      end
    end
    def config
      @config ||= DEFAULT_CONFIG.merge(YAML::load(File.open('_config.yml'))||{})
    end
  end
end
