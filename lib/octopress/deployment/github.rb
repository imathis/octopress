module Octopress

  class GithubDeployment < Deployment

    def self.setup
      deploy_dir    = '_deploy'

      # If Github deployment is already set up, read the configuration
      if File.exist?("#{deploy_dir}/.git/config")
        cd deploy_dir do
          branch = `git branch -a`.match(/\* ([^\s]+)/)[1]
          repo_url = `git remote -v`.match(/origin\s*(\S+)/)[1]
        end
      else
        # Set up fresh Github deployment
        repo_url = Octopress.get_stdin("Configuring for Github's Pages service (http://pages.github.com).\nPlease enter the read/write url for your repository: ")
        user = repo_url.match(/:([^\/]+)/)[1]
        branch = (repo_url.match(/\/\w+.github.com/).nil?) ? 'gh-pages' : 'master'
        project = (branch == 'gh-pages') ? repo_url.match(/\/([^\.]+)/)[1] : ''

        rm_rf deploy_dir if File.directory?(deploy_dir)
        system "git clone #{repo_url} #{deploy_dir}"
        puts "## Creating a clean #{branch} branch for Github pages deployment"
        cd deploy_dir do
          system "git symbolic-ref HEAD refs/heads/#{branch}"
          system "rm .git/index"
          system "git clean -fdx"
          system "echo 'My Octopress Page is coming soon &hellip;' > index.html"
          system "git add ."
          system "git commit -m \"Octopress init\""
        end
      end
      write_config({
        :method  => 'github',
        :service => branch
      })
      url = "http://#{user}.github.com"
      url += "/#{project}" unless project == ''
      if self.config['url'].include? 'http://yoursite.com'
        # Set site url in
        jekyll_config = IO.read('_config.yml')
        jekyll_config.sub!(/^url:.*$/, "url: #{url}")
        File.open('_config.yml', 'w') do |f|
          f.write jekyll_config
        end
      end

      # Set root configuration based on deployment type
      if branch == 'gh-pages'
        subdir = repo_url.match(/\/([^\.]+)/)[1]
        unless self.config['root'].match("#{subdir}")
          system "rake set_root_dir[#{subdir}]"
        end
      elsif self.config['root'] == '/'
        system "rake set_root_dir[/]"
      end
      puts "\n## Now running `rake deploy` will deploy your generated site to #{url}.\n## If you want to set up a custom domain, follow the guide here: http://octopress.org/docs/deploying/github/#custom_domains\n "
    end

    def self.deploy
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

  end

end

Octopress::Deployment.register_platform('github', Octopress::GithubDeployment)
