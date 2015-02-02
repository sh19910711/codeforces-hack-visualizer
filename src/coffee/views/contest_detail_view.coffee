define ["marionette"], (Marionette)->

  class ContestDetailView extends Marionette.ItemView

    modelEvents:
      "change": "render"

    template: "#template-contest-detail-view"

