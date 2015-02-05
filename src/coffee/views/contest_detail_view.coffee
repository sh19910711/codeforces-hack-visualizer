define ["marionette", "backbone"], (Marionette, Backbone)->

  class ContestDetailView extends Marionette.ItemView

    template: "#template-contest-detail-view"

    modelEvents:
      "change": "render"


    initialize: ->
      Backbone.Wreqr.radio.channel("global").vent.on "user:change", @render

    templateHelpers: ->
      Utils = require("utils")

      encodedTopHackersText: ->
        if @topHackers
          @topHackers
            .map (hack)->
              "#{Utils.hackerHandleHTML(hack.handle)} #{Utils.hackCounterHTML hack.positive, hack.negative}"
            .value()
        else
          encodeURIComponent "loading..."

      encodedFastestSuccessfulHack: ->
        if @quickHackers
          startTime = Date.parse(@start)
          @quickHackers
            .map (hack)->
              "#{Utils.hackerHandleHTML(hack.get "defender")} <span class=\"text-danger\">(#{Utils.minutesText(hack.get "time")})</span>"
            .value()
        else
          encodeURIComponent "loading..."

