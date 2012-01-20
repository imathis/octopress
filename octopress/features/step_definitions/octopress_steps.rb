Then /a theme-classic project structure should exist/ do

  # Basic project structure
  check_directory_presence(%w(
    _plugins
    _posts
  ), true)

  check_file_presence(%w(
    .rvmrc
    .rbenv-version
    _config.yml
    Gemfile
    _plugins/titlecase.rb
  ), true)

  # Classic theme files
  check_directory_presence(%w(
    _includes
    _layouts
    _sass
    assets
    blog
    images
    javascripts
  ), true)

  check_file_presence(%w(
    blog/archives/index.html
    atom.xml
    favicon.png
    index.html
    _sass/screen.scss
  ), true)

end
