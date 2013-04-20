# App.net fetcher for Octopress (c) Brandon Mathis // MIT License
helpers = require('helpers')

Adn =
  timeline: []
  cookie: 'adn-feed'
  classname: 'adn-feed'

  template: ->
    helpers.statusFeed @timeline, @classname

  errorTemplate: ->
    helpers.errorTemplate "Failed to load posts.", @classname

  parseHtml: (post)->
    text = helpers.trimDisplayUrls post.html
    text = text.replace "@#{mention.name}", "<a href='https://alpha.app.net/#{mention.name}'>@#{mention.name}</a>" for mention in post.entities.mentions
    text = text.replace "##{hashtag.name}", "<a href='https://alpha.app.net/hashtags/#{hashtag.name}'>##{hashtag.name}</a>" for hashtag in post.entities.hashtags
    text

  getPost: (post) ->
    type = if post.repost_of then 'repost' else 'post'
    post = if type is 'repost' then post.repost_of else post
    {
      type: type
      url: post.canonical_url
      date: post.created_at
      author: { user: post.user.username, name: post.user.name, url: post.user.canonical_url } if type is 'repost'
      text: @parseHtml post
    }

  format: (posts, user, options) ->
    postList = []
    for post in posts
      postList.push @getPost(post) unless post.repost_of and !options.reposts
    postList

  init: (user, options, callback) ->
    posts = $.cookie @cookie
    if posts
      @timeline = JSON.parse(posts)
      if @timeline.length isnt options.count
        $.removeCookie @cookie
        @timeline = []
        init user, options, callback
      else
        callback @template()
    else
      url =  "https://alpha-api.app.net/stream/0/users/@#{user}/posts?"
      url += "&max_id=#{options.max_id}" if options.max_id
      url += "&include_directed_posts=0" unless options.replies
      url += "&callback=?"

      $.ajax
        url:      url
        dataType: 'jsonp'
        error:    (err)  => callback @errorTemplate
        success:  (response) =>
          @timeline = @timeline.concat response.data
          if @timeline.length < options.count
            options.max_id = response.meta.max_id
            init user, options, callback
          else
            @timeline = @format @timeline.slice(0, options.count), user, options
            $.cookie @cookie, JSON.stringify @timeline, { path: '/' }
            callback @template()

module.exports = Adn
