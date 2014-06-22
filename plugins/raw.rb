# Author: Brandon Mathis
# Description: Provides plugins with a method for wrapping and unwrapping input to prevent Markdown and Textile from parsing it.
# Purpose: This is useful for preventing Markdown and Textile from being too aggressive and incorrectly parsing in-line HTML.
module TemplateWrapper
  # Wrap input with a <div>
  def safe_wrap(input)
    "<div class='bogus-wrapper'><notextile>#{input}</notextile></div>"
  end
  # This must be applied after the
  def unwrap(input)
    input.gsub /<div class='bogus-wrapper'><notextile>(.+?)<\/notextile><\/div>/m do
      $1
    end
  end
end

