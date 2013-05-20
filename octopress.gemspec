# -*- encoding: utf-8 -*-

Gem::Specification.new do |octo|
  octo.specification_version = 2 if octo.respond_to? :specification_version=
  octo.required_rubygems_version = Gem::Requirement.new(">= 0") if octo.respond_to? :required_rubygems_version=
  octo.rubygems_version = '1.3.5'

  octo.name          = "octopress"
  octo.version       = '3.0.0.beta1'
  octo.date          = '2013-05-20'
  octo.authors       = ["Brandon Mathis", "Parker Moore"]
  octo.email         = %w[brandon@imathis.com parkrmoore@gmail.com]
  octo.description   = %q{Octopress is an obsessively designed framework for Jekyll blogging. It's easy to configure and easy to deploy. Sweet huh?}
  octo.summary       = %q{Octopress is an obsessively designed framework for Jekyll blogging.}
  octo.homepage      = "http://octopress.org"

  octo.rdoc_options = ["--charset=UTF-8"]
  octo.extra_rdoc_files = %w[README.markdown]

  # = MANIFEST =
  octo.files = %w[
    CHANGELOG.markdown
    Gemfile
    Gemfile.lock
    Guardfile
    README.markdown
    Rakefile
    bin/octopress
    lib/guard/jekyll.rb
    lib/octopress.rb
    lib/octopress/command.rb
    lib/octopress/commands/build.rb
    lib/octopress/commands/build_javascripts.rb
    lib/octopress/commands/build_jekyll.rb
    lib/octopress/commands/build_stylesheets.rb
    lib/octopress/commands/install.rb
    lib/octopress/configuration.rb
    lib/octopress/core_ext.rb
    lib/octopress/dependency_installer.rb
    lib/octopress/filters/content.rb
    lib/octopress/filters/date.rb
    lib/octopress/filters/post.rb
    lib/octopress/filters/url.rb
    lib/octopress/formatters/base_formatter.rb
    lib/octopress/formatters/simple_formatter.rb
    lib/octopress/formatters/verbose_formatter.rb
    lib/octopress/generators/category_generator.rb
    lib/octopress/generators/sitemap_generator.rb
    lib/octopress/helpers/conditional.rb
    lib/octopress/helpers/include.rb
    lib/octopress/helpers/titlecase.rb
    lib/octopress/helpers/vars.rb
    lib/octopress/ink.rb
    lib/octopress/inquirable_string.rb
    lib/octopress/js_asset_manager.rb
    lib/octopress/scaffold/.gitignore
    lib/octopress/scaffold/config/compass.rb
    lib/octopress/scaffold/config/rack.rb
    lib/octopress/scaffold/config/site.yml
    lib/octopress/scaffold/stylesheets/plugins/plugins.scss
    lib/octopress/scaffold/stylesheets/screen.scss
    lib/octopress/tags/assign.rb
    lib/octopress/tags/capture.rb
    lib/octopress/tags/config-tag.rb
    lib/octopress/tags/include.rb
    lib/octopress/tags/js-assets.rb
    lib/octopress/tags/puts.rb
    lib/octopress/tags/render-partial.rb
    lib/octopress/tags/return.rb
    lib/octopress/version.rb
    octopress.gemspec
    spec/fixtures/env/defaults/classic.yml
    spec/fixtures/no_override/defaults/classic.yml
    spec/fixtures/override/defaults/classic.yml
    spec/fixtures/override/site.yml
    spec/octopress/configuration_spec.rb
    spec/octopress/dependency_installer_spec.rb
    spec/octopress/ink_spec.rb
    spec/octopress/octopress_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  octo.require_paths = %w[lib]
  octo.executables   = octo.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  octo.test_files    = octo.files.grep(%r{^(test|spec|features)/})

  {
    'rack' => '~> 1.5.0',
    'jekyll' => '~> 1.0.2',
    'redcarpet' => '~> 2.2.2',
    'RedCloth' => '~> 4.2.9',
    'haml' => '~> 3.1.7',
    'compass' => '~> 0.12.2',
    'sass-globbing' => '~> 1.0.0',
    'rubypants' => '~> 0.2.0',
    'stringex' => '~> 1.4.0',
    'liquid' => '~> 2.3.0',
    'tzinfo' => '~> 0.3.35',
    'json' => '~> 1.7.7',
    'sinatra' => '~> 1.4.2',
    'stitch-rb' => '~> 0.0.8',
    'uglifier' => '~> 2.1.0',
    'guard' => '~> 1.8.0',
    'guard-shell' => '~> 0.5.1',
    'guard-compass' => '~> 0.0.6',
    'guard-coffeescript' => '~> 1.3.0',
    'rb-inotify' => '~> 0.9.0',
    'rb-fsevent' => '~> 0.9.3',
    'rb-fchange' => '~> 0.0.6',
  }.each do |gem_name, version|
    octo.add_runtime_dependency(gem_name, version)
  end

  octo.add_development_dependency('rake', '~> 10.0.3')
  octo.add_development_dependency('rspec', '~> 2.13.0')
end