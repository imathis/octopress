#
# Author: Michael Janssen (added to Octopress by Mark Nichols)
# Queries Amazon Web Services (AWS) using a provided ASIN and returns attributres selected.
#
#   {{ "ASIN" | amazon_link }}
#
#   {{ "ASIN" | amazon_small_image }}
#
#   {{ "ASIN" | amazon_medium_image }}
#
#   {{ "ASIN" | amazon_authors }}
#
# Requires ruby-aaws gem and Amazon Web Services account
#

require 'amazon/aws'
require 'amazon/aws/search'
require 'cgi'

module Jekyll
  class AmazonResultCache
    def initialize
      @result_cache = {}
    end

    @@instance = AmazonResultCache.new

    def self.instance
      @@instance
    end

    def item_lookup(asin)
      asin.strip!
      return @result_cache[asin] if @result_cache.has_key?(asin)
      il = Amazon::AWS::ItemLookup.new('ASIN', {'ItemId' => asin})
      resp = Amazon::AWS::Search::Request.new.search(il)
      @result_cache[asin] = resp
      return resp
    end

    private_class_method :new
  end

  module Filters
    def amazon_link(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      title = item.item_attributes.title.to_s.gsub(/ \[Blu-ray\]/, '').gsub(/ \(Ultimate Edition\)/, '')
      '<a href="%s">%s</a>' % [url, title]
    end

    def amazon_authors(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      authors = item.item_attributes.author.collect(&:to_s)
      array_to_sentence_string(authors)
    end

    def amazon_medium_image(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      image_url = item.image_sets.image_set[0].medium_image.url
      '<a href="%s"><img src="%s" /></a>' % [url, image_url]
    end

    def amazon_large_image(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      image_url = item.image_sets.image_set[0].large_image.url
      '<a href="%s"><img src="%s" /></a>' % [url, image_url]
    end

    def amazon_small_image(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      image_url = item.image_sets.image_set[0].small_image.url
      '<a href="%s"><img src="%s" /></a>' % [url, image_url]
    end

    def amazon_release_date(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item.item_attributes.theatrical_release_date.to_s
    end

    # Movie specific
    def amazon_actors(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      actors = item.item_attributes.actor.collect(&:to_s)
      array_to_sentence_string(actors)
    end

    def amazon_director(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item.item_attributes.director.to_s
    end

    def amazon_running_time(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item.item_attributes.running_time.to_s + " minutes"
    end

  end
end
