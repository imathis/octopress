module Octopress
  module Commands
    class Scaffold < Command
      SCAFFOLD_DIR = File.join(Octopress.lib_root, "scaffold")
      
      SCAFFOLD_DIRS = %w[
        configs
        includes
        layouts
        lib
        javascripts
        javascripts/lib
        javascripts/modules
        source
        stylesheets
        plugins
      ]

      class << self
        def process(args, options)
          type, plugin_name = process_args(args)

          create_scaffold(type, plugin_name)
        end

        ####################
        # Scaffolding
        ####################
        
        def create_scaffold(type, plugin_name)
          Octopress.logger.info "Scaffolding a new Octopress #{type} in ./#{plugin_name}..."
          FileUtils.mkdir(plugin_name)
          Dir.chdir(plugin_name) do
            FileUtils.mkdir(SCAFFOLD_DIRS)
            FileUtils.mkdir("lib/#{ruby_name(plugin_name)}")
            FileUtils.cp(scaffold_file("Rakefile"), "Rakefile")
            FileUtils.cp(scaffold_file("plugin-name.gemspec"), "#{plugin_name}.gemspec")
            File.open("MANIFEST.yml", "w") { |f| f.write(plugin_yaml(plugin_name)) }
            File.open("lib/#{ruby_name(plugin_name)}.rb", "w") do |f|
              f.puts "class #{plugin_class(plugin_name)}"
              f.puts "end"
            end
            File.open("Gemfile", "w") do |f|
              f.puts "source 'https://rubygems.org'"
              f.puts
              f.puts "gem 'octopress'"
            end
          end
        end

        def ruby_name(plugin_name)
          plugin_name.gsub(/-/, '_')
        end

        def plugin_yaml(plugin_name)
          plugin_data = {
            "name" => plugin_name,
            "slug" => plugin_name,
            "version" => "0.0.1",
            "description" => "TODO- Add your description",
            "summary" => "TODO- Add your summary",
            "homepage" => "TODO- Add your plugin's homepage",
            "authors" => ["YOUR NAME"],
            "emails"  => ["YOUREMAIL@EXAMPLE.COM"]
          }.to_yaml
        end

        def plugin_class(plugin_name)
          plugin_name.split("-").map{ |n| n.capitalize }.join("")
        end

        def scaffold_file(*args)
          File.join(SCAFFOLD_DIR, *args)
        end

        ####################
        # Arguments
        ####################

        def process_args(args)
          validate_args(args)
          type        = args.shift.downcase
          plugin_name = args.join(" ").downcase.gsub(/[\ \-_]+/, '-')
          [type, plugin_name]
        end

        def validate_args(args)
          if args.size < 2 || !%w[plugin theme].include?(args.first)
            Octopress.logger.error "Invalid arguments: type must be one of 'plugin'," +
                                   "'theme', and a plugin name must follow."
            raise ArgumentError
          end
        end
      end
    end
  end
end
