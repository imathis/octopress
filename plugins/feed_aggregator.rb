require 'set'
require 'jekyll'
require 'feedzirra'
require './plugins/date'

class Feedzirra::Parser::Atom
  # octopress atom entries don't include author, but I can get it from the feed header,
  # so add another sax parsing rule:
  element :name, :as => :author
end

class Feedzirra::Parser::AtomEntry
  # sax parsing rule to skim post-specific author url.
  # useful for meta-feeds, and/or any feed with multiple authors
  element :uri, :as => :author_url
end

# A module for compiling feeds into an aggregated feed structure
module FeedAggregator
  extend Octopress::Date

  def self.compile_feeds(site, fa_data)
    defaults = { 'title' => 'Blog Feed', 'post_limit' => 5, 'feed_list' => [] }
    @params = defaults.merge(fa_data)

    # title to use for the blog feed
    @title = @params['title']

    # max number of posts to take from each feed url
    @post_limit = @params['post_limit'].to_i

    # get the list of feed urls
    @urls = @params['feed_list']
    @urls.uniq!

    # aggregate all feed urls into a single list of entries
    entries = []
    authors = Set.new()
    @urls.each do |url|
      begin
        feed = Feedzirra::Feed.fetch_and_parse(url)
      rescue
        feed = nil
      end
      if not feed.respond_to?(:entries) then
        warn "Failed to acquire feed url: %s\n" % [url]
        next
      end

      # take entries, up to the given post limit
      ef = feed.entries.first(@post_limit)
      # if no entries, skip this feed
      next if ef.length < 1

      # if there was no feed author, try to get it from a feed entry
      if not feed.author then
        if ef.first.author then
          feed.author = ef.first.author
        else
          # if we found neither, cest la vie
          feed.author = "Author Unavailable"
        end
      end
      # grab author from feed header if it isn't in the entry itself:
      ef.each do |e|
        e.author = feed.author unless e.author
        e.author_url = feed.url unless e.author_url
        auth = e.author.split(' ')
        authors << { 'first' => auth[0], 'last' => auth[1..-1].join(' '), 'url' => e.author_url }
      end
      entries += ef
    end

    # recast author list to an array, and sort by lastname, firstname
    authors = authors.to_a
    authors.sort! { |a,b| [a['last'],a['first']] <=> [b['last'],b['first']] }

    # eliminate any duplicate blog entries, by post id
    # (appears to be using entry url for id, which seems reasonable)
    entries.uniq! { |e| e.entry_id }

    # sort by pub date, most-recent first
    entries.sort! { |a,b| b.published <=> a.published }

    posts = []
    entries.each do |e|
      posts << {
        'id' => e.entry_id,
        'url' => e.url,
        'title' => e.title,
        'author' => e.author,
        'author_url' => e.author_url,
        'content' => e.content,
        'date' => e.published,
        'date_formatted' => format_date(e.published, site.config['date_format']),
        'comments' => 'false'
      }
    end

    # return data from compiling the feeds
    {
      'title' => @title,
      'authors' => authors,
      'posts' => posts
    }    
  end
end


module Jekyll

  class FeedAggregatorPage < Page
    def initialize(page, data)
      # start with a naive copy of 'page'
      page.instance_variables.each {|var| self.instance_variable_set(var, page.instance_variable_get(var))}

      self.process(@name)
      # fun fact: read_yaml() really reads both front-matter and subsequent content:
      self.read_yaml(File.join(@base, '_layouts'), 'feed_aggregator_page.html')

      # load these into data, so they are available to Jekyll/Liquid context:
      @data['title'] = data['title']
      @data['feed_aggregator'] = data['feed_aggregator']
    end
  end


  class FeedAggregatorMeta < Page
    def initialize(page, data)
      # start with a naive copy of 'page'
      page.instance_variables.each {|var| self.instance_variable_set(var, page.instance_variable_get(var))}

      path = data['meta_feed']
      path = 'atom.xml' if path == nil or path == ''

      # now customize path-related stuff based on 'meta_feed' param
      tdir = File.dirname(path)
      @dir = tdir if tdir.size > 0 and tdir != '.'
      if @dir.size > 0  and  @dir[0] != '/' then
        @dir = '/' + @dir
      end
      @ext = File.extname(path)
      @basename = File.basename(path, @ext)
      @name = @basename + @ext
      @url = '/' + @name

      self.process(@name)
      # read_yaml() really reads both front-matter and subsequent content:
      self.read_yaml(File.join(@base, '_layouts'), 'feed_aggregator_meta.xml')

      # load these into data, so they are available to Jekyll/Liquid context:
      @data['title'] = data['title']
      @data['feed_aggregator'] = data['feed_aggregator']
    end
  end


  class Site
    def generate_feed_aggregators
      # render content for any pages with layout 'feed_aggregator':
      self.pages.select{|p| p.data['layout']=='feed_aggregator'}.each do |page|
        fa_data = page.data

        # compile the requested feeds and save the result on fa_data
        fa_data['feed_aggregator'] = FeedAggregator.compile_feeds(self, page.data)

        # render the feed aggregator page
        fa_page = FeedAggregatorPage.new(page, fa_data)
        fa_page.render(self.layouts, site_payload)
        fa_page.write(self.dest)
        self.pages << fa_page

        if fa_data.key?('meta_feed') then
          # a meta feed was requested, so generate that as well
          fa_meta = FeedAggregatorMeta.new(page, fa_data)
          fa_meta.render(self.layouts, site_payload)
          fa_meta.write(self.dest)
          self.pages << fa_meta
        end
      end
    end
  end


  # Add a generator to render feed aggregator content
  # This is apparently detected automagically via ruby introspection
  class GenerateFeedAggregators < Generator
    safe true
    priority :low

    def generate(site)
      site.generate_feed_aggregators
    end
  end
end
