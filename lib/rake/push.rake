desc "deploy public directory to github pages"
multitask :push do
  if File.directory?(Octopress.configuration[:deploy_dir])
    puts "## Deploying branch to GitHub Pages "
    (Dir["#{Octopress.configuration[:deploy_dir]}/*"]).each { |f| rm_rf(f) }
    puts "Attempting pull, to sync local deployment repository"
    cd "#{Octopress.configuration[:deploy_dir]}" do
      system "git pull origin #{Octopress.configuration[:deploy_branch]}"
    end
    puts "\n## copying #{Octopress.configuration[:destination]} to #{Octopress.configuration[:deploy_dir]}"
    cp_r "#{Octopress.configuration[:destination]}/.", Octopress.configuration[:deploy_dir]
    cd "#{Octopress.configuration[:deploy_dir]}" do
      File.new(".nojekyll", "w").close
      system "git add -A"
      message = "Site updated at #{Time.now.utc}"
      puts "\n## Committing: #{message}"
      system "git commit -m \"#{message}\""
      puts "\n## Pushing generated #{Octopress.configuration[:deploy_dir]} website"
      if system "git push origin #{Octopress.configuration[:deploy_branch]}"
        puts "\n## GitHub Pages deploy complete"
      else
        remote = `git remote -v`
        repo_url = case remote
                   when /(http[^\s]+)/
                     $1
                   when /(git@[^\s]+)/
                     $1
                   else
                     ""
                   end
        raise "\n## Octopress could not push to #{repo_url}"
      end
    end
  else
    puts "This project isn't configured for deploying to GitHub Pages\nPlease run `rake setup_github_pages[your-deployment-repo-url]`."
  end
end
