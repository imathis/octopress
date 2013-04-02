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
  end
end
