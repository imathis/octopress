module Octopress
  class InquirableString < String
    def method_missing(name, *args, &block)
      if(name =~ /^.*\?$/)
        val = name.to_s.sub(/\?$/, '')
        return self == val
      else
        super
      end
    end

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
