# Polyfill for __method__ for Ruby versions older than 1.9
__method__ ||= lambda do
  caller[0] =~ /`([^']*)'/ and $1
end.call    


module SetupDeployment
  module ClassMethods

    def set_deployment_config(deploy_config)
      jekyll_config = IO.read('_config.yml')
      jekyll_config.sub!(/^deploy_config:.*$/, "deploy_config: #{deploy_config}")
      File.open('_config.yml', 'w') { |f| f.write jekyll_config }

      puts "## Deployment configured in #{deploy_config}.yml."
    end


    def setup_rsync
      deploy_config = __method__.to_s.sub('setup_', '')

      ssh_user = ask("SSH user", "user@domain.com")
      document_root = ask("Document root", "~/website.com/")

      File.open("#{deploy_config}.yml", 'w') do |f|
        f.write <<-CONFIG
ssh_user: "#{ssh_user}"
document_root: "#{document_root}"
        CONFIG
      end
      set_deployment_config(deploy_config)
      puts "## Now you can deploy to #{ssh_user}:#{document_root} with `rake deploy`. Be sure your public key is listed in your server's ~/.ssh/authorized_keys file."
    end


    def setup_github
      deploy_config = __method__.to_s.sub('setup_', '')
      deploy_dir    = '_deploy'      

      branch = ask("Branch name for deployment", "gh-pages")
      File.open("#{deploy_config}.yml", 'w') do |f|
        f.write <<-CONFIG
deploy_branch: "#{branch}"
deploy_dir: "#{deploy_dir}"
        CONFIG
      end
      puts "## Creating a clean #{branch} branch for Github pages deployment"
      cd "#{deploy_dir}" do
        system "git symbolic-ref HEAD refs/heads/#{branch}"
        system "rm .git/index"
        system "git clean -fdx"
        system "echo 'My Octopress Page is coming soon &hellip;' > index.html"
        system "git add ."
        system "git add -f #{}" if is_heroku
        system "git commit -m 'Octopress init'"
      end
      set_deployment_config(deploy_config)
      puts "## Now you can deploy to the #{branch} branch with `rake deploy`"
    end


    def setup_heruku
      deploy_config = __method__.to_s.sub('setup_', '')
      branch = ask("Branch name for deployment", "master")
      File.open("#{deploy_config}.yml", 'w') { |f| f.write "deploy_branch: #{branch}" }
      set_deployment_config(deploy_config)
    end


    def setup_amazon
      deploy_config = __method__.to_s.sub('setup_', '')
      service = ask("Choose Amazon service", ['aws', 'cloudfront'])

      File.open("#{deploy_config}.yml", 'w') { |f| f.write "service: #{service}" }
      set_deployment_config(deploy_config)
      puts "## Now you can deploy to #{service} with `rake deploy`"
    end

  end
end