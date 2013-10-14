# SMELL Production code needs Jekyll, but doesn't require it, so this file has to.
require "jekyll"

require "rspec"
require "plugins/code_block"

describe "Parsing parameters for codeblock" do
  # The @file field appears to be unused, so don't bother checking it
  example "only a URL" do
    Jekyll::CodeBlock.parse_tag_parameters("https://gist.github.com/1234 ").should include({
      caption: %Q{<figcaption><span>https://gist.github.com/1234</span><a href='https://gist.github.com/1234'>#{'link'}</a></figcaption>},
      filetype: nil
    })
  end

  example "only a title that does not look like a filename" do
    Jekyll::CodeBlock.parse_tag_parameters("anything that does not contain a dot").should include({ 
      filetype: nil,
      caption: %Q{<figcaption><span>anything that does not contain a dot</span></figcaption>}
    })
  end

  example "a single-word title that looks like a filename" do
    Jekyll::CodeBlock.parse_tag_parameters("filename.xyz").should include({ 
      filetype: "xyz",
      caption: %Q{<figcaption><span>filename.xyz</span></figcaption>}
    })
  end

  example "a multiple-word title that looks like it has a filename at the end" do
    Jekyll::CodeBlock.parse_tag_parameters("a multiple-word title followed by filename.xyz").should include({
      filetype: "xyz",
      caption: %Q{<figcaption><span>a multiple-word title followed by filename.xyz</span></figcaption>}
    })
  end

  example "a multiple-word title that looks like it has a filename in the middle" do
    Jekyll::CodeBlock.parse_tag_parameters("word filename.xyz more words").should include({
      filetype: "xyz",
      caption: %Q{<figcaption><span>word filename.xyz more words</span></figcaption>}
    })
  end

  example "a multiple-word title that starts with a filename" do
    Jekyll::CodeBlock.parse_tag_parameters("filename.xyz word").should include({
      filetype: "xyz",
      caption: %Q{<figcaption><span>filename.xyz word</span></figcaption>}
    })
  end

  example "all advertised parameters" do
    Jekyll::CodeBlock.parse_tag_parameters("A nice, simple caption for gist2.rb http://www.jbrains.ca see more").should include({
      filetype: "rb", 
      caption: %Q{<figcaption><span>A nice, simple caption for gist2.rb</span><a href='http://www.jbrains.ca'>see more</a></figcaption>}
    })
  end

  example "lang attribute conflicts with filename extension" do
    Jekyll::CodeBlock.parse_tag_parameters("filename.xyz lang:rb").should include({
      filetype: "rb",
      caption: %Q{<figcaption><span>filename.xyz</span></figcaption>}
    })
  end

  example "filename then URL" do
    Jekyll::CodeBlock.parse_tag_parameters("Awesome.java http://www.jbrains.ca/permalink/x/y/z").should include({
      filetype: "java",
      caption: %Q{<figcaption><span>Awesome.java</span><a href='http://www.jbrains.ca/permalink/x/y/z'>link</a></figcaption>}
    })
  end

  example "URL then filename" do
    # We don't handle this case, so anything we do is just fine!
  end
end

describe "Rendering a CodeBlock from end to end" do
  example "using a Liquid::Template" do
    # ASSUME requiring the code block plugin automatically registered the tag
    template_text = <<-TEMPLATE
{% codeblock TestingIoFailure.java https://gist.github.com/jbrains/4111662#file-testingiofailure-java %}
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

    golden_master_rendered_html = <<-GOLDEN_MASTER_RENDERED_HTML
<div class='bogus-wrapper'><notextile><figure class='code'><figcaption><span>TestingIoFailure.java</span><a href='https://gist.github.com/jbrains/4111662#file-testingiofailure-java'>link</a></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class='line-number'>1</span>
<span class='line-number'>2</span>
<span class='line-number'>3</span>
<span class='line-number'>4</span>
<span class='line-number'>5</span>
<span class='line-number'>6</span>
<span class='line-number'>7</span>
<span class='line-number'>8</span>
<span class='line-number'>9</span>
<span class='line-number'>10</span>
<span class='line-number'>11</span>
<span class='line-number'>12</span>
<span class='line-number'>13</span>
<span class='line-number'>14</span>
<span class='line-number'>15</span>
<span class='line-number'>16</span>
<span class='line-number'>17</span>
<span class='line-number'>18</span>
<span class='line-number'>19</span>
<span class='line-number'>20</span>
<span class='line-number'>21</span>
</pre></td><td class='code'><pre><code class='java'><span class='line'><span class="nd">@Test</span>
</span><span class='line'><span class="kd">public</span> <span class="kt">void</span> <span class="nf">ioFailure</span><span class="o">()</span> <span class="kd">throws</span> <span class="n">Exception</span> <span class="o">{</span>
</span><span class='line'>    <span class="kd">final</span> <span class="n">IOException</span> <span class="n">ioFailure</span> <span class="o">=</span> <span class="k">new</span> <span class="n">IOException</span><span class="o">(</span><span class="s">&quot;Simulating a failure writing to the file.&quot;</span><span class="o">);</span>
</span><span class='line'>    <span class="k">try</span> <span class="o">{</span>
</span><span class='line'>        <span class="k">new</span> <span class="nf">WriteTextToFileActionImpl</span><span class="o">()</span> <span class="o">{</span>
</span><span class='line'>            <span class="nd">@Override</span>
</span><span class='line'>            <span class="kd">protected</span> <span class="n">FileWriter</span> <span class="nf">fileWriterOn</span><span class="o">(</span><span class="n">File</span> <span class="n">path</span><span class="o">)</span> <span class="kd">throws</span> <span class="n">IOException</span> <span class="o">{</span>
</span><span class='line'>                <span class="k">return</span> <span class="k">new</span> <span class="nf">FileWriter</span><span class="o">(</span><span class="n">path</span><span class="o">)</span> <span class="o">{</span>
</span><span class='line'>                    <span class="nd">@Override</span>
</span><span class='line'>                    <span class="kd">public</span> <span class="kt">void</span> <span class="nf">write</span><span class="o">(</span><span class="n">String</span> <span class="n">str</span><span class="o">,</span> <span class="kt">int</span> <span class="n">off</span><span class="o">,</span> <span class="kt">int</span> <span class="n">len</span><span class="o">)</span> <span class="kd">throws</span> <span class="n">IOException</span> <span class="o">{</span>
</span><span class='line'>                        <span class="k">throw</span> <span class="n">ioFailure</span><span class="o">;</span>
</span><span class='line'>                    <span class="o">}</span>
</span><span class='line'>                <span class="o">};</span>
</span><span class='line'>            <span class="o">}</span>
</span><span class='line'>        <span class="o">}.</span><span class="na">writeTextToFile</span><span class="o">(</span><span class="s">&quot;::text::&quot;</span><span class="o">,</span> <span class="k">new</span> <span class="n">File</span><span class="o">(</span><span class="s">&quot;anyWritableFile.txt&quot;</span><span class="o">));</span>
</span><span class='line'>        <span class="n">fail</span><span class="o">(</span><span class="s">&quot;How did you survive the I/O failure?!&quot;</span><span class="o">);</span>
</span><span class='line'>    <span class="o">}</span> <span class="k">catch</span> <span class="o">(</span><span class="n">IOException</span> <span class="n">success</span><span class="o">)</span> <span class="o">{</span>
</span><span class='line'>        <span class="k">if</span> <span class="o">(</span><span class="n">success</span> <span class="o">!=</span> <span class="n">ioFailure</span><span class="o">)</span>
</span><span class='line'>            <span class="k">throw</span> <span class="n">success</span><span class="o">;</span>
</span><span class='line'>    <span class="o">}</span>
</span><span class='line'><span class="o">}</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
GOLDEN_MASTER_RENDERED_HTML

    template = Liquid::Template.parse(template_text)
    # WATCH OUT! We have to strip both sides because of spurious leading and trailing whitespace. It's a good thing.
    template.render(Liquid::Context.new).strip.should == golden_master_rendered_html.strip
  end
end

# PUBLIC SERVICE ANNOUNCEMENT
# There is no way to invoke a Jekyll::CodeBlock directly,
# because you can't render a Liquid::Block without intimate,
# possibly illegal knowledge of its surrounding Liquid::Template!
# I have to thank the Liquid programmers for making this possible.
#
# In order to render a Jekyll::CodeBlock, I have to create
# a tiny Liquid::Template and put the {% codeblock %} tag in 
# there, then render the tiny template, then throw the tiny
# template away. This sucks, albeit only relatively little.
#
# This means that I need to implement RendersCodeUsingOctopressCodeBlock
# to create a tiny Liquid::Template. Fortunately, the code above shows
# me just how easy that can be.
#
# Fuck.
