define ["marionette", "backbone"], (Marionette, Backbone)->

  class MainController extends Marionette.Controller

    showIndex: ->
      console.debug "MainController: show index" if DEBUG

      Backbone.Wreqr.radio.vent.trigger "global", "title:change", ""

      Namespace = require("namespace")
      contests = new Namespace::Collections::Contests []
      contest_list_view = new Namespace::Views::ContestListView
      contest_list_view.collection = contests
      Backbone.Wreqr.radio.vent.trigger "global", "region:update", contest_list_view.render()
      contest_list_view.collection.fetch()
        .then null, (err)->
          throw "Error: fetch contests: #{err}"

    showContest: (contestId)->
      Backbone.Wreqr.radio.vent.trigger "global", "title:change", "Contest ##{contestId}"
      console.debug "MainController: show contest ##{contestId}" if DEBUG

