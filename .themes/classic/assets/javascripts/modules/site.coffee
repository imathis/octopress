adn       = require('adn')
pinboard  = require('pinboard')
delicious = require('delicious')
github    = require('github')

Site =
  init: ->
    adn.init 'imathis', { count: 3 }, (posts)->
      console.log posts

module.exports = Site
