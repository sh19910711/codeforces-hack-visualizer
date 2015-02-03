define ["underscore", "backbone"], (_, Backbone)->

  class Hacks extends Backbone.Collection

    initialize: (models, options)->
      @contestId = options.contestId

    url: ->
      "/api/contests/#{@contestId}/hacks"

    model: (attrs, options)->
      Namespace = require("namespace")
      new Namespace::Models::Hack attrs, options

    topHackers: (limit)->
      countFunc = (obj, hack)->
        handle = hack.get("hacker")
        obj[handle] ||= count: 0, time: undefined
        obj[handle].time ||= hack.get("time")
        obj[handle].time = Math.min(obj[handle].time, hack.get "time")
        obj[handle].count += 1
        obj

      # extract successful hacks
      counted = @chain()
        .select (hack)->
          hack.get("verdict")
        .inject countFunc, {}

      # sort by count, time...
      sortedList = _.chain(counted)
        .map (hack, handle)->
          handle: handle
          count: hack.count
          time: hack.time
        .sortBy (hack)->
          -hack.time
        .sortBy (hack)->
          hack.count
        .reverse()
        .slice 0, 5

