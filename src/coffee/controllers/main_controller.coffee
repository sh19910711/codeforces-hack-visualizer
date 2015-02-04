define ["underscore", "marionette", "backbone"], (_, Marionette, Backbone)->

  class MainController extends Marionette.Controller

    showHome: ->
      Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", ""

      Namespace = require("namespace")
      contests = new Namespace::Collections::Contests []
      contest_list_view = new Namespace::Views::ContestListView
      contest_list_view.collection = contests
      Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", contest_list_view.render()
      contest_list_view.collection.fetch()
        .then null, (err)->
          throw "Error: fetch contests: #{err}"


    showContest: (contestId)->
      Namespace = require("namespace")
      contest = undefined
      hacks = undefined

      # sub-func
      fetchHacks = ->
        hacks = new Namespace::Collections::Hacks [], contestId: contest.id
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
        layoutView.on "show", ->
          visualizerView = new Namespace::Views::VisualizerView
          hackHistoriesView = new Namespace::Views::HackHistoriesView
            collection: hacks
          @visualizer.show visualizerView
          @histories.show hackHistoriesView
          @setDefaultLayout()
        Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", layoutView

      # sub-func
      loadUsers = ->
        Promise.all [promiseFetchContest, promiseFetchHacks]
          .then ->
            Backbone.Wreqr.radio.vent.trigger "global", "users:load", contest.id

      # show contest
      promiseFetchContest = fetchContest()
      promiseFetchHacks = fetchHacks()
      createHeadView()
      createVisualizer()
      setTitle()
      loadUsers()

