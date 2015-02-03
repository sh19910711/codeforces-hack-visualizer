define ["backbone"], (Backbone)->

  class Contest extends Backbone.Model

    defaults: ->
      title: ""
      topHackers: undefined

    idAttribute: "_id"

    url: ->
      "/api/contests/#{@id}"

    initialize: ->

