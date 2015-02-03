define [], ->

  class Utils
    @resolveColor: (rating)->
      if rating < 1200
        "user-gray"
      else if rating < 1500
        "user-green"
      else if rating < 1700
        "user-blue"
      else if rating < 1900
        "user-violet"
      else if rating < 2200
        "user-orange"
      else
        "user-red"

