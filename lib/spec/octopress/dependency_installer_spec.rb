require_relative '../spec_helper.rb'

describe Octopress::DependencyInstaller do
  describe "#git_url" do
    context "when just a repo name is specified" do
      let(:plugin) { "adn-timeline" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq("git://github.com/octopress/#{plugin}.git") }
    end
    context "when a username and repo name are specified" do
      let(:plugin) { "imathis/adntimeline" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq("git://github.com/#{plugin}.git") }
    end
    context "when a username and repo name are specified (with dash)" do
      let(:plugin) { "imathis-/adn-timeline" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq("git://github.com/#{plugin}.git") }
    end
    context "when a full git:// URL is specified" do
      let(:plugin) { "git://github.com/parkr/cool-plugin.git" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq(plugin) }
    end
    context "when a full https:// URL is specified" do
      let(:plugin) { "https://bitbucket.com/parkr/cool-plugin.git" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq(plugin) }
    end
    context "when a full git SSH path is specified" do
      let(:plugin) { "git@octopress.org:parkr/cool-plugin.git" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq(plugin) }
    end
  end
end
