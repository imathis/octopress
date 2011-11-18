require 'rake/dsl_definition'
require 'rake'
require './lib/octopress.rb'

config           = Octopress.config
root_dir         = config['root'].sub(/\/$/, '')


# Require any additional compass plugins here.
project_type     = :stand_alone

# Publishing paths
http_path        = config['root']
http_images_path = "#{root_dir}/images"
http_fonts_path  = "#{root_dir}/fonts"
css_dir          = config['stylesheets']

# Local development paths
project_path     = config['actual_blog_root']
sass_dir         = "sass"
#images_dir       = "#{config['source']}/images"
#fonts_dir        = "#{config['source']}/fonts"
images_dir       = "source/images"
fonts_dir        = "source/fonts"

line_comments    = false
output_style     = :compressed
