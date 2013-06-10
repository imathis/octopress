# -*- encoding: utf-8 -*-

require "safe_yaml"

def manifest
  @manifest ||= YAML.safe_load_file(File.expand_path("../MANIFEST.yml", __FILE__))
end

Gem::Specification.new do |octo|
  octo.specification_version = 2 if octo.respond_to? :specification_version=
  octo.required_rubygems_version = Gem::Requirement.new(">= 0") if octo.respond_to? :required_rubygems_version=
  octo.rubygems_version = '1.3.5'

  octo.name          = manifest["name"]
  octo.version       = manifest["version"]
  octo.date          = '2013-05-23'
  octo.authors       = manifest["authors"]
  octo.email         = manifest["emails"]
  octo.description   = manifest["description"]
  octo.summary       = manifest["summary"]
  octo.homepage      = manifest["homepage"]

  octo.rdoc_options = ["--charset=UTF-8"]
  octo.extra_rdoc_files = manifest["extra_rdoc_files"] 

  # = MANIFEST =
  octo.files = %w[
  ]
  # = MANIFEST =

  octo.require_paths = %w[lib]
  octo.executables   = octo.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  octo.test_files    = octo.files.grep(%r{^(test|spec|features)/})

  {
    "octopress" => "~> 3.0.0"
  }.each do |gem_name, version|
    octo.add_runtime_dependency(gem_name, version)
  end

  octo.add_development_dependency('rake', '~> 10.0.3')
  octo.add_development_dependency('rspec', '~> 2.13.0')
end
