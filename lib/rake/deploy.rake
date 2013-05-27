desc "Default deploy task"
task :deploy do
  Rake::Task["#{Octopress.configuration[:deploy_default]}"].execute
end
