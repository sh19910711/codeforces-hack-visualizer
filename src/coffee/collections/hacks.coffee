define ["underscore", "backbone"], (_, Backbone)->

  class Hacks extends Backbone.Collection

    initialize: (models, options)->
      @contestId = options.contestId


    url: ->
      "/api/contests/#{@contestId}/hacks"


    model: (attrs, options)->
      Namespace = require("namespace")
      new Namespace::Models::Hack attrs, options


    successfulHacks: ->
      @chain()
        .select (hack)->
          hack.isSucceeded()

    quickHackers: (limit)->
      @successfulHacks()
        .sortBy (hack)->
          hack.getTimeDate()
        .uniq false, (hack)->
          hack.get "defender"
        .slice 0, limit

    topHackers: (limit)->
      # extract successful hacks
      # sort by count, time...
      Utils = require("utils")
      @chain()
        .inject Utils.countSuccessfulHack, _.chain({})
        .map (hack, handle)->
          handle: handle
          positive: hack.positive
          negative: hack.negative
          time: hack.time
        .sortBy (hack)->
          -hack.time
        .sortBy (hack)->
          hack.positive * 100 - hack.negative * 50
        .reverse()
        .slice 0, limit

