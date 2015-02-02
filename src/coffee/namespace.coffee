define ->

  class Namespace

    class @::Models
      Contest: require("models/contest")
      Hack: require("models/hack")

    class @::Collections
      Contests: require("collections/contests")
      Hacks:    require("collections/hacks")

    class @::Routers
      MainRouter: require("routers/main_router")

    class @::Controllers
      MainController: require("controllers/main_controller")

    class @::Views
      ContestDetailView: require("views/contest_detail_view")
      ContestListView: require("views/contest_list_view")
      ContestListItemView: require("views/contest_list_item_view")
      VisualizerView: require("views/visualizer_view")

