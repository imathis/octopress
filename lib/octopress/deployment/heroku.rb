module Octopress

  class HerokuDeployment < Deployment

    def self.setup
      if `git remote -v`.match(/heroku/).nil?
        if `gem list heroku`.match(/heroku/).nil?
          puts "\nIf you don't have a Heroku Account, create one here: http://heroku.com/signup"
          puts "Install the gem: `gem install heroku`"
        end
        puts "Run `heroku create [subdomain]` to set up a new app on Heroku."
      end
      gitignore = IO.read('.gitignore')
      gitignore.sub!(/^public.*$/, "")
      File.open('.gitignore', 'w') do |f|
        f.write gitignore
      end
      system "git add public" if File.directory?('public')
      write_config({
        :method => 'github',
        :service => branch
      })
      puts "Configuration written to deploy.yml"
      puts "\n Commmit then deploy to Heroku using `git push heroku master`"
    end

    def self.deploy
      puts "## Deploying Octopress to Heroku"
      system "git push heroku master"
    end

  end

end

Octopress::Deployment.register_platform('heroku', Octopress::HerokuDeployment)
