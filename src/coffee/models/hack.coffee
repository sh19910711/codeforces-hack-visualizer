define ["backbone"], (Backbone)->

  class Hack extends Backbone.Model

    idAttribute: "_id"

    initialize: ->

    isSucceeded: ->
      @flagSucceeded ||= @get("verdict")

    getTimeDate: ->
      @timeDate ||= Date.parse(@get "time")

