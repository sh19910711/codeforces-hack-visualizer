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
      participants = undefined

      findUser = (handle)->
        participants && participants.find (user)->
          handle == user.get("handle")

      allUsers = ->
        participants

      loadUsers = (contestId)->
        participants = new Namespace::Collections::Participants [], contestId: contestId
        promiseFetchParticipants = participants.fetch()
          .then ->
            channel.vent.trigger "users:change"

      channel.reqres.setHandler "user:find", findUser
      channel.reqres.setHandler "user:all", allUsers
      channel.vent.on "users:load", loadUsers


    startBackboneHistory: ->
      Backbone.history.start
        root: "/"
        pushState: true

