define ->

  class Namespace

    class @::Models
      Contest:  require("models/contest")
      Hack:     require("models/hack")
      User:     require("models/user")

    class @::Collections
      Contests: require("collections/contests")
      Hacks:    require("collections/hacks")
      Participants: require("collections/participants")

    class @::Routers
      MainRouter:   require("routers/main_router")
      AdminRouter:  require("routers/admin_router")

    class @::Controllers
      MainController:   require("controllers/main_controller")
      AdminController:  require("controllers/admin_controller")

    class @::Views
      ContestDetailView:    require("views/contest_detail_view")
      ContestListView:      require("views/contest_list_view")
      ContestListItemView:  require("views/contest_list_item_view")
      ContestTimeView:      require("views/contest_time_view")
      PlayerLayoutView:     require("views/player_layout_view")
      PlayerControllerLayoutView: require("views/player_controller_layout_view")
      PlayerContestTimeView: require("views/player_contest_time_view")
      PlayerSeekbarView:    require("views/player_seekbar_view")
      VisualizerView:       require("views/visualizer_view")
      VisualizerLayoutView: require("views/visualizer_layout_view")
      AdminView:            require("views/admin_view")
      HackHistoriesView:    require("views/hack_histories_view")
      HackHistoryView:      require("views/hack_history_view")

