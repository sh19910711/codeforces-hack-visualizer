define ["marionette", "backbone"], (Marionette, Backbone)->

  class App extends Marionette.Application

    initialize: ->
      Namespace = require("namespace")

      @addRegions
        headRegion: "#header"
        mainRegion: "#stage"

      @initAppEvents()
      @initWebApiEvents()

      new Namespace::Routers::MainRouter
        controller: new Namespace::Controllers::MainController

      new Namespace::Routers::AdminRouter
        controller: new Namespace::Controllers::AdminController

      @on "start", ->
        @startBackboneHistory()

    initWebApiEvents: ->
      Namespace = require("namespace")
      channel = Backbone.Wreqr.radio.channel("global")

      channel.vent.on "webapi:contests:patch", ->
        contests = new Namespace::Collections::Contests([])
        contests.update()
          .then ->
            console.log "success update"

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

    startBackboneHistory: ->
      Backbone.history.start
        root: "/"
        pushState: true

