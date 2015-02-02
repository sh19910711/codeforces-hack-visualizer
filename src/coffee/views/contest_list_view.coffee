define ["marionette"], (Marionette)->

  class ContestListView extends Marionette.CompositeView

    template: "#template-contest-list-view"

    initialize: ->

    childViewContainer: "tbody"

    getChildView: ->
      Namespace = require("namespace")
      Namespace::Views::ContestListItemView

