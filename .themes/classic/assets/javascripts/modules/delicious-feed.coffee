# Delicious fetcher for Octopress (c) Brandon Mathis // MIT License
helpers = require('helpers')

Delicious =
  cookie: 'delicious-feed'
  classname: 'delicious-feed'

  template: (data) ->
    helpers.linkFeed data, @classname

  errorTemplate: ->
    helpers.errorTemplate "Failed to load bookmarks.", @classname

  format: (feed) ->
    for item in feed
      {
        url:   item.u
        date:  item.dt
        title: item.d
        text:  item.n
        meta: "Tagged: " + ("<a title='view items #{item.a} tagged #{tag}' href='http://delicious.com/#{item.a}/#{tag}'>#{tag}</a>" for tag in item.t).join ' '
      }

  init: (user, options, callback) ->
    feed = $.cookie @cookie
    if feed
      callback @template JSON.parse(feed)
    else
      $.ajax
        url:      "http://feeds.delicious.com/v2/json/#{user}?&count=#{options.count}&callback=?"
        dataType: 'jsonp'
        error:    (err)  => callback @errorTemplate
        success:  (data) =>
          data = @format data
          $.cookie @cookie, JSON.stringify data, { path: '/' }
          callback @template data

module.exports = Delicious
