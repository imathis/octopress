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

class Feedzirra::Parser::RSS
  element :link, :as => :url
  element :title, :as => :author  
end

class Feedzirra::Parser::RSSEntry
  element :no_such_tag, :as => :author_url
end

# A module for compiling feeds into an aggregated feed structure
module FeedAggregator
  extend Octopress::Date

  def self.summary(content)
    if content.index(/<!--\s*more\s*-->/i)
      s = content.split(/<!--\s*more\s*-->/i)[0]
    elsif content.index(/\n\n/)
      s = content.split(/\n\n/)[0]
    else
      return ""
    end
    while s.chomp! do
    end
    s.chomp!("</p>")
    nopt = s.scan("<p>").size
    ncpt = s.scan("</p>").size
    s += " [...]"
    n = nopt-ncpt
    warn "%d more closing </p> tags than opened\n" % [-n] if n < 0
    n.times { s += "</p>" }
    s += "\n"
    s
  end

  def self.age_limit_seconds(age_limit)
    sec = 0
    if /^([0-9]+)\s*(\w*)$/.match(age_limit) then
      nn = $1.to_i
      unit = $2
      case unit
      when "s","sec","secs","second","seconds"
        fs = 1
      when "m","min","mins","minute","minutes"
        fs = 60
      when "h","hour","hours"
        fs = 3600
      when "d","day","days"
        fs = 24*3600
      when "w","week","weeks"
        fs = 7*24*3600
      when "mon","month","months"
        fs = 30*24*3600
      when "y","year","years"
        fs = 365*24*3600
      else
        warn "unrecognized post age limit unit '%s'\n" % [unit]
        return 0
      end
      sec = nn * fs
    else
      warn "unrecognized post age limit '%s'\n" % [post_age_limit]
      return 0
    end
    sec
  end

  def self.compile_feeds(site, params)
    recognized_feed = ['url', 'author', 'author_url']

    # title to use for the blog feed
    title = params['title']

    # max number of posts to take from each feed url
    post_limit = params['post_limit'].to_i

    post_age_limit = age_limit_seconds(params['post_age_limit'])
    full_post_age_limit = age_limit_seconds(params['full_post_age_limit'])

    now = Time.new
    earliest = now - post_age_limit
    earliest_full = now - full_post_age_limit

    # get the list of feed urls
    feeds = params['feed_list']
    feeds.uniq!

    # aggregate all feed urls into a single list of entries
    entries = []
    authors = Set.new()
    feeds.each do |f|
      if f.class <= Hash then
        if not f.key?('url') then
          warn "Ignoring feed missing 'url' key: %s" % [f.to_s]
          next
        end
        feed_url = f['url']
        unk = f.keys - recognized_feed
        warn "Feed %s has unrecognized feed parameters: %s\n" % [feed_url, unk.to_s] if unk.size > 0
      else
        feed_url = f
      end

      begin
        feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      rescue
        feed = nil
      end
      if not feed.respond_to?(:entries) then
        warn "Failed to acquire feed url: %s\n" % [feed_url]
        next
      end
      # apparently I can't assume these, although my patches to parsers above create them
      missing_feed_methods = [:entries, :author, :url].select {|e| not feed.respond_to?(e)} 
      if missing_feed_methods.size > 0 then
        warn "feed %s is missing methods: %s\n" % [feed_url, missing_feed_methods.to_s]
        next
      end

      # take entries, up to the given post limit
      ef = feed.entries
      ef = ef.first(post_limit) if post_limit > 0
      ef = ef.select{|e| e.published >= earliest} if post_age_limit > 0

      # if no entries, skip this feed
      next if ef.length < 1

      # Allow these to be set/overridden from page front-matter
      if f.class <= Hash then
        feed.author = f['author'] if f.key?('author')
        feed.url = f['author_url'] if f.key?('author_url')
      end

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
        e.author = ((f.class <= Hash and f['author']) or e.author or feed.author)
        e.author_url = ((f.class <= Hash and f['author_url']) or e.author_url or feed.url)
        auth = e.author.split(' ')
        authors << { 'first' => auth[0], 'last' => auth[1..-1].join(' '), 'url' => e.author_url }
      end
      entries += ef
    end

    # recast author list to an array, and sort by lastname, firstname
    authors = authors.to_a
    authors.sort! { |a,b| [a['last'],a['first']] <=> [b['last'],b['first']] }

    # eliminate any duplicate blog entries, by post id
    # entry_id doesn't seem 100% reliable so pair it with the url
    entries.uniq! { |e| [e.entry_id, e.url] }

    # sort by pub date, most-recent first
    entries.sort! { |a,b| b.published <=> a.published }

    post_total_limit = params['post_total_limit'].to_i
    entries = entries.first(post_total_limit) if post_total_limit > 0

    full_post_limit = params['full_post_limit'].to_i
    posts = []
    pn = 0
    entries.each do |e|
      pn += 1
      if (full_post_limit >= 0 and pn > full_post_limit) or (full_post_age_limit > 0 and e.published < earliest_full) then
        content = (e.summary or summary(e.content))
      else
        content = (e.content or e.summary)
      end
      posts << {
        'id' => e.entry_id,
        'url' => e.url,
        'title' => e.title,
        'author' => e.author,
        'author_url' => e.author_url,
        'content' => content,
        'date' => e.published,
        'date_formatted' => format_date(e.published, site.config['date_format']),
        'comments' => 'false'
      }
    end

    # return data from compiling the feeds
    {
      'title' => title,
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
      defaults = { 
        'title' => 'Blog Feed', 
        'post_limit' => 5,
        'post_total_limit' => 100,
        'post_age_limit' => '1 year',
        'full_post_limit' => -1,
        'full_post_age_limit' => '0 days',
        'feed_list' => []
      }
      recognized = defaults.keys + ['meta_feed', 'layout']

      # render content for any pages with layout 'feed_aggregator':
      self.pages.select{|p| p.data['layout']=='feed_aggregator'}.each do |page|

        unk = page.data.keys - recognized
        warn "Unrecognized feed aggregator parameters: %s\n" % [unk.to_s] if unk.size > 0

        params = defaults.merge(page.data.select {|k,v| recognized.include?(k)})

        fa_data = page.data

        # compile the requested feeds and save the result on fa_data
        fa_data['feed_aggregator'] = FeedAggregator.compile_feeds(self, params)

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
