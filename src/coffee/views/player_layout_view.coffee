define ["marionette"], (Marionette)->

  class PlayerLayoutView extends Marionette.LayoutView

    template: "#template-player-layout-view"

    initialize: ->
      @enableFullScreen = false
      @visualizer.on "show", =>
        @visualizer.currentView.on "fullScreen", =>
          @fullScreen()

    fullScreen: =>
      if @enableFullScreen
        jQuery("body").removeClass "full-screen"
        @$el.removeClass "full-screen"
        @enableFullScreen = false
      else
        @
        jQuery("body").addClass "full-screen"
        @$el.addClass "full-screen"
        @enableFullScreen = true

    regions:
      visualizer: ".visualizer"
      controller: ".controller"


