define ["marionette"], (Marionette)->

  class HackHistoriesView extends Marionette.CompositeView

    template: "#template-hack-histories-view"

    childViewContainer: ".histories tbody"

    getChildView: ->
      Namespace = require("namespace")
      Namespace::Views::HackHistoryView

