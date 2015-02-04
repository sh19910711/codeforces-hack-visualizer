define ["marionette", "backbone"], (Marionette, Backbone)->

  class App extends Marionette.Application

    initialize: ->
      @initRegions()
      @initAppEvents()
      @initWebApiEvents()
      @initUsersEvents()
      @initRouters()
      @on "start", ->
        @startBackboneHistory()


    initRegions: ->
      @addRegions
        headRegion: "#header"
        mainRegion: "#stage"


    initRouters: ->
      Namespace = require("namespace")

      new Namespace::Routers::MainRouter
        controller: new Namespace::Controllers::MainController

      new Namespace::Routers::AdminRouter
        controller: new Namespace::Controllers::AdminController


    initWebApiEvents: ->
      Namespace = require("namespace")
      channel = Backbone.Wreqr.radio.channel("global")
      channel.vent.on "webapi:contests:patch", ->
        contests = new Namespace::Collections::Contests([])
        contests.update()


    initAppEvents: ->
      channel = Backbone.Wreqr.radio.channel("global")

      channel.vent.on "app:title:change", (sub_title)->
        if sub_title == ""
          document.title = "Codeforces Hack Visualizer"
        else
          document.title = "#{sub_title} - Codeforces Hack Visualizer"

      channel.vent.on "app:headRegion:change", (view)=>
        @headRegion.show view

      channel.vent.on "app:mainRegion:change", (view)=>
        @mainRegion.show view


    initUsersEvents: ->
      Namespace = require("namespace")
      channel = Backbone.Wreqr.radio.channel("global")
      participants = undefined
      promiseFetchParticipants = undefined

      loadUsers = (contestId)->
        participants = new Namespace::Collections::Participants [], contestId: contestId
        promiseFetchParticipants = participants.fetch()
          .then ->
            Backbone.Wreqr.radio.vent.trigger "global", "users:change"
        Backbone.Wreqr.radio.vent.trigger "global", "users:change"

      applyUserColors = ->
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

      channel.vent.on "users:load", loadUsers
      channel.vent.on "users:change", applyUserColors


    startBackboneHistory: ->
      Backbone.history.start
        root: "/"
        pushState: true

