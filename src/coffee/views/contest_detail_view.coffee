define ["marionette"], (Marionette)->

  class ContestDetailView extends Marionette.ItemView

    modelEvents:
      "change": "render"

    template: "#template-contest-detail-view"

    templateHelpers: ->
      encodedTopHackersText: ->
        if @topHackers
          @topHackers.chain()
            .map (hack)->
              encodedHandle = encodeURIComponent(hack.handle)
              "<span data-user-handle=\"#{encodedHandle}\">#{encodedHandle}</span>"
            .value()
            .join ", "
        else
          encodeURIComponent "loading..."

