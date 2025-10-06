require 'stringex'

module CategorySlugFilter
  def category_slug(input)
    slug = input.to_s.to_url
    slug.empty? ? input : slug
  end
end

Liquid::Template.register_filter(CategorySlugFilter)
