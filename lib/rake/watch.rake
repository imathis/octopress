desc "Watch the site and regenerate when it changes"
task :watch do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." if Octopress.configuration[:source].nil? || !File.directory?(Octopress.configuration[:source])
  puts "Starting to watch source with Jekyll and Compass."
  guardPid = Process.spawn("guard --guardfile #{Octopress.root}/lib/octopress/guardfile")
  trap("INT") {
    Process.kill(9, guardPid) rescue Errno::ESRCH
    exit 0
  }
  Process.wait guardPid
end
