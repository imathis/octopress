desc "Deploy website via rsync"
task :rsync do
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"
  ssh_key = if(!Octopress.configuration[:ssh_key].nil? && !Octopress.configuration[:ssh_key].empty?)
    "-i #{ENV['HOME']}/.ssh/#{Octopress.configuration[:ssh_key]}"
  else
    ""
  end
  document_root = ensure_trailing_slash(Octopress.configuration[:document_root])
  exit system("rsync -avze 'ssh -p #{Octopress.configuration[:ssh_port]} #{ssh_key}' #{exclude} #{Octopress.configuration[:rsync_args]} #{"--delete-after" unless !Octopress.configuration[:rsync_delete]} #{ensure_trailing_slash(Octopress.configuration[:destination])} #{Octopress.configuration[:ssh_user]}:#{document_root}")
end

def ensure_trailing_slash(val)
  val = "#{val}/" unless(val.end_with?('/'))
  return val
end
