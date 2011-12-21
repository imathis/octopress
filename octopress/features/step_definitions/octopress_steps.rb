Then /the octopress blog files should exist/ do
  check_file_presence(%w(
    .rvmrc
    .rbenv-version
    Gemfile
  ), true)
end
