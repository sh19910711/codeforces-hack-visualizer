define ["backbone"], (Backbone)->

  class Contests extends Backbone.Collection

    model: (attrs, options)->
      Namespace = require("namespace")
      new Namespace::Models::Contest attrs, options

    url: ->
      "/api/contests"

    update: ->
      Backbone.sync "patch", @, patch: true
        .then null, (err)->
          console.error "Error: update contests #{err.toString()}" if err

