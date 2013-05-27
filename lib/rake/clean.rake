desc "Clean out caches: .pygments-cache, .gist-cache, .sass-cache, and Compass-generated files."
task :clean do
  rm_rf [".pygments-cache", ".gist-cache", File.join(Octopress.configuration[:source], "javascripts", "build")]
  if Dir.exists? "stylesheets"
    system "compass clean"
    puts "## Cleaned Compass-generated files, and various caches ##"
  end
end
