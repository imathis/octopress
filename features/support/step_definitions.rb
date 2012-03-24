Before do
  @dir = File.join(File.expand_path('../../../', __FILE__), 'tmp', 'octopress')
  FileUtils.rm_rf(@dir) rescue nil
  ::FileUtils.mkdir_p @dir
  Dir.chdir @dir
end

After do
  FileUtils.rm_rf @dir
end

When /^I install octopress$/ do
  run_command('rake install')
end

Then /^I should have created an octopress skeleton$/ do
  %w(sass source public).each do |folder|
    file = File.join(@dir, folder)
    File.directory?(file).should be_true
  end
end

When /^I create a new post$/ do
  posts.should be_empty
  run_command('rake new_post')
end

Then /^I should see that post$/ do
  posts.should_not be_empty
end

When /^I create a new page$/ do
  File.exist?(test_page).should be_false
  run_command('rake new_page')
end

Then /^I should see that page$/ do
  File.exist?(test_page).should be_true
end