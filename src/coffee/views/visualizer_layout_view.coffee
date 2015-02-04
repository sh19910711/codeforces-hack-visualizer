define ["marionette"], (Marionette)->

  class VisualizerLayoutView extends Marionette.LayoutView

    template: "#template-visualizer-layout-view"

    regions:
      "visualizer": ".hack-visualizer"
      "histories": ".hack-histories"

    setDefaultLayout: ->
      @visualizer.$el.addClass "col-sm-7"
      @histories.$el.addClass "col-sm-5"

