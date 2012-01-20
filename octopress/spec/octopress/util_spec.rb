require 'spec_helper'

describe Octopress::Util do
  include FakeFS::SpecHelpers
  include described_class

  describe 'download' do
    let(:url) { 'http://hostname.com/myfile.txt' }
    let(:path) { './some/path' }
    let(:filename) { 'specified.txt' }
    let(:content) { 'my file' }

    let(:file) do
      stub_request(:get, url).to_return(body:content)
      download url, path
    end

    before do
      FileUtils.mkdir 'tmp' # So that Tempfile will work
    end

    it 'answers the downloaded file path' do
      file.should == File.join(path, 'myfile.txt')
    end

    it 'saves content to file' do
      File.read(file).should == content
    end

    it 'uses the filename in the url' do
      File.basename(file).should == 'myfile.txt'
    end

    it 'uses the filename in the response header' do
      stub_request(:get, url).to_return(
        headers:{ 'Content-Disposition' => "attachment; filename=#{filename}" },
        body:content)
      file = download url, path
      File.basename(file).should == filename
    end

    it 'uses provided filename' do
      stub_request(:get, url).to_return(body:content)
      file = download url, path, filename
      File.basename(file).should == filename
    end
  end
end
