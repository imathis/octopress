module Octopress
  module Date

    # Returns a datetime if the input is a string
    def datetime(date)
      if date.class == String
        date = Time.parse(date)
      end
      date
    end

    # Returns an ordidinal date eg July 22 2007 -> July 22nd 2007
    def ordinalize(date)
      date = datetime(date)
      "#{date.strftime('%b')} #{ordinal(date.strftime('%e').to_i)}, #{date.strftime('%Y')}"
    end

    # Returns an ordinal number. 13 -> 13th, 21 -> 21st etc.
    def ordinal(number)
      if (11..13).include?(number.to_i % 100)
        "#{number}<span>th</span>"
      else
        case number.to_i % 10
        when 1; "#{number}<span>st</span>"
        when 2; "#{number}<span>nd</span>"
        when 3; "#{number}<span>rd</span>"
        else    "#{number}<span>th</span>"
        end
      end
    end

    # Formats date either as ordinal or by given date format
    # Adds %o as ordinal representation of the day
    def format_date(date, format)
      date = datetime(date)
      if format.nil? || format.empty? || format == "ordinal"
        date_formatted = ordinalize(date)
      else
        date_formatted = date.strftime(format)
        date_formatted.gsub!(/%o/, ordinal(date.strftime('%e').to_i))
      end
      date_formatted
    end
    
    # Returns the date-specific liquid attributes
    def liquid_date_attributes
      date_format = self.site.config['date_format']
      date_attributes = {}
      date_attributes['date_formatted']    = format_date(self.data['date'], date_format)    if self.data.has_key?('date')
      date_attributes['updated_formatted'] = format_date(self.data['updated'], date_format) if self.data.has_key?('updated')
      date_attributes
    end

  end
end


module Jekyll

  class Post
    include Octopress::Date

    # Convert this Convertible's data to a Hash suitable for use by Liquid.
    # Overrides the default return data and adds any date-specific liquid attributes
    alias :super_to_liquid :to_liquid
    def to_liquid
      super_to_liquid.deep_merge(liquid_date_attributes)
    end
  end

  class Page
    include Octopress::Date

    # Convert this Convertible's data to a Hash suitable for use by Liquid.
    # Overrides the default return data and adds any date-specific liquid attributes
    alias :super_to_liquid :to_liquid
    def to_liquid
      super_to_liquid.deep_merge(liquid_date_attributes)
    end
  end
end
