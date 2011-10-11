# Octopress root directory
octopress_root = File.dirname(__FILE__).sub(/spec.*$/, '')
puts octopress_root
$LOAD_PATH.unshift(octopress_root) unless $LOAD_PATH.include?(octopress_root)
