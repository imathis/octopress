# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}"
task :new_post, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  title = title.titlecase if Octopress.configuration[:titlecase]
  time = now_in_timezone(Octopress.configuration[:timezone])

  posts_dir = "#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}"
  mkdir_p posts_dir unless Dir.exists? posts_dir
  post_template = Octopress.configuration[:templates][:post]
  filename = "#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}/#{time.strftime('%Y-%m-%d')}-#{title.to_url}.#{post_template.delete(:extension)}"

  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  begin
    post_template[:date] = time.iso8601 if post_template[:date]
    post_template[:title] = title.gsub(/&/,'&amp;') if post_template[:title]
    open(filename, 'w') do |post|
      post.puts post_template.to_yaml.gsub(/^:/m,'')
      post.puts "---"
    end
  rescue
    Raise "Failed to create post: #{filename}"
  end
  puts "Created new post: #{filename}"
end
