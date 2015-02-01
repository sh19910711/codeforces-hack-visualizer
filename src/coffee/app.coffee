define ["marionette"], (Marionette)->

  class App extends Marionette.Application

    initialize: ->
      Namespace = require("namespace")

      @addRegions
        mainRegion: "#stage"

      @initEvents()

      main_router = new Namespace::Routers::MainRouter
        controller: new Namespace::Controllers::MainController

      @on "start", ->
        @startBackboneHistory()

    initEvents: ->
      Backbone = require("backbone")
      channel = Backbone.Wreqr.radio.channel("global")

      channel.vent.on "title:change", (sub_title)->
        console.debug "Radio: on title:change" if DEBUG
        if sub_title == ""
          document.title = "Codeforces Hack Visualizer"
        else
          document.title = "#{sub_title} - Codeforces Hack Visualizer"

      channel.vent.on "region:update", (view)=>
        console.debug "Radio: on region:update" if DEBUG
        @mainRegion.show view

    startBackboneHistory: ->
      console.debug "App: start backbone_history" if DEBUG

      Backbone = require("backbone")
      Backbone.history.start
        root: "/"
        pushState: true

