require "spec_helper"

describe Octopress::Templates do
  describe '#post' do
    before do
      @config = Octopress::Configuration.new(File.join(File.dirname(__FILE__), '../', 'fixtures', 'working_area')).read_configuration
      FileUtils.rm_rf("tmp/")
      FileUtils.mkdir_p("tmp/source/_posts")
      FileUtils.mkdir_p("tmp/public")
    end

    let :params do
      [@config, Time.now, "Article Title"]
    end

    ALTERED_CONTENT="This Shouldn't Be Overwritten"
    let :post do
      fname = subject.post(*params)
      # Replace contents with something that will allow us to determine if
      # the file was overwritten since the contents should be the same
      # from both calls to #post otherwise.
      File.open(fname, "w") { |fh| fh.write(ALTERED_CONTENT) }
      fname
    end

    subject do
      Octopress::Templates
    end

    context "when provided valid parameters" do
      it "creates a post based on the given timestamp and title" do
        File.read(subject.post(*params)).should_not be_empty
      end
    end

    context "when given a callback" do
      it "allows the callback to prevent overwriting existing files" do
        fname = post

        expect do
          subject.post(*params) { |filename| false }
        end.to raise_error(RuntimeError)

        File.read(fname).should eq(ALTERED_CONTENT)
      end

      it "allows the callback to allow overwriting existing files" do
        fname = post

        subject.post(*params) { |filename| true }

        File.read(fname).should_not eq(ALTERED_CONTENT)
      end
    end

    context "when not given a callback" do
      it "prevents overwriting existing files" do
        fname = post

        expect do
          subject.post(*params)
        end.to raise_error(RuntimeError)

        File.read(fname).should eq(ALTERED_CONTENT)
      end
    end
  end
end
