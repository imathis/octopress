require_relative '../spec_helper.rb'

describe Octopress::DependencyInstaller do
  describe "#git_url" do
    let(:installer) { Octopress::DependencyInstaller.new }
    describe "when just a repo name is specified" do
      let(:plugin) { "adn-timeline" }
      subject { Octopress::DependencyInstaller.new.git_url(plugin) }
      it { should eq("git://github.com/octopress/#{plugin}.git") }
    end
  end
end
