module SocialFilter

  def twitter(input)
    "[@#{input}](http://twitter.com/#{input})"
  end
end

Liquid::Template.register_filter SocialFilter
