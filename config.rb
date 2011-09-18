require './octopress/octopress.rb'

config           = Octopress::config

# Require any additional compass plugins here.
project_type     = :stand_alone

# Publishing paths
http_path        = config['root']
http_images_path = "/images"
http_fonts_path  = "/fonts"
css_dir          = "#{config['destination']}/stylesheets"

# Local development paths
sass_dir         = "sass"
images_dir       = "#{config['source']}/images"
fonts_dir        = "#{config['source']}/fonts"

line_comments    = false
output_style     = :compressed
