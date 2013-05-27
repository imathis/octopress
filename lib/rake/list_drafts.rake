# usage rake list_posts or rake list_posts[pub|unpub]
desc "List all unpublished/draft posts"
task :list_drafts do
  posts = Dir.glob("#{Octopress.configuration[:source]}/#{Octopress.configuration[:posts_dir]}/*.*")
  unpublished = get_unpublished(posts)
  puts unpublished.empty? ? "There are no posts currently in draft" : unpublished
end
