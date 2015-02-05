define ["backbone"], (Backbone)->

  class Hack extends Backbone.Model

    defaults: ->
      time: undefined

    idAttribute: "_id"

    initialize: ->

    isSucceeded: ->
      @flagSucceeded ||= @get("verdict")

    getMessage: ->
      Utils = require("utils")
      if @isSucceeded()
        "#{Utils.hackerHandleHTML(@get "defender")} got a <span class=\"text-success\">successful</span> hacking attempt of #{Utils.hackerHandleHTML(@get "hacker")}'s solution"
      else
        "#{Utils.hackerHandleHTML(@get "defender")} got a unsuccessful hacking attempt of #{Utils.hackerHandleHTML(@get "hacker")}'s solution"


