namespace :hygiene do
  desc "Tidy up whitespace in all non-vendored files."
  task :whitespace do
    FileList[
      "lib/**/*.{rb,rake,ru,feature,yml,md,markdown}",
      "{Gemfile,Rakefile,*.md,*.markdown,*.ru,*.rb,.powrc,.rspec,.travis.yml,.slugignore,.gitignore,.gitattributes,.editorconfig}"
    ].each do |fname|
      next if(File.directory?(fname))
      printf "Processing #{fname}..."
      raw_contents = File.read(fname)
      new_contents = raw_contents.
        rstrip.        # Strip ALL trailing newlines.
        split(/\n/).   # Now look at it per-line...
        map(&:rstrip). # ... strip trailing WS per-line.
        join("\n") +   # Now put it back together into one string.
        "\n"           # And ensure EXACTLY one trailing newline.
      if(raw_contents != new_contents)
        printf " Cleaned!"
        File.open(fname, "w") { |fh| fh.write(new_contents) }
      end
      printf "\n"
    end
  end

  desc "Run the Rubocop static analyzer against Cthulhu."
  task :rubocop do
    sh 'rubocop -d Rakefile Gemfile lib'
  end
end
