define ->

  class Namespace

    class @::Models
      Contest: require("models/contest")

    class @::Collections
      Contests: require("collections/contests")

    class @::Routers
      MainRouter: require("routers/main_router")

    class @::Controllers
      MainController: require("controllers/main_controller")

    class @::Views
      ContestListView: require("views/contest_list_view")
      ContestView: require("views/contest_view")

