define ["marionette"], (Marionette)->

  class MainRouter extends Marionette.AppRouter

    appRoutes:
      "": "showHome"
      "contests/-/:contest_id": "showContest"

