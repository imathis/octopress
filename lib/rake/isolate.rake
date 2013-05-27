# usage rake isolate[my-post]
desc "Move all other posts than the one currently being worked on to a temporary stash location (stash) so regenerating the site happens much more quickly."
task :isolate, :filename do |t, args|
  if args.filename
    filename = args.filename
  else
    filename = get_stdin("Enter a post file name: ")
  end
  FileUtils.mkdir(full_stash_dir) unless File.exist?(full_stash_dir)
  Dir.glob("#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}/*.*") do |post|
    FileUtils.mv post, full_stash_dir unless post.include?(filename)
  end
end
