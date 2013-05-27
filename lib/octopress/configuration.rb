require 'yaml'

module Octopress
  def self.configurator(root_dir = Octopress::Configuration::DEFAULT_CONFIG_DIR)
    @configurator ||= Configuration.new(root_dir)
  end

  def self.configuration
    @configuration ||= self.configurator.read_configuration
  end

  def self.clear_config!
    @configurator = nil
    @configuration = nil
  end

  class Configuration
    DEFAULT_CONFIG_DIR = File.join(Octopress.root, 'config')
    attr_accessor :config_directory

    def initialize(config_dir = DEFAULT_CONFIG_DIR)
      self.config_directory = config_dir
    end

    def config_dir(*subdirs)
      File.expand_path(File.join(*subdirs), self.config_directory)
    end

    # Static: Reads the configuration of the specified file
    #
    # path - the String path to the configuration file, relative to ./_config
    #
    # Returns a Hash of the items in the configuration file (symbol keys)
    def read_config(path)
      full_path = self.config_dir(path)
      if File.exists? full_path
        begin
          configs = YAML.load(File.open(full_path))
          if configs.nil?
            Hash.new
          else
            configs.to_symbol_keys
          end
        rescue => e
          puts "Error reading configuration file '#{full_path}':"
          puts e.message, e.backtrace
          exit(-1)
        end
      else
        raise ArgumentError, "File at '#{full_path}' does not exist."
      end
    end

    # Static: Concatenates javacript lib instead of merging (the default behavior for other configs)
    # 
    # current - current configuration hash
    # new     - hash which hasn't yet been merged
    #
    # Returns a concatenated array of javascript lib configurations

    def add_js_lib(current, new)
      begin
        new_lib = new[:require_js][:lib]
        new_lib = [new_lib] unless new_lib.kind_of?(Array)
        new[:require_js][:lib] = current[:require_js][:lib].concat new_lib
      rescue
      end
      new
    end

    # Static: Writes the contents of a set of configurations to a path in the config directory
    #
    # path - the String path to the configuration file, relative to ./_config
    # obj  - the object to be dumped into the specified file in YAML form
    #
    # Returns the Hash for the configuration file.
    def write_config(path, obj)
      YAML.dump(obj.to_string_keys, File.open(self.config_dir(path), 'w'))
    end

    # Static: Reads all the configuration files into one hash
    #
    # Returns a Hash of all the configuration files, with each key being a symbol
    def read_configuration
      configs = DEFAULTS.dup
      Dir.glob(self.config_dir('defaults', '**', '*.yml')) do |filename|
        file_yaml = read_config(filename)
        unless file_yaml.nil?
          file_yaml = add_js_lib(configs, file_yaml)
          configs = configs.deep_merge(file_yaml)
        end
      end
      Dir.glob(self.config_dir('*.yml')) do |filename|
        file_yaml = read_config(filename)
        unless file_yaml.nil?
          file_yaml = add_js_lib(configs, file_yaml)
          configs = configs.deep_merge(file_yaml)
        end
      end

      configs.to_symbol_keys
    end

    # Static: Writes configuration files necessary for generation of the Jekyll site
    #
    # Returns a Hash of the items which were written to the Jekyll configuration file
    def write_configs_for_generation
      jekyll_configs = {}

      Dir.chdir(Octopress.root) do
        File.open("_config.yml", "w") do |f|
          jekyll_configs = Octopress.configuration.to_string_keys.to_yaml :canonical => false
          f.write(jekyll_configs)
        end
      end

      jekyll_configs
    end

    # Static: Removes configuration files required for site generation
    #
    # Returns the number of files deleted
    def remove_configs_for_generation
      Dir.chdir(Octopress.root) do
        File.unlink("_config.yml")
      end
    end

    PostTemplate = YAML.load <<-YAML
      extension: markdown
      layout: post
      title: true
      date: true
      categories:
    YAML

    LinkPostTemplate = YAML.load <<-YAML
      extension: markdown
      layout: post
      title: true
      date: true
      external-url:
      categories:
    YAML

    PageTemplate = YAML.load <<-YAML
      extension: html
      layout: page
      title: true
      date: false
    YAML

    DEFAULTS = {
      url: 'http://yoursite.com',
      title: 'My Octopress Blog',
      subtitle: 'A blogging framework for hackers.',
      author: 'Your Name',
      description: '',

      # If publishing to a subdirectory as in http://site.com/project set 'root: /project'
      root:         '/',
      permalink:    '/:year/:month/:day/:title/',
      source:       'source',          # source file directory
      destination:  'public',          # compiled site directory
      plugins:      ['lib/octopress/liquid_helpers', 'lib/octopress/filters', 'lib/octopress/tags', 'lib/octopress/generators', 'plugins'],
      code_dir:     'downloads/code',
      category_dir: 'categories',
      include: ['.htaccess'],

      markdown:     'redcarpet',
      redcarpet: {
        extensions: [
          'no_intra_emphasis',
          'strikethrough',
          'autolink',
          'superscript',
          'smart',
          'footnotes',
        ]
      },

      # Default date format is "ordinal" (resulting in "July 22nd 2007")
      # You can customize the format as defined in
      # http://www.ruby-doc.org/core-1.9.2/Time.html#method-i-strftime
      # Additionally, %o will give you the ordinal representation of the day

      date_format:    'ordinal',
      env:            'production',    # affects asset compilation
      post_index_dir: 'source',        # directory for your posts index page (if you put your index in source/blog/index.html, set this to 'source/blog')
      stash_dir:      '_stash',        # directory to stash posts for speedy generation
      posts_dir:      '_posts',        # directory for blog files
      deploy_dir:     '_deploy',       # directory whose contents are to be deployed
      new_post_ext:   'markdown',      # default new post file extension when using the new_post task
      new_page_ext:   'markdown',      # default new page file extension when using the new_page task
      titlecase:      true,            # Converts page and post titles to titlecase
      server_host:    '0.0.0.0',       # host ip address for preview server
      port:           4000,            # port for preview server eg. localhost:4000
      timezone:       'local',         # default time and date used to local timezone. Vew supported timezones (under TZ column): http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
      #paginate_path: page/:num,       # default path for pagination, eg. page/2/
      paginate:       10,              # Posts per page on the blog index

      # Templates - these can be overridden in site.yml and themes can ship with their own default templates.

      templates: {
        post: PostTemplate,
        linkpost: LinkPostTemplate,
        page: PageTemplate,
      },


      # Feed settings

      feed: {
        limit:        20,            # Maximum number of posts to include in the feed
        url:          '/feed/',      # Link to templates feed
        email_url:    false,         # Link to email subscription page (if you offer it)
        categories:   false,         # Generate individual feeds for each post category (potential performance hit)
        author_email: false,         # Author email address to the feed
      },

      # Asset configuration

      # Asset configuration

      # Javascript assets stored in javascripts/lib and javascripts/modules
      # Are wrapped with CommonJS functions, combined, uglified and fingerprinted
      # Supported files: .js, .coffee, .mustache, .eco, .tmpl

      # Dependiences from lib are added first as globals
      require_js: {

        # Dependiences are added first as globals
        lib: ['jquery-1.9.1.js', 'jquery.cookie.js'],

        # Modules are wrapped with CommonJS functions and must be
        # Example:
        #   for file: assets/javascripts/modules/some-plugin/awesome.js
        #   require like: var awesome = require('some-plugin/awesome')
        modules: ['modules']
      }
    }
  end
end

