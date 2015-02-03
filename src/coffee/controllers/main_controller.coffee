define ["underscore", "marionette", "backbone"], (_, Marionette, Backbone)->

  class MainController extends Marionette.Controller

    home: ->
      Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", ""

      Namespace = require("namespace")
      contests = new Namespace::Collections::Contests []
      contest_list_view = new Namespace::Views::ContestListView
      contest_list_view.collection = contests
      Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", contest_list_view.render()
      contest_list_view.collection.fetch()
        .then null, (err)->
          throw "Error: fetch contests: #{err}"

    contest: (contestId)->
      Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", "loading..."

      Namespace = require("namespace")

      contest = new Namespace::Models::Contest
        title: "loading..."
      contest.id = contestId
      contest_detail_view = new Namespace::Views::ContestDetailView
        model: contest
      Backbone.Wreqr.radio.vent.trigger "global", "app:headRegion:change", contest_detail_view

      promises = []

      promiseContest = contest.fetch()
        .then ->
          Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", "#{contest.get "title"}"

      hacks = new Namespace::Collections::Hacks [], contestId: contestId
      promiseHacks = hacks.fetch().then ->
        contest.set "topHackers", hacks.topHackers(5)

      Promise.all [promiseContest, promiseHacks]
        .then ->
          Backbone.Wreqr.radio.vent.trigger "global", "users:load", contest.id

