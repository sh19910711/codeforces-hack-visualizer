define ["marionette"], (Marionette)->

  class ContestDetailView extends Marionette.ItemView

    modelEvents:
      "change": "render"

    template: "#template-contest-detail-view"

    templateHelpers: ->
      Utils = require("utils")

      encodedTopHackersText: ->
        if @topHackers
          @topHackers
            .map (hack)->
              "#{Utils.hackerHandleTag(hack.handle)} #{Utils.hackCounter hack.positive, hack.negative}"
            .value()
        else
          encodeURIComponent "loading..."

      encodedFastestSuccessfulHack: ->
        if @quickHackers
          startTime = Date.parse(@start)
          @quickHackers
            .map (hack)->
              hackTime = hack.getTimeDate()
              "#{Utils.hackerHandleTag(hack.get "defender")} <span class=\"text-danger\">(#{Utils.durationAsMinutes startTime, hackTime})</span>"
            .value()
        else
          encodeURIComponent "loading..."

