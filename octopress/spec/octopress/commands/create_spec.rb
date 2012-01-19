require 'spec_helper'

describe Octopress::Commands::Create do
  include FakeFS::SpecHelpers

  let(:url) { 'http://hostname.com/myfile.txt' }
  let(:project_path) { File.expand_path File.join('tmp', 'create') }

  subject { described_class.new(project_path) }

  it 'downloads to tmp location in project_path' do
    stub_request(:get, url).to_return(body:'my file')
    download_path = subject.download url, 'thename.txt'
    download_path.should == File.join(project_path, 'tmp', 'thename.txt')
    File.exists?(download_path).should be_true
    File.read(download_path).should == 'my file'
  end
end
