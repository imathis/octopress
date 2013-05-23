# Monkeypatch for Jekyll
# Introduce distinction between preview/productive site generation
# so posts with YAML attribute `published: false` can be previewed
# on localhost without being published to the productive environment.

module Jekyll

  class Site
    # Read all the files in <source>/<dir>/_posts and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_posts(dir)
      entries = get_entries(dir, '_posts')

      # first pass processes, but does not yet render post content
      entries.each do |f|
        if Post.valid?(f)
          post = Post.new(self, self.source, dir, f)

          # Monkeypatch:
          # On preview environment (localhost), publish all posts
          if ENV.has_key?('OCTOPRESS_ENV') && ENV['OCTOPRESS_ENV'] == 'preview' && post.data.has_key?('published') && post.data['published'] == false
            post.published = true
            # Set preview mode flag (if necessary), `rake generate` will check for it
            # to prevent pushing preview posts to productive environment
            File.open(".preview-mode", "w") {}
          end

          if post.published && (self.future || post.date <= self.time)
            aggregate_post_info(post)
          end
        end
      end
    end
  end
end
