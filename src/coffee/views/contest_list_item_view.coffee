define ["marionette"], (Marionette)->

  class ContestListItemView extends Marionette.ItemView

    tagName: "tr"

    initialize: ->

    template: "#template-contest-list-item-view"

