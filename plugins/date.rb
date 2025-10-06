require 'time'

module Octopress
  module DateLogic
    module_function

    # Returns a datetime if the input is a string.
    def datetime(date)
      return date unless date.is_a?(String)
      Time.parse(date)
    end

    # Returns an ordinal date eg July 22 2007 -> July 22nd 2007.
    def ordinalize(date)
      date = datetime(date)
      "#{date.strftime('%b')} #{ordinal(date.strftime('%e').to_i)}, #{date.strftime('%Y')}"
    end

    # Returns an ordinal number. 13 -> 13th, 21 -> 21st etc.
    def ordinal(number)
      return "#{number}<span>th</span>" if (11..13).include?(number.to_i % 100)

      case number.to_i % 10
      when 1 then "#{number}<span>st</span>"
      when 2 then "#{number}<span>nd</span>"
      when 3 then "#{number}<span>rd</span>"
      else        "#{number}<span>th</span>"
      end
    end

    # Formats date either as ordinal or by given date format.
    # Adds %o as ordinal representation of the day.
    def format_date(date, format)
      date = datetime(date)
      if format.nil? || format.empty? || format == 'ordinal'
        ordinalize(date)
      else
        formatted = date.strftime(format)
        formatted.gsub(/%o/, ordinal(date.strftime('%e').to_i))
      end
    end

    # Populates formatted date fields for Liquid templates.
    def attach_formatted_dates(document)
      return unless document.respond_to?(:data) && document.respond_to?(:site)

      data = document.data
      site = document.site
      return unless data.is_a?(Hash) && site

      date_format = site.config['date_format']
      date_value = data['date']
      date_value = document.date if date_value.nil? && document.respond_to?(:date)

      data['date_formatted'] = format_date(date_value, date_format) if date_value

      if data.key?('updated') && data['updated']
        data['updated_formatted'] = format_date(data['updated'], date_format)
      else
        data.delete('updated_formatted')
      end
    end
  end

  module Date
    def datetime(date)
      DateLogic.datetime(date)
    end

    def ordinalize(date)
      DateLogic.ordinalize(date)
    end

    def ordinal(number)
      DateLogic.ordinal(number)
    end

    def format_date(date, format)
      DateLogic.format_date(date, format)
    end
  end

  module DateFilters
    include Date
  end
end

Liquid::Template.register_filter Octopress::DateFilters

Jekyll::Hooks.register :posts, :pre_render do |post, _payload|
  Octopress::DateLogic.attach_formatted_dates(post)
end

Jekyll::Hooks.register :pages, :pre_render do |page, _payload|
  Octopress::DateLogic.attach_formatted_dates(page)
end
