define ["marionette"], (Marionette)->

  class ContestListView extends Marionette.CompositeView

    className: "container"

    template: "#template-contest-list-view"

    childViewContainer: "tbody"

    getChildView: ->
      Namespace = require("namespace")
      Namespace::Views::ContestListItemView

