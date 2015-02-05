define ["marionette"], (Marionette)->

  class VisualizerLayoutView extends Marionette.LayoutView

    className: "container no-padding"

    template: "#template-visualizer-layout-view"

    regions:
      "player": ".hack-visualizer-player"
      "histories": ".hack-histories"

    setDefaultLayout: ->
      @player.$el.addClass "col-sm-8"
      @histories.$el.addClass "col-sm-4"

