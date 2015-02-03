define ["marionette"], (Marionette)->

  class MainRouter extends Marionette.AppRouter

    appRoutes:
      "": "home"
      "contests/-/:contest_id": "contest"

