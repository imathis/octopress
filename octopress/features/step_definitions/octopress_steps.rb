Then /an empty project structure should exist/ do
  check_directory_presence(%w(
    _plugins
  ), true)

  check_file_presence(%w(
    .rvmrc
    .rbenv-version
    _config.yml
    Gemfile
    _plugins/octopress.rb
  ), true)
end
