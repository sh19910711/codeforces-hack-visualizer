define ["marionette", "backbone"], (Marionette, Backbone)->

  class AdminView extends Marionette.ItemView

    template: "#template-admin-view"

    events:
      "click .btn.update-users": "updateUsers"
      "click .btn.update-contests": "updateContests"

    updateUsers: ->
      Backbone.Wreqr.radio.vent.trigger "global", "webapi:users:patch"

    updateContests: ->
      Backbone.Wreqr.radio.vent.trigger "global", "webapi:contests:patch"

