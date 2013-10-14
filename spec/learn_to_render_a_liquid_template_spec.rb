require "rspec"

require "jekyll"
require "plugins/code_block"

# WARNING This depends heavily on global data in the Liquid::Template
# universe, which I hate, but which I couldn't figure out how to
# avoid. There be magic here. Please, if you have energy, figure out
# how not to depend on that magic. Copy the magic here, if you can.
describe "Rendering a Liquid::Template" do
  example "realistic example using the previously downloaded content of a gist" do
    equivalent_liquid_template_text = <<-TEMPLATE
{% codeblock TestingIoFailure.java https://gist.github.com/jbrains/4111662 %}
@Test
public void ioFailure() throws Exception {
    final IOException ioFailure = new IOException("Simulating a failure writing to the file.");
    try {
        new WriteTextToFileActionImpl() {
            @Override
            protected FileWriter fileWriterOn(File path) throws IOException {
                return new FileWriter(path) {
                    @Override
                    public void write(String str, int off, int len) throws IOException {
                        throw ioFailure;
                    }
                };
            }
        }.writeTextToFile("::text::", new File("anyWritableFile.txt"));
        fail("How did you survive the I/O failure?!");
    } catch (IOException success) {
        if (success != ioFailure)
            throw success;
    }
}
{% endcodeblock %}
TEMPLATE

    rendered_gist_as_html = Liquid::Template.parse(equivalent_liquid_template_text).render(Liquid::Context.new)
    # Spot checks, rather than checking the entire content.
    # Is the title there?
    rendered_gist_as_html.should =~ %r{TestingIoFailure\.java}m
    # Is the URL there?
    rendered_gist_as_html.should =~ %r{https://gist.github.com/jbrains/4111662}m
    # Do we probably have the expected code? (Where else would this come from?)
    rendered_gist_as_html.should =~ %r{fail.+How did you survive the I/O failure\?\!}m
  end

  example "do not try to use multiple Liquid 'raw' tags in a line, because they're greedy" do
    pending "This is scheduled to work in Liquid v2.6" do
      Liquid::Template.parse(["{% codeblock %}", "A line with {% raw %}{% {% endraw %} and {% raw %} %}{% endraw %} in it, which need to be escaped for Liquid.", "{% endcodeblock %}"].join("\n")).render(Liquid::Context.new).should =~ /A\ line\ with\ \{\%\ and\ \%\}\ in\ it/
    end
  end

  example "escaping for Liquid a little more sensibly" do
    Liquid::Template.parse(["{% codeblock %}", "{% raw %}", "A line with {% and %} in it, which need to be escaped for Liquid.", "{% endraw %}", "{% endcodeblock %}"].join("\n")).render(Liquid::Context.new).should =~ /A\ line\ with\ \{\%\ and\ \%\}\ in\ it/
  end

  example "what if we put these characters inside the opening tag?" do
    rendered = Liquid::Template.parse(["{% codeblock filename{%behaving%}badly %}", "{% raw %}", "{% endraw %}", "{% endcodeblock %}"].join("\n")).render(Liquid::Context.new)
    # The parameter I attempted to pass to {% codeblock %} was cleft in twain!
    rendered.should =~ %r{<span>filename\{%behaving</span>.+<span class='line'>badly %\}</span>}m
    # Therefore, don't let this happen. You'll thank me later.
  end
end
