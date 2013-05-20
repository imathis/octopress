module Octopress
  module Commands
    class BuildJekyll < Command
      class << self
        def run(args, options)
          build_jekyll
          print_unpublished(options)
        end

        def build_jekyll
          Octopress.logger.info "## Building Site with Jekyll - ENV: #{Octopress.env}"
          system "jekyll build #{"--drafts --trace" unless Octopress.env == 'production'}"
        end

        def print_unpublished(options)
          unpublished = get_unpublished
            Dir.glob("#{options[:source]}/#{options[:posts_dir]}/*.*"),
            {
              env: Octopress.env,
              message: "\nThese posts were not generated:"
            }
          Octopress.logger.info(unpublished) unless unpublished.empty?
        end

        def get_unpublished(posts, options={})
          result = ""
          message = options[:message] || "These Posts will not be published:"
          posts.sort.each do |post|
            result << determine_published_status(read_yaml(post), options)
          end
          result = "#{message}\n" + result unless result.empty?
          result
        end

        private
        def read_yaml(filename)
          file = File.read(filename)
          YAML.safe_load(file.match(/(^-{3}\n)(.+?)(\n-{3})/m)[2])
        end

        def determine_published_status(data, options)
          if options[:env] == 'production'
            future = Time.now < Time.parse(data['date'].to_s) ? "future date: #{data['date']}" : false
          end
          draft = data['published'] == false ? 'published: false' : false
          "- #{data['title']} (#{draft or future})\n" if draft or future
        end
      end
    end
  end
end
