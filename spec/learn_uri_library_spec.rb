describe URI do
  context "putting together parts of a URI, some optional" do
    context "optional bit at the end" do
      example "optional bit provided" do
        URI.join("https://gist.github.com/jbrains/4111662/raw/", "TestingIoFailure.java").should == URI.parse("https://gist.github.com/jbrains/4111662/raw/TestingIoFailure.java")
      end

      example "optional bit omitted" do
        URI.join("https://gist.github.com/jbrains/4111662/raw/", "").should == URI.parse("https://gist.github.com/jbrains/4111662/raw/")
      end
    end
  end
end

