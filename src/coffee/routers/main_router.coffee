define ["marionette"], (Marionette)->

  class MainRouter extends Marionette.AppRouter

    appRoutes:
      "": "showIndex"
      "contests/-/:contest_id": "showContest"


