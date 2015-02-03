define ["backbone"], (Backbone)->
  
  class Participants extends Backbone.Collection
  
    initialize: (models, options)->
      @contestId = options.contestId

    url: ->
      "/api/contests/#{@contestId}/users"

    model: (attrs, options)->
      Namespace = require("namespace")
      new Namespace::Models::User attrs, options

