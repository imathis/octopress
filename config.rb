require 'rake/dsl_definition'
require 'rake'
require './lib/octopress.rb'

config           = Octopress.config File.dirname(__FILE__)
root_dir         = config['root'].sub(/\/$/, '')


# Require any additional compass plugins here.
project_type     = :stand_alone

# Publishing paths
http_path        = config['root']
http_images_path = "#{root_dir}/#{config['octopress_sass_images_dir_name']}"
http_fonts_path  = "#{root_dir}/#{config['octopress_sass_fonts_dir_name']}"
css_dir          = "#{config['octopress_source_dir_name']}/#{config['octopress_stylesheets_dir_name']}"

# Local development paths
project_path     = config['octopress_paths_sass_project_path']
sass_dir         = config['octopress_sass_dir_name']
images_dir       = "#{config['octopress_source_dir_name']}/#{config['octopress_sass_images_dir_name']}"
fonts_dir        = "#{config['octopress_source_dir_name']}/#{config['octopress_sass_fonts_dir_name']}"

line_comments    = false
output_style     = :compressed
