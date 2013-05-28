# encoding: utf-8

$:.unshift File.expand_path("lib", File.dirname(__FILE__)) # For use/testing when no gem is installed
require 'octopress'
require 'tzinfo'

### Configuring Octopress:
###   Under config/ you will find:
###       site.yml, deploy.yml
###   Here you can override Octopress's default configurations or add your own.
###   This Rakefile uses those config settings to do what it does.
###   Please do not change anything below if you want help --
###   otherwise, you're on your own ;-)

#
# Run tests for Octopress module, found in lib/.
#
require 'rspec/core/rake_task'
desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./lib/spec{,/*/**}/*_spec.rb"
end

task :test do
  sh "bundle exec rake spec"
  sh "bundle exec rake install['classic-theme']"
  sh "bundle exec rake install['video-tag']"
  sh "bundle exec rake install['adn-timeline']"
  sh "bundle exec rake generate"
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

def now_in_timezone(timezone)
  time = Time.now
  unless timezone.nil? || timezone.empty? || timezone == 'local'
    tz = TZInfo::Timezone.get(timezone) #setup Timezone object
    adjusted_time = tz.utc_to_local(time.utc) #time object without correct offset
    #time object with correct offset
    time = Time.new(
      adjusted_time.year,
      adjusted_time.month,
      adjusted_time.day,
      adjusted_time.hour,
      adjusted_time.min,
      adjusted_time.sec,
      tz.period_for_utc(time.utc).utc_total_offset())
    #convert offset to utc instead of just ±0 if that was specified
    if ['utc','zulu','universal','uct','gmt','gmt0','gmt+0','gmt-0'].include? timezone.downcase
      time = time.utc
    end
  end
  time
end

def get_unpublished(posts, options={})
  result = ""
  message = options[:message] || "These Posts will not be published:"
  posts.sort.each do |post|
    file = File.read(post)
    data = YAML.load file.match(/(^-{3}\n)(.+?)(\n-{3})/m)[2]

    if options[:env] == 'production'
      future = Time.now < Time.parse(data['date'].to_s) ? "future date: #{data['date']}" : false
    end
    draft = data['published'] == false ? 'published: false' : false
    result << "- #{data['title']} (#{draft or future})\n" if draft or future
  end
  result = "#{message}\n" + result unless result.empty?
  result
end

Octopress::Rake.init!(self)
