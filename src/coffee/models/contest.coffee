define ["backbone"], (Backbone)->

  class Contest extends Backbone.Model

    defaults: ->
      contestId: undefined
      title: ""
      topHackers: undefined

    idAttribute: "_id"

    url: ->
      "/api/contests/#{@id}"

