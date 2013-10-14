# Include gists without the annoying github CSS.
#
# Usage:
#
# Specify everything:
# {% gist_no_css username/gist_id filename %}
#
# Example: {% gist_no_css jbrains/4111662 TestingIoFailure.java %}
# This gives you the code with the title "TestingIoFailure.java"
# and a link to https://gist.github.com/jbrains/4111662
#
# Since you specified the filename, you get syntax highlighting!
#
# Username and filename are optional.
#
# Example: {% gist_no_css jbrains/4111662 %}
# In this case, you don't get syntax highlighting, and if the
# gist has multiple files, you get the first one.
#
# Example: {% gist_no_css 4111662 TestingIoFailure.java %}
# If you don't know the username, github will infer it for you.
# This costs you an extra redirect.
#
# Example: {% gist_no_css 4111662 %}
# If you want to go simple, that works, but once again, no
# syntax highlighting.
#
# Errors during processing show up in the HTML as comments.
#
# Made with love and care by @jbrains, J. B. Rainsberger
# Pardon the opinionated comments. Stress.

# require "jekyll" # I depend on Liquid
# require "plugins/code_block" # I need the codeblock tag registered in Liquid; I'd require this, but then I'd have to use a relative-path require, which I simply won't do.
require "faraday"
require "faraday_middleware"

# mandatory: gist_id
# optional: username, filename
GistFileKey = Struct.new(:gist_id, :username, :filename)

# mandatory: code, gist_url
# optional: filename
GistFile = Struct.new(:code, :gist_url, :filename)

class RendersGistWithoutCss
  def initialize(renders_code, downloads_gist)
    @renders_code = renders_code
    @downloads_gist = downloads_gist
  end

  def self.with(collaborators_as_hash)
    self.new(collaborators_as_hash[:renders_code], collaborators_as_hash[:downloads_gist])
  end

  # This function promises not to raise an error
  def render(gist_file_key)
    # REFACTOR I'd rather be composing functions.
    @renders_code.render(@downloads_gist.download(gist_file_key))
  rescue => oops
    # I tried to do this with an HTML comment,
    # but a RubyPants filter ate my --> delimeters,
    # so I opted for Javascript comments, instead.
    # Wow.
    StringIO.new.tap { |canvas| canvas.puts "<script>", "/*", oops.message, oops.backtrace, "*/", "</script>" }.string
  end
end

class DownloadsGistUsingFaraday
  def download(gist_file_key)
    base = "https://gist.github.com"
    gist_id = gist_file_key.gist_id
    username = gist_file_key.username
    filename = gist_file_key.filename

    filename_portion = "/#{filename}" if filename
    if username
      raw_url = "#{base}/#{username}/#{gist_id}/raw#{filename_portion}"
      pretty_url = "#{base}/#{username}/#{gist_id}"
      uri = "/#{username}/#{gist_id}/raw#{filename_portion}"
    else
      raw_url = "#{base}/raw/#{gist_id}#{filename_portion}"
      pretty_url = "#{base}/#{gist_id}"
      uri = "/raw/#{gist_id}#{filename_portion}"
    end
    response = http_get(base, uri)

    return GistFile.new(response.body, pretty_url, filename) unless (400..599).include?(response.status.to_i)
    raise RuntimeError.new(StringIO.new.tap { |s| s.puts "I failed to download the gist at #{raw_url}", response.inspect.to_s }.string)
  end

  # REFACTOR Move this onto a collaborator
  def http_get(base, uri)
    faraday_with_default_adapter(base) { | connection |
      connection.use FaradayMiddleware::FollowRedirects, limit: 1
    }.get(uri)
  end

  # REFACTOR Move this into Faraday
  # REFACTOR Rename this something more intention-revealing
  def faraday_with_default_adapter(base, &block)
    Faraday.new(base) { | connection |
      yield connection

    # IMPORTANT Without this line, nothing will happen.
    connection.adapter Faraday.default_adapter
    }
  end
end

# Everything in here knows about Liquid
class RendersGistFileAsHtml
  def render_gist_file_as_code_block(gist_file)
    raise ArgumentError.new(%q(Liquid can't handle % or { or } inside tags, so don't do it.)) if [gist_file.filename, gist_file.gist_url].any? { |each| each =~ %r[{|%|}] }
    <<-CODEBLOCK
{% codeblock #{gist_file.filename} #{gist_file.gist_url} %}
#{gist_file.code}
{% endcodeblock %}
CODEBLOCK
  end

  def render_code_block_as_html(code_block)
    Liquid::Template.parse(code_block).render(Liquid::Context.new)
  end

  def render(gist_file)
    render_code_block_as_html(render_gist_file_as_code_block(gist_file))
  end
end

# I don't know why this needs to reside in module Jekyll, but
# I'm going with it for now.
module Jekyll
  class GistNoCssTag < Liquid::Tag
    def initialize(tag_name, parameters, tokens)
      @tag_name = name
      @parameters = parameters
      @tokens = tokens
    end

    def self.parse_parameters(parameters)
      match_data = /^(?:(.+)\/)?(\d+)(?:\s+([^\s]+))?$/.match(parameters.strip)
      begin
        Integer(match_data[2])
      rescue
        raise ArgumentError.new("Parameters: '#{parameters}'; Match Data: '#{match_data}.'")
      end
      GistFileKey.new(match_data[2].to_i, match_data[1], match_data[3])
    end

    def render(context)
      RendersGistWithoutCss.new(
        RendersGistFileAsHtml.new, 
        DownloadsGistUsingFaraday.new
      ).render(self.class.parse_parameters(@parameters))
    end
  end
end

Liquid::Template.register_tag('gist_no_css', Jekyll::GistNoCssTag)
