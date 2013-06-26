module Octopress
  module Commands
    class BuildJekyll < Command
      class << self
        def process(args, options)
          Octopress.configurator.write_configs_for_generation
          puts "## Generating Site with Jekyll - ENV: #{Octopress.env}"
          system "jekyll build #{jekyll_flags}"
          puts unpublished unless unpublished.empty?
          Octopress.configurator.remove_configs_for_generation
        end

        def unpublished
          posts   = Dir.glob("#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}/*.*")
          options = {env: Octopress.env, message: "\nThese posts were not generated:"}
          @unpublished ||= get_unpublished(posts, options)
        end

        def jekyll_flags
          Octopress.env.production? ? "" : "--drafts --trace"
        end
      end
    end
  end
end
