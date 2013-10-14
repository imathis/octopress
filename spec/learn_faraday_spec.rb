require "rspec"

require "faraday"
require "faraday_middleware"

describe Faraday do
  context ".get" do
    example "moved permanently, not following redirects" do
      VCR.use_cassette("duckduckgo_welcome") do
        response = Faraday.get("https://www.duckduckgo.com")
        response.status.should == 301
        response.body.should =~ /Moved Permanently/
        response.headers[:location].should == "https://duckduckgo.com/"
      end
    end

    example "moved permanently, following redirects" do
      VCR.use_cassette("duckduckgo_welcome_following_redirects") do
        connection = Faraday.new() do | connection |
          connection.use FaradayMiddleware::FollowRedirects, limit: 1
          # HOLY SHIT This is very important. Without this line, the test fails miserably.
          connection.adapter Faraday.default_adapter
        end

        response = connection.get("https://www.duckduckgo.com")
        response.status.should == 200
        response.body.should =~ /DuckDuckGo/
      end
    end
  end
end
