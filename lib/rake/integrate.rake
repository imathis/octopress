desc "Move all stashed posts back into the posts directory, ready for site generation."
task :integrate do
  FileUtils.mv Dir.glob("#{full_stash_dir}/*.*"), "#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}/"
end
