define ["marionette"], (Marionette)->

  class ContestView extends Marionette.ItemView

    tagName: "tr"

    initialize: ->
      console.debug "ContestView: create instance" if DEBUG

    template: "#template-contest-view"
