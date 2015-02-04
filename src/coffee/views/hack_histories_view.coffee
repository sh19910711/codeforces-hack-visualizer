define ["marionette"], (Marionette)->

  class HackHistoriesView extends Marionette.CompositeView

    template: "#template-hack-histories-view"

    getChildView: ->
      Namespace = require("namespace")
      Namespace::Views::HackHistoryView

