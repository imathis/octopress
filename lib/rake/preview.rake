desc "preview the site in a web browser."
task :preview do
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." if Octopress.configuration[:source].nil? || !File.directory?(Octopress.configuration[:source])
  ENV['OCTOPRESS_ENV'] ||= 'development'
  Rake::Task["generate"].execute
  guardPid = Process.spawn("guard --guardfile #{Octopress.root}/lib/octopress/guardfile")
  puts "Starting Rack, serving to http://#{Octopress.configuration[:server_host]}:#{Octopress.configuration[:port]}"
  rackupPid = Process.spawn("rackup --host #{Octopress.configuration[:server_host]} --port #{Octopress.configuration[:port]}")

  trap("INT") {
    [guardPid, rackupPid].each { |pid| Process.kill(3, pid) rescue Errno::ESRCH }
    exit 0
  }

  [guardPid, rackupPid].each { |pid| Process.wait(pid) }
end
