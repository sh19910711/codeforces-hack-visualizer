define ["marionette"], (Marionette)->
  class PlayerContestTimeView extends Marionette.ItemView

    tagName: "span"

    className: "contest-time player-contest-time"

    template: "#template-player-contest-time"

    modelEvents:
      "change:time": "render"

    templateHelpers: ->
      Utils = require("utils")
      timeText: ->
        Utils.shortTimeText(@time)

