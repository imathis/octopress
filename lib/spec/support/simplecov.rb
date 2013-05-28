using_coverage = ENV['USING_COVERAGE'] || ''
if(using_coverage == '')
  using_coverage = false
else
  using_coverage = (using_coverage.to_i != 0)
end

if(using_coverage)
  puts "Enabling SimpleCov..."
  BASE_DIR = File.expand_path(File.join(__FILE__, '../../../..'))
  def expand_path(p)
    return File.expand_path(File.join(BASE_DIR, p))
  end
  CORE_PATHS=[
    expand_path("lib/octopress.rb"),
    expand_path("lib/octopress"),
  ]
  RAKE_PATHS=[
    expand_path("Rakefile"),
    expand_path("lib/rake"),
  ]
  GUARD_PATHS=[
    expand_path("lib/guard"),
  ]
  MISC_PATHS=[
    expand_path("config.rb"),
    expand_path("config.ru"),
    expand_path("lib/console"),
  ]
  TEST_PATHS=[
    expand_path("lib/spec"),
  ]

  require 'simplecov'
  SimpleCov.start do
    add_group "Core" do |src_file|
      CORE_PATHS.map { |p| src_file.filename.start_with?(p) }.select { |tf| tf }.count != 0
    end
    add_group "Rake" do |src_file|
      RAKE_PATHS.map { |p| src_file.filename.start_with?(p) }.select { |tf| tf }.count != 0
    end
    add_group "Guard" do |src_file|
      GUARD_PATHS.map { |p| src_file.filename.start_with?(p) }.select { |tf| tf }.count != 0
    end
    add_group "Misc" do |src_file|
      MISC_PATHS.map { |p| src_file.filename.start_with?(p) }.select { |tf| tf }.count != 0
    end
    add_group "Test" do |src_file|
      TEST_PATHS.map { |p| src_file.filename.start_with?(p) }.select { |tf| tf }.count != 0
    end
  end
end
