require 'spec_helper'
require 'plugins_helper'

require 'plugins/raw'

describe "Jekyll::RawTag" do
  
  include Liquid
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
