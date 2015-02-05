define ["marionette"], (Marionette)->

  class HackHistoryView extends Marionette.ItemView

    tagName: "tr"

    template: "#template-hack-history-view"

    onRender: ->
      @$el
        .css opacity: 0
        .animate opacity: 1.0

