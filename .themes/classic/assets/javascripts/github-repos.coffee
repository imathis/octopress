# Github fetcher for Octopress (c) Brandon Mathis // MIT License
helpers = require('helpers')

GitHub =
  cookie: 'github-feed'
  classname: 'github-feed'

  template: (data)->
    helpers.linkFeed data, @classname

  errorTemplate: ->
    helpers.errorTemplate "Failed to load repo list.", @classname

  addRepo: (repo)->
    title: repo.name
    url:   repo.url
    text:  repo.description
    meta:  repo.meta

  format: (repos, options) ->
    repoList = []

    if options.repos
      filter = []
      filter.push i.trim().toLowerCase() for i in options.repos.split ','

    for repo in repos
      unless repoList.length is options.count
        if options.forks or options.watchers
          repo.meta  = ''
          if options.watchers
            repo.meta += "Watchers: #{repo.watchers}"
          if options.forks
            repo.meta += ' ,' if repo.meta.length > 0
            repo.meta += "Forks: #{repo.forks}"

        if filter and filter.indexOf repo.name.toLowerCase() > -1
          # repo order should match list
          repoList[filter.indexOf repo.name] = @addRepo repo, options
        else if !filter
          repoList.push @addRepo repo, options unless options.skipForks and repo.fork

    repoList

  init: (user, options, callback) ->
    if options.count or options.repos
      feed = $.cookie @cookie
      if feed
        callback @template JSON.parse(feed)
      else
        $.ajax
          url:      "https://api.github.com/users/#{user}/repos?callback=?"
          dataType: 'jsonp'
          error:    (err)  => callback @errorTemplate
          success:  (data) =>
            data =  @format(data.data, options)
            $.cookie @cookie, JSON.stringify data, { path: '/' }
            callback @template data

module.exports = GitHub
