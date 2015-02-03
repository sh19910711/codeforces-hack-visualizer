define ["marionette", "backbone"], (Marionette, Backbone)->

  class App extends Marionette.Application

    initialize: ->
      Namespace = require("namespace")

      @channel = Backbone.Wreqr.radio.channel("global")

      @addRegions
        headRegion: "#header"
        mainRegion: "#stage"

      @initAppEvents()
      @initWebApiEvents()
      @initUsersEvents()

      new Namespace::Routers::MainRouter
        controller: new Namespace::Controllers::MainController

      new Namespace::Routers::AdminRouter
        controller: new Namespace::Controllers::AdminController

      @on "start", ->
        @startBackboneHistory()

    initWebApiEvents: ->
      @channel.vent.on "webapi:contests:patch", ->
        Namespace = require("namespace")
        contests = new Namespace::Collections::Contests([])
        contests.update()
          .then ->
            console.log "success update"

    initAppEvents: ->
      @channel.vent.on "app:title:change", (sub_title)->
        if sub_title == ""
          document.title = "Codeforces Hack Visualizer"
        else
          document.title = "#{sub_title} - Codeforces Hack Visualizer"

      @channel.vent.on "app:headRegion:change", (view)=>
        @headRegion.show view

      @channel.vent.on "app:mainRegion:change", (view)=>
        @mainRegion.show view

    initUsersEvents: ->
      participants = []
      promiseFetchParticipants = undefined

      @channel.vent.on "users:load", (contestId)->
        Namespace = require("namespace")
        participants = new Namespace::Collections::Participants [], contestId: contestId
        promiseFetchParticipants = participants.fetch()
          .then ->
            Backbone.Wreqr.radio.vent.trigger "global", "users:change"
        Backbone.Wreqr.radio.vent.trigger "global", "users:change"

      @channel.vent.on "users:change", ->
        jQuery = require("jquery")
        Utils = require("utils")
        promiseFetchParticipants
          .then ->
            participants.each (user)->
              anchor = jQuery(document.createElement "a")
                .attr "href", "http://codeforces.com/profile/#{user.id}"
              jQuery("span[data-user-handle=\"#{user.id}\"]")
                .not ".user"
                .addClass "user"
                .addClass Utils.resolveColor(user.get "rating")
                .wrap anchor


    startBackboneHistory: ->
      Backbone.history.start
        root: "/"
        pushState: true

