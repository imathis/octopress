---
layout: post
title: "Amazon Plugin for Octopress"
date: 2011-08-24 07:37
comments: true
categories: nerdliness
link: false
---
For some time I have wanted to be able to include links to books or movies that I've read or watched on my site. I had seen [Adam Polselli's Readernaut Widget](http://adampolselli.com/2009/03/31/building-a-readernaut-widget/ "Adam Polselli's Building a Readernaut Widget") posting a couple of years ago, but had never taken the time to implement it. While I was searching to find it again, I came across this posting about [Amazon liquid filters for Jekyll](http://base0.net/posts/amazon-liquid-filters-for-jekyll/ "Amazon liquid filter for Jekyll") and realized it was exactly what I was looking for.

Here is how I took the Jekyll plugin that [Michael Janssen](http://base0.net/about.html "Michael Janssen") describes and incorporated it into Octopress.

## Get the ruby-aaws Gem
There is a Ruby gem that encapsulates the Amazon Web Services API, making it very simple to query Amazon and parse the result. Make sure you grab the **ruby-aaws** gem and not the older, deprecated **ruby-aws** one. If you are using RVM, you'll need to ensure that you install the gem for the version of Ruby that supports your Octopress installation, in my case ruby-1.9.2.

{% codeblock %}
$ rvm use ruby-1.9.2
$ gem install ruby-aaws
{% endcodeblock %}

Just for completeness sake, I also edited the **Gemfile** located in the root of the Octopress installation to add the new dependency on ruby-aaws.

{% codeblock Gemfile %}
source "http://rubygems.org"

gem 'rake'
gem 'rack'
gem 'jekyll'
gem 'rdiscount'
gem 'pygments.rb'
gem 'RedCloth'
gem 'haml', '>= 3.1'
gem 'compass', '>= 0.11'
gem 'rubypants'
gem 'rb-fsevent'
gem 'ruby-aaws'
{% endcodeblock %}

## Create the amazon-liquid-tags plugin
For the source of the plugin code I copied [Mr. Janssen's plugin from Github](https://github.com/jamuraa/base0.net/blob/master/_plugins/amazon_liquid_tags.rb "amazon_liquid_tags.rb"). Or you can copy it from below:

{% codeblock Amazon Liquid Tags - amazon_liquid_tags.rb%}
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
{% endcodeblock %}

This file goes in your **plugins** directory. It really doesn't matter what you call this, what does matter is that you use one (or more) of the functions defined within the plugin inside Liquid tags to interact with AWS.

## Get an Amazon Web Services Account
If you don't already have one, create an [Amazon Web Services](http://aws.amazon.com/ "Amazon Web Services") (AWS) account. Depending on what you use it for in addition to the API lookups this plugin will perform, there may be a monthly charge for this service. As near as I can tell, the queries this plugin performs are free.

From your AWS account you will need your **Access Key ID** and your **Secret Access Key**. These can be found by going to the **Account** tab, and then clicking on the **Security Credentials** link in the left sidebar. 

## Configuring ruby-aaws
ruby-aaws uses a configuration file, that contains your AWS security credentials, to interact with Amazon. Create a file in your HOME directory called **.amazonrc** and copy and paste the following lines to it:

{% codeblock .amazonrc %}
# My .amazonrc file for use with ruby-aaws.
key_id = 'YOUR-ACCESS-KEY-GOES-HERE'
secret_key_id = 'YOUR-SECRET-KEY-GOES-HERE'
associate = 'YOUR-ASSOCIATES-ID-GOES-HERE'
cache = false
locale = 'us'
encoding = 'UTF-8'
{% endcodeblock %}

Edit the file, substituting your Access Key, Secret Key, and Associate ID (if you have one) for the place holders. If you don't have an Associate ID (and or you live where Amazon no long pays associates due to tax laws) and you want to be incredibly generous, you can use my id, **zanshinnet**.

The ruby-aaws gem will look for this file and use it on your machine when you generate your site and you've made use of one of the Amazon liquid tags. Since the .amazonrc file lives on your computer it is relatively safe, however, I changed the file permissions to '600' (owner read/write only) just to be thorough.

Read through the README and INSTALL files that come with ruby-aaws for a complete set of documentation for using the gem. I haven't yet explored the **cache** option in the .amazonrc file, but that may improve the gems performance, especially if you have  large number of Amazon queries embedded in your site over time.

## Use the Plugin
You are now ready to use the Amazon liquid tags in postings or asides. For any item you wish to link to find the **ASIN** number embedded in the Amazon URL and include it in a tag. For example, if I wanted a text-only link to the new Ruby book, {{ "1933988657" | amazon_link }}, I would embed this liquid tag in my code: \{\{ "1933988657" | amazon\_link \}\}. I could just as easily display an image of the book's cover with \{\{ "1933988657" | amazon\_medium\_image}}, like so:

{{ "1933988657" | amazon_medium_image }}

The ASIN is fairly easy to spot in the Amazon URL. In my case I wanted to have links to Amazon things appear (primarily) in the sidebar. So I created a new HTML file in **source/\_includes/custom/asides** called **aws.html** that looks something like this:

{% codeblock %}
<section>
  <h1>Recent Diversions</h1>
  <p> 
	\{\{ "0743276396" | amazon_medium_image \}\}
  </p>
  <p>
	\{\{ "0743276396" | amazon_link \}\}
	by \{\{ "0743276396" | amazon_authors \}\}
  </p>
</section>
{% endcodeblock %}

(I apologize for the the back-slashes used to escape the curly-brackets in the above example. Without them the liquid tag renders, making it useless as an example. If anyone knows how to properly embed liquid tags without them rendering, please leave a comment below and I'll update this example.)

## Site Generation
With all the pieces in place you are ready to generate your site. During generation the ruby-aaws gem will read your .amazonrc file, and will query AWS to look up any ASINs you've included. With only two books listed in my sidebar (I don't plan on having more than two or three items at any one time) I didn't notice an appreciable increase in site generation time. But I suspect that a large(r) number of queries could slow your generation down. As always, YMMV.