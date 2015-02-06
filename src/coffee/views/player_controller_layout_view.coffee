define ["marionette", "backbone"], (Marionette, Backbone)->

  class PlayerControllerLayoutView extends Marionette.LayoutView

    channel = Backbone.Wreqr.radio.channel("global")

    template: "#template-player-controller-layout"

    ui:
      playButton: ".player-button.play-button"
      stopButton: ".player-button.stop-button"

    events:
      "click @ui.playButton": "startPlayer"
      "click @ui.stopButton": "stopPlayer"

    initialize: ->
      @flagPlay = false
      channel.vent.on "player:start", =>
        @showStopButton()
      channel.vent.on "player:stop", =>
        @showPlayButton()
      @on "show", ->
        @showPlayButtons()

    showPlayButtons: ->
      if @flagPlay
        @showStopButton()
      else
        @showPlayButton()

    showPlayButton: ->
      @ui.playButton.show()
      @ui.stopButton.hide()

    showStopButton: ->
      @ui.playButton.hide()
      @ui.stopButton.show()

    stopPlayer: ->
      @flagPlay = false
      channel.vent.trigger "player:stop"

    startPlayer: ->
      @flagPlay = true
      channel.vent.trigger "player:start"

    regions:
      contestTime: ".contest-time"
      seekBar: ".seek-bar-region"


