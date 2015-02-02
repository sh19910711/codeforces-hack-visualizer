define ["backbone"], (Backbone)->

  class Contest extends Backbone.Model

    defaults: ->
      title: ""
      topHackers: undefined

    url: ->
      "/api/contests/#{@id}"

    initialize: ->

