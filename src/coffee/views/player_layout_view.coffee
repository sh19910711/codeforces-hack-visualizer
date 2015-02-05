define ["marionette"], (Marionette)->

  class PlayerLayoutView extends Marionette.LayoutView

    template: "#template-player-layout-view"

    regions:
      visualizer: ".visualizer"
      controller: ".controller"


