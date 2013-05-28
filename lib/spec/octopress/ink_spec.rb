describe Octopress::Ink do
  subject { Octopress::Ink.build }

  %w[debug warn info error].each do |method|
    it "responds to #{method} method" do
      expect(subject).to respond_to(method)
    end
  end

end
