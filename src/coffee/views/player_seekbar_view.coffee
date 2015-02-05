define ["marionette"], (Marionette)->
  class PlayerSeekbarView extends Marionette.ItemView

    tagName: "div"

    className: "seek-bar"

    template: "#template-player-seekbar"

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

