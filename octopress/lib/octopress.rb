module Octopress
  def Octopress.template_root
    File.join File.expand_path(File.dirname(__FILE__)), 'octopress', 'template'
  end
end

require 'octopress/version'
require 'octopress/commands'
