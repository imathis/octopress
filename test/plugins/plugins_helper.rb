# Stub for Liquid module used by plugins
module Liquid
  module Template
    def self.register_tag(name, klass); end
    def self.register_filter(klass); end
  end

  class Tag; def render(context); end; end
  class Block; def render(context); end; end
end

# Octopress root directory
OCTOPRESS_ROOT = File.dirname(__FILE__).sub(/test.*$/, '')
