describe "Jekyll::RawTag" do
  
  require './plugins_helper.rb'
  include Liquid
  require "#{OCTOPRESS_ROOT}plugins/raw.rb"
  include TemplateWrapper

  it "should wrap/unwrap content correctly" do
    input  = "Lorem <i>psum dolor s</i>t amet"
    output = safe_wrap(input)
    output.should eql(
      "<div class='bogus-wrapper'><notextile>Lorem <i>psum dolor s</i>t amet</notextile></div>"
    )
    unwrap(output).should eql(input)
  end

end
