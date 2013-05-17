require_relative '../spec_helper.rb'

describe Octopress::Logger do
  subject { Octopress::Logger.build }

  %w[debug warn info error].each do |method|
    it "responds to #{method} method" do
      expect(subject).to respond_to(method)
    end
  end

end
