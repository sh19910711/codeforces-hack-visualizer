define ["marionette", "backbone"], (Marionette, Backbone)->

  class AdminController extends Marionette.Controller

    home: ->
      Backbone.Wreqr.radio.vent.trigger "global", "app:title:change", "Admin"

      Namespace = require("namespace")

      adminView = new Namespace::Views::AdminView
      adminView.render()

      Backbone.Wreqr.radio.vent.trigger "global", "app:mainRegion:change", adminView

