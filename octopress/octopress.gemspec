# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','octopress','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'octopress'
  s.version = Octopress::VERSION
  s.author = 'Brandon Mathis'
  s.email = 'brandon@imathis.com'
  s.homepage = 'http://octopress.org'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Octopress is a framework designed for Jekyll, the blog aware static site generator powering Github Pages.'
  s.files = %w(
bin/octopress
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','octopress.rdoc']
  s.rdoc_options << '--title' << 'octopress' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'octopress'
  s.add_dependency('gli', '~> 1.4.0')
  s.add_dependency('jekyll', '~> 0.11.0')
  s.add_dependency('rubyzip', '~> 0.9.5')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('aruba', '0.4.10')
end
