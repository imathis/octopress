# Twitter fetcher for Octopress (c) Brandon Mathis // MIT License
helpers = require('helpers')

Twitter =
  timeline: []
  cookie: 'twitter-feed'
  classname: 'twitter-feed'

  template: ->
    helpers.statusFeed @timeline, @classname

  errorTemplate: ->
    helpers.errorTemplate "Failed to load tweets.", @classname

  parseHtml: (text, urls)->
    # Use twitter entities to replace t.co shortened urls with expanded ones.
    for url in urls
      text = text.replace new RegExp(url.url, 'g'), "<a href='#{url.expanded_url}'>#{url.display_url}</a>" if url.expanded_url
    
    # Trim up and link urls which aren't included in Twitters url entities
    text = text.replace /([^'"])(https?:\/\/)([\w\-:;?&=+.%#\/]+)/gi, (p...) ->
      "#{p[1]}<a href='#{p[2]+p[3]}'>#{helpers.trimUrl(p[3])}</a>"

    # Link up user mentions and hashtags
    text = helpers.linkify text, '@', 'http://twitter.com/'
    text = helpers.linkify text, '#', 'http://search.twitter.com/search?q=%23'

  getTweet: (tweet, user) ->
    type = if tweet.retweeted_status then 'repost' else 'post'
    user = if type is 'repost' then tweet.entities.user_mentions[0].screen_name else user
    post = if type is 'repost' then tweet.retweeted_status else tweet
    {
      url: "https://twitter.com/#{user}/status/#{tweet.id_str}"
      type: type
      date: tweet.created_at
      author: { user: user, url: "http://twitter.com/#{user}" } if type is 'repost'
      text: @parseHtml tweet.text.replace(/\n/g, '<br>'), tweet.entities.urls
    }

  format: (tweets, user) ->
    (@getTweet(tweet, user) for tweet in tweets)
  
  init: (user, options, callback) ->
    tweets = $.cookie('twitter-feed')
    if tweets
      @timeline = JSON.parse(tweets)
      if @timeline.length isnt options.count
        $.removeCookie('twitter-feed')
        @timeline = []
        @init user, options, callback
      else
        callback @template()
    else
      url = "http://api.twitter.com/1/statuses/user_timeline/#{user}.json?trim_user=true&include_entities=1"
      url += "&exclude_replies=1" unless options.replies
      url += "&include_rts=true" if options.include_rts
      url += "&max_id=#{options.max_id}" if options.max_id
      url += "&callback=?"

      $.ajax
        url:      url
        dataType: 'jsonp'
        error:    (err)  => callback @errorTemplate
        success:  (data) => 
          @timeline = @timeline.concat data
          if @timeline.length < options.count
            options.max_id = data.slice(-1)[0].id
            @init user, options, callback
          else 
            @timeline = @format @timeline.slice(0, options.count), user
            $.cookie @cookie, JSON.stringify @timeline, { path: '/' }
            callback @template()

module.exports = Twitter
