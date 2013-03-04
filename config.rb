$:.unshift File.expand_path("lib", File.dirname(__FILE__)) # For use/testing when no gem is installed
require "octopress"

config = Octopress::Configuration.new.read_configuration

project_path = File.dirname(__FILE__)
project_type = :stand_alone

# Publishing paths
compass_http_path           = config[:destination].gsub('public', '')
http_path                   = compass_http_path
http_images_path            = "#{http_path}/images"
http_generated_images_path  = "#{http_path}/images"
http_fonts_path             = "#{http_path}/fonts"
css_dir                     = "#{config[:destination]}/stylesheets"

# Local development paths
sass_dir                    = "assets/stylesheets"
images_dir                  = "#{config[:source]}/images"
fonts_dir                   = "#{config[:source]}/fonts"
generated_images_dir        = "#{config[:source]}/images"

line_comments               = false
output_style                = :compressed unless Octopress.env == 'development'
