define ["backbone"], (Backbone)->

  class Contest extends Backbone.Model

    initialize: ->
      console.debug "Contest: create instance" if DEBUG

