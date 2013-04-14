describe Jekyll::PullquoteTag do
  VALID_PULLQUOTE_TEMPLATE=%q{
    {% pullquote %}
    In the middle of this boring text is {" something very profound. "}
    {% endpullquote %}
  }
  VALID_PULLQUOTE_RESULT=%q{
    <span class='pullquote-right' data-pullquote='something very profound.'>
    In the middle of this boring text is something very profound.
    </span>
  }

  INVALID_PULLQUOTE_TEMPLATE=%q{
    {% pullquote %}
    In the middle of this boring text is something very profound.
    {% endpullquote %}
  }
  INVALID_PULLQUOTE_RESULT=%q{
    Surround your pullquote like this {" text to be quoted "}
  }
  describe "#render" do
    context "a valid template" do
      subject do
        Liquid::Template.parse(VALID_PULLQUOTE_TEMPLATE).render({})
      end

      it "should render span with a data-pullquote attribute, so that the main text elements don't duplicate the pullquote content" do
        should eq(VALID_PULLQUOTE_RESULT)
      end
    end

    context "a template that's missing pullquote markers" do
      subject do
        Liquid::Template.parse(INVALID_PULLQUOTE_TEMPLATE).render({})
      end

      it "should produce an error" do
        should eq(INVALID_PULLQUOTE_RESULT)
      end
    end
  end
end
