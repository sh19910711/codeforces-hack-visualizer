define ["backbone"], (Backbone)->

  class Hacks extends Backbone.Collection

    initialize: (models, options)->
      @contestId = options.contestId

    url: ->
      "/api/contests/#{@contestId}/hacks"

    model: (attrs, options)->
      Namespace = require("namespace")
      new Namespace::Models::Hack attrs, options

