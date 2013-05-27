desc "Remove generated files (#{Octopress.configuration[:destination]} directory)."
task :clobber do
  rm_rf [Octopress.configuration[:destination]]
  puts "## Cleaned generated site in #{Octopress.configuration[:destination]} ##"
end
