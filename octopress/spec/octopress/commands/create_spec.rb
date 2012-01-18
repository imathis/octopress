require 'spec_helper'

describe Octopress::Commands::Create do
  include FakeFS::SpecHelpers

  let(:project_path) { File.expand_path File.join('tmp', 'create') }

  subject { described_class.new(project_path) }

  it 'downloads to tmp location in project_path' do
    download_path = subject.download 'https://github.com/octopress/theme-classic/zipball/master', 'theme-classic.zip'
    download_path.should == File.join(project_path, 'tmp', 'theme-classic.zip')
    File.exists?(download_path).should be_true
    File.size(download_path).should > 0
  end
end
