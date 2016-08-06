# jekyll-500px-embed
# ------------------
# A Liquid tag for Jekyll for embedding 500px photos
# Author: Luke Korth (github.com/lkorth)
#
# Example: {% 500px 89255597 %}
# Embeds 500px photo with id 89255597

require 'net/https'
require 'uri'
require 'json'

module Jekyll
  class FiveHundredPxTag < Liquid::Tag

    def initialize(tag_name, photo_id, token)
      super
      @photo_id = photo_id.strip
    end

    def render(context)
      consumer_key = File.read(context.registers[:site].config['500px_consumer_key_file']).strip
      photo = fetch_photo(@photo_id, consumer_key)

      <<-EOF
<div class="pixels-photo">
  <p><img src="#{photo['image_url']}" alt="#{photo['name']} by #{photo['user']['fullname']} on 500px"></p>
  <a href="https://500px.com/#{photo['url']}">#{photo['name']} by #{photo['user']['fullname']} on 500px</a>
</div>
      EOF
    end

    def fetch_photo(photo_id, consumer_key)
      uri = URI.parse("https://api.500px.com/v1/photos/#{photo_id}?image_size=4&consumer_key=#{consumer_key}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      photo = JSON.parse(http.request(Net::HTTP::Get.new(uri.request_uri)).body)
      photo['photo']
    end
  end
end

Liquid::Template.register_tag('500px', Jekyll::FiveHundredPxTag)
