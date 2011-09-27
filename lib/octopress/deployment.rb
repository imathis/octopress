module Deployment
  module ClassMethods

    def method_missing(m, *args, &block)  
      raise "!! No deploy method for platform `#{m.to_s.sub(/setup_/, '')}` found. Aborting."
    end

    def get_deployment_platforms
      platforms = []
      self.methods(true).grep(/deploy_/).each { |m| platforms << m.to_s.sub(/deploy_/, '') }
      platforms.sort!
    end


    def deploy_rsync
      puts "## Deploying website via Rsync"
      ok_failed system("rsync -avze 'ssh -p #{self.config['ssh_port']}' --delete #{self.config['public_dir']}/ #{self.config['ssh_user']}:#{self.config['document_root']}")
    end


    def deploy_github
      puts "## Deploying branch to Github Pages"
      Dir["#{self.config['deploy_dir']}/*"].each { |f| rm_rf(f) }
      system "cp -R #{self.config['destination']}/ #{self.config['deploy_dir']}"
      puts "\n## copying #{self.config['destination']} to #{self.config['deploy_dir']}"
      cd "#{self.config['deploy_dir']}" do
        system "git add ."
        system "git add -u"
        puts "\n## Commiting: Site updated at #{Time.now.utc}"
        message = "Site updated at #{Time.now.utc}"
        system "git commit -m \"#{message}\""
        puts "\n## Pushing generated #{self.config['deploy_dir']} website"
        system "git push origin #{deploy_branch}"
        puts "\n## Github Pages deploy complete"
      end
    end


    def deploy_heruku
      puts "## Deploying Octopress to Heroku"
      system "git push heroku master"
    end


    def deploy_amazon
      raise "## TODO: Integration of AWS, see https://github.com/imathis/octopress/pull/107"
    end

  end
end
