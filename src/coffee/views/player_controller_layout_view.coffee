define ["marionette"], (Marionette)->

  class PlayerControllerLayoutView extends Marionette.LayoutView

    template: "#template-player-controller-layout"

    regions:
      contestTime: ".contest-time"


