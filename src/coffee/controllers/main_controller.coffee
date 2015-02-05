define ["underscore", "marionette", "backbone"], (_, Marionette, Backbone)->

  class MainController extends Marionette.Controller

    showHome: ->
      Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", ""
      Namespace = require("namespace")
      contests = new Namespace::Collections::Contests []
      contest_list_view = new Namespace::Views::ContestListView
        collection: contests
      contests.fetch()
      Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", contest_list_view

    showContest: (contestId)->
      Promise   = require("es6-promise").Promise unless Promise
      Namespace = require("namespace")
      Utils     = require("utils")
      contest   = undefined
      hacks     = undefined
      histories = new Backbone.Collection([], model: Namespace::Models::Hack)
      worker    = new Worker("/js/worker.js")
      hackHistories = new Backbone.Collection([], model: Namespace::Models::Hack)
      contestTime = new Backbone.Model
        time: 0

      # sub-func
      fetchHacks = ->
        hacks = new Namespace::Collections::Hacks [], contest: contest
        hacks.fetch().then =>
          contest.set "topHackers", hacks.topHackers(5)
          contest.set "quickHackers", hacks.quickHackers(5)

      # sub-func
      fetchContest = ->
        Namespace = require("namespace")
        contest = new Namespace::Models::Contest
          contestId: contestId
          title: "loading..."
        contest.id = contestId
        contest.fetch()

      # sub-func
      setTitle = ->
        Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", "loading..."
        promiseFetchContest.then ->
          Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", "#{contest.get "title"}"

      # sub-func
      createHeadView = ->
        view = new Namespace::Views::ContestDetailView
          model: contest
        Backbone.Wreqr.radio.vent.trigger "global", "app:headRegion:change", view

      # sub-func
      initVisualizer = ->
        layoutView = new Namespace::Views::VisualizerLayoutView
        playerLayoutView = new Namespace::Views::PlayerLayoutView
        visualizerView = new Namespace::Views::VisualizerView
          collection: hackHistories
        controllerLayoutView = new Namespace::Views::PlayerControllerLayoutView

        layoutView.on "show", ->
          historiesView = new Namespace::Views::HackHistoriesView
            collection: histories
          @player.show playerLayoutView
          @histories.show historiesView
          @setDefaultLayout()

        playerLayoutView.on "show", ->
          @visualizer.show visualizerView
          @controller.show controllerLayoutView

        controllerLayoutView.on "show", ->
          contestTimeView = new Namespace::Views::PlayerContestTimeView
            model: contestTime
          seekbarView = new Namespace::Views::PlayerSeekbarView
            model: contestTime
            duration: contest.get("duration")
          @contestTime.show contestTimeView
          @seekBar.show seekbarView

        Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", layoutView

      # sub-func
      initWorkerEvents = ->
        onHack = (data)->
          hack = new Namespace::Models::Hack(data.hack)
          message = new Backbone.Model
            time: Utils.shortTimeText(hack.get "time")
            message: hack.getMessage()
          histories.unshift message
          hackHistories.add data.hack

        onMessage = (data)->
          message = new Backbone.Model
            time: "System"
            message: data.message
          histories.unshift message

        onTime = (data)->
          contestTime.set time: data.time

        worker.addEventListener "message", (event)->
          data = event.data
          if data.type == "hack"
            onHack data
          else if data.type == "message"
            onMessage data
          else if data.type == "time"
            onTime data

      # sub-func
      startContestWorker = ->
        hacksJSON = JSON.stringify(
          hacks.map (hack)->
            hack.toJSON()
        )
        worker.postMessage
          type: "command"
          command: "start"
          hacks: hacksJSON
          start: contest.get("start")
          duration: contest.get("duration")

      # show contest
      promiseFetchContest = fetchContest()
      promiseFetchContest.then ->
        # sub-func
        loadUsers = ->
          Promise.all [promiseFetchContest, promiseFetchHacks]
            .then ->
              Backbone.Wreqr.radio.vent.trigger "global", "users:load", contest.id

        startWorker = ->
          initWorkerEvents()
          Promise.all [promiseFetchContest, promiseFetchHacks]
            .then ->
              startContestWorker()

        promiseFetchHacks = fetchHacks()
        createHeadView()
        initVisualizer()
        setTitle()
        loadUsers()
        startWorker()

