module Octopress
  # An extended version of String that supports Rails style `.foo?` calls to
  # test for equality.
  #
  # For example:
  #
  # ```ruby
  # tmp = Octopress::InquirableString.new("something")
  # tmp.something?      # Returns `true`.
  # tmp.something_else? # Returns `false`.
  # tmp == 'something'  # Returns `true`.
  # ```
  class InquirableString < String
    # A handler that captures methods of the form `<some_string>?`, and does
    # the equivalent of a `== 'some_string'` comparison.
    #
    # No other pattern of method name is handled here.
    def method_missing(name, *args, &block)
      if(name =~ /^.*\?$/)
        val = name.to_s.sub(/\?$/, '')
        return self == val
      else
        super
      end
    end
  end
end
