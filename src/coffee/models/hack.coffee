define ["backbone"], (Backbone)->

  class Hack extends Backbone.Model

    initialize: ->

    idAttribute: "_id"

    isSucceeded: ->
      @flagSucceeded ||= @get("verdict")

    getTimeDate: ->
      @timeDate ||= Date.parse(@get "time")

