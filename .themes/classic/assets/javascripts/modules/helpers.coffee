# Helper methods for Octopress (c) 2013 Brandon Mathis // MIT License

Helpers =
  # Template helpers

  linkFeed: (feed, classname)->
    "<ul class='#{classname}'>" + (for item in feed
      text  = "<li class='feed-item'>"
      text += "<p class='title'><a href='#{item.url}'>#{item.title.replace '<','&lt;'}</a></p>"
      text += "<p class='text'>#{item.text.replace '<','&lt;'}</p>"
      text += "<p class='meta'>#{item.meta}</p>" if item.meta
      text += "</li>"
    ).join('') + "</ul>"

  statusFeed: (feed, classname = '')->
    "<ul class='#{classname}'>" + (for post in feed
      text  = "<li class='status-item'>"
      text += "<p><a href='#{post.url}'>#{@timeago post.date}</a>#{post.text}</p>"
      text += "</li>"
    ).join('') + "</ul>"

  errorTemplate: (message, service = '') ->
    "<p class='#{service} feed-error'>#{message}</p>"

  htmlEscape: (str) ->
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')

  # Url helpers

  trimUrl: (url)->
    parts = []
    for part in url.split '/'
      parts.push part if parts.concat(part).join('/').length < 35
    parts = parts.join('/')
    if parts.length < url.length then parts + '&hellip;' else parts

  linkify: (text, marker, url) ->
    text.replace new RegExp("(^|\\W|>)(#{marker})([^\\s<]+)", 'g'), "$1<a href='#{url}$3'>$2$3</a>"

  trimDisplayUrls: (text)->
    text.replace />https?:\/\/([^\s<]+)/gi, (match, p1)=>
      ">#{@trimUrl(p1)}"

  # ----------#
  # Utilities #
  # ----------#

  # Sort an array of objects on a given key

  sortByKey: (list, key, order='asc') ->
    list = list.sort (a,b)->
      if a[key] > b[key] then 1 else if b[key] > a[key] then -1 else 0
    if order is 'desc' then list.reverse() else list


  # Timeago based on JavaScript Pretty Date Copyright (c) 2011 John Resig

  timeago: (time)->
    say =
      just_now:    "now"
      minute_ago:  "1m"
      minutes_ago: "m"
      hour_ago:    "1h"
      hours_ago:   "h"
      yesterday:   "1d"
      days_ago:    "d"
      last_week:   "1w"
      weeks_ago:   "w"

    time  = time.replace(/-/g,"/").replace(/[TZ]/g," ")
    secs  = ((new Date().getTime() - new Date(time).getTime()) / 1000)
    mins  = Math.floor secs / 60
    hours = Math.floor secs / 3600
    days  = Math.floor secs / 86400
    weeks = Math.floor days / 7

    return '#' if isNaN(secs) or days < 0

    if days is 0
      if      secs < 60   then say.just_now
      else if secs < 120  then say.minute_ago
      else if secs < 3600 then mins + say.minutes_ago
      else if secs < 7200 then say.hour_ago
      else                     hours + say.hours_ago
    else
      if days is 1        then say.yesterday
      else if days < 7    then days + say.days_ago
      else if days is 7   then say.last_week
      else                     weeks + say.weeks_ago

module.exports = Helpers
