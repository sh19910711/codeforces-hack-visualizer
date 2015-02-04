define ["backbone"], (Backbone)->

  class Contest extends Backbone.Model

    idAttribute: "_id"

    defaults: ->
      contestId: undefined
      title: ""
      topHackers: undefined
      successfulHacks: undefined

    url: ->
      "/api/contests/#{@id}"

