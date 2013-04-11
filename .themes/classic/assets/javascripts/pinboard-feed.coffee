# Pinboard fetcher for Octopress (c) Brandon Mathis // MIT License
helpers = require('helpers')

Pinboard =
  cookie: 'pinboard-feed'
  classname: 'pinboard-feed'

  template: (data) ->
    helpers.linkFeed data, @classname

  errorTemplate: ->
    helpers.errorTemplate "Failed to load pins.", @classname

  format: (feed) ->
    for item in feed
      {
        url:   item.u
        date:  item.dt
        title: item.d
        text:  item.n
        meta: "Tagged: " + ("<a title='view items #{item.a} tagged #{tag}' href='http://pinboard.in/u:#{item.a}/t:#{tag}'>#{tag}</a>" for tag in item.t).join ' '
      }

  init: (user, options, callback) ->
    feed = $.cookie @cookie
    if feed
      callback @template JSON.parse(feed)
    else
      url  = "http://feeds.pinboard.in/json/v1/u:#{user}"
      url += "&count=#{options.count}"

      $.ajax
        url:      url
        dataType: 'jsonp'
        jsonp:    'cb'
        error:    (err)  => callback @errorTemplate
        success:  (data) =>
          data = @format data
          $.cookie @cookie, JSON.stringify data, { path: '/' }
          callback @template data

module.exports = Pinboard
