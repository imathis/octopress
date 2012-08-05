require File.expand_path('guards/guard-jekyll.rb', File.dirname(__FILE__))
require File.expand_path('guards/guard-uglify.rb', File.dirname(__FILE__))

# TODO extract the build from/to directories from _config.yml

group :frontend do
   guard "compass" do
     watch(/sass\/(.*)/)
   end

  guard "uglify",
    :input => Dir["javascripts/*.js" ,"javascripts/custom/*.js"],
    :output => "source/javascripts/octopress.min.js" do
    watch(/^javascripts\/(.*)\.js/)
  end

  guard "jekyll" do
    watch(/^source\/(.*)/)
  end
end

guard "livereload" do
  watch(/^public(.*)/)
end
