module Octopress
  # An extended version of String that supports Rails style `.foo?` calls to
  # test for equality, and allows for direct comparison against both string and
  # symbol values.  (Never again worry about whether some method is returning a
  # string or a symbol!)
  #
  # For example:
  #
  # ```ruby
  # tmp = Octopress::InquirableString.new("something")
  # tmp.something?      # Returns `true`.
  # tmp.something_else? # Returns `false`.
  # tmp == 'something'  # Returns `true`.
  # tmp == :something   # Returns `true`.
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

    # A little magic to ensure we can compare against strings, symbols, and
    # other InquirableString objects and always get the results one would
    # predict we'd get.
    #
    # other_val - The value to compare against this one.
    #
    # Returns true if they are logically equivalent, false otherwise.
    def ==(other_val)
      if(other_val.is_a?(Symbol) || other_val.is_a?(InquirableString))
        return other_val.to_s == self
      elsif(other_val.is_a?(String))
        return other_val == self
      else
        return false
      end
    end
  end
end
