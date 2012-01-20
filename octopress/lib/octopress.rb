module Octopress

  # Answers the url of the plugins.yml file. Octopress will fetch the latest
  # version of this file when plugins are installed. This allows for bumping
  # plugin versions or adding new plugins without Gem releases.
  #
  # TODO: This needs to be finalized once we move the code out of the branch
  # and into the octopress organization.
  #
  def Octopress.plugins_url
    'https://raw.github.com/imathis/octopress/rubygemcli/octopress/plugins.yml'
  end

  def Octopress.template_root
    File.join File.expand_path(File.dirname(__FILE__)), 'octopress', 'template'
  end
end

require 'octopress/version'
require 'octopress/util'
require 'octopress/commands'
