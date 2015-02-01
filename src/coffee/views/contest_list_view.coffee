define ["marionette"], (Marionette)->

  class ContestListView extends Marionette.CompositeView

    template: "#template-contest-list-view"

    initialize: ->
      console.debug "ContestListView: create instance" if DEBUG

    childViewContainer: "tbody"

    getChildView: ->
      console.debug "ContestListView: get child view"
      Namespace = require("namespace")
      Namespace::Views::ContestView

