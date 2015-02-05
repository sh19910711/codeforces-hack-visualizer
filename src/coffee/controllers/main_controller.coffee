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
      Promise = require("es6-promise").Promise unless Promise
      Namespace = require("namespace")
      Utils = require("utils")
      contest = undefined
      hacks = undefined
      hackHistories = new Backbone.Collection [], model: Namespace::Models::Hack
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
      createVisualizer = ->
        layoutView = new Namespace::Views::VisualizerLayoutView
        playerLayoutView = new Namespace::Views::PlayerLayoutView

        layoutView.on "show", ->
          hackHistoriesView = new Namespace::Views::HackHistoriesView
            collection: hackHistories
          @player.show playerLayoutView
          @histories.show hackHistoriesView
          @setDefaultLayout()

        playerLayoutView.on "show", ->
          visualizerView = new Namespace::Views::VisualizerView
          controllerLayoutView = new Namespace::Views::PlayerControllerLayoutView
          controllerLayoutView.on "show", ->
            contestTimeView = new Marionette.ItemView
              tagName: "span"
              className: "contest-time player-contest-time"
              template: "#template-player-contest-time"
              model: contestTime
              modelEvents:
                "change:time": "render"
              templateHelpers:
                timeText: ->
                  Utils.shortTimeText(@time)
            class SeekBarView extends Marionette.ItemView
              tagName: "div"
              className: "seek-bar"
              template: "#template-player-seekbar"
              model: contestTime
              modelEvents: ->
                "change:time": "applyTime"
              ui: ->
                progressBar: ".progress-bar"
              events: ->
                "mousemove": "moveTooltip"
              initialize: (options)->
                @duration = options.duration
              applyTime: ->
                curTime = @model.get("time")
                @ui.progressBar.css "width", "#{curTime / @duration * 100.0}%"
            seekBarView = new SeekBarView
              duration: contest.get("duration")
            @contestTime.show contestTimeView
            @seekBar.show seekBarView
          @visualizer.show visualizerView
          @controller.show controllerLayoutView

        Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", layoutView

      # show contest
      promiseFetchContest = fetchContest()
      promiseFetchContest.then ->
        # sub-func
        loadUsers = ->
          Promise.all [promiseFetchContest, promiseFetchHacks]
            .then ->
              Backbone.Wreqr.radio.vent.trigger "global", "users:load", contest.id

        startWorker = ->
          worker = new Worker("/js/worker.js")

          worker.addEventListener "message", (event)->
            data = event.data
            if data.type == "hack"
              hack = new Namespace::Models::Hack(data.hack)
              message = new Backbone.Model
                time: Utils.shortTimeText(hack.get "time")
                message: hack.getMessage()
              hackHistories.unshift message
            else if data.type == "message"
              message = new Backbone.Model
                time: "System"
                message: data.message
              hackHistories.unshift message
            else if data.type == "time"
              contestTime.set time: data.time

          Promise.all [promiseFetchContest, promiseFetchHacks]
            .then ->
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

        promiseFetchHacks = fetchHacks()
        createHeadView()
        createVisualizer()
        setTitle()
        loadUsers()
        startWorker()

