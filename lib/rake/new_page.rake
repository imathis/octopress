# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page/index.html")
desc "Create a new page in #{Octopress.configuration[:source]}/(filename)/index.#{Octopress.configuration[:new_page_ext]}"
task :new_page, :filename do |t, args|
  args.with_defaults(:filename => 'new-page')

  if args.filename.downcase =~ /(^.+\/)?(.+?)\/?$/
    page_dir = [Octopress.configuration[:source]]
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    title = filename

    if extension.nil?
      page_dir << filename
      filename = "index"
    end

    page_dir = page_dir.map! { |d| d = d.to_url }.join('/')                # Sanitize path
    filename = filename.downcase.to_url

    page_template = Octopress.configuration[:templates][:page]
    ext = page_template.delete :extension

    extension ||= ext

    file = "#{page_dir}/#{filename}.#{extension}"

    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end

    mkdir_p page_dir unless Dir.exists? page_dir

    page_template[:date] = time.iso8601 if page_template[:date]
    page_template[:title] = title.gsub(/&/,'&amp;') if page_template[:title]

    begin
      time = now_in_timezone(Octopress.configuration[:timezone])
      open(file, 'w') do |page|
        page.puts page_template.to_yaml.gsub(/^:/m,'')
        page.puts "---"
      end
    rescue
      raise "Failed to create page: #{filename}"
    end
    puts "New page created: #{file}"
  else
    puts "Syntax error: #{args.filename} contains unsupported characters"
  end
end
