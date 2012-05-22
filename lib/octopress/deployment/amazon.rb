module Octopress

  class AmazonDeployment < Deployment

    def self.setup
      service = ask("Choose Amazon service", ['aws', 'cloudfront'])
      write_config({
        :method  => 'amazon',
        :service => service
      })
      puts "\n## Now you can deploy to Amazon #{service} with `rake deploy`"
    end

    def self.deploy
      raise "## TODO: Integration of AWS, see https://github.com/imathis/octopress/pull/107"
    end

  end

end

Octopress::Deployment.register_platform('amazon', Octopress::AmazonDeployment)
