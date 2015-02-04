define ["backbone"], (Backbone)->

  class Utils
    # @params obj [Underscore.chain]
    @countSuccessfulHack: (obj, hack)->
      handle = hack.get("defender")

      setDefaultValues = ->
        defaultValues = {}
        defaultValues[handle] =
          positive: 0
          negative: 0
          time: hack.getTimeDate()
        obj.defaults defaultValues

      setExtendValues = ->
        extendValues = {}
        extendValues[handle] = obj.value()[handle]
        extendValues[handle].time = Math.min(extendValues[handle].time, hack.getTimeDate())
        if hack.isSucceeded()
          extendValues[handle].positive = extendValues[handle].positive + 1
        else
          extendValues[handle].negative = extendValues[handle].negative + 1
        obj.extend extendValues[handle]

      setDefaultValues()
      setExtendValues()

      obj


    @encodedNumber: (x)->
      encodeURIComponent x

    @hackCounterHTML: (plus, minus)->
      if plus > 0 && minus > 0
        "(<span class=\"text-success\">+#{Utils.encodedNumber plus}</span> : <span class=\"text-warning\">-#{Utils.encodedNumber minus}</span>)"
      else if plus > 0
        "(<span class=\"text-success\">+#{Utils.encodedNumber plus}</span>)"
      else if minus > 0
        "(<span class=\"text-warning\">+#{Utils.encodedNumber minus}</span>)"
      else
        ""


    @hackerHandleHTML: (handle)->
      user = Backbone.Wreqr.radio.channel("global").reqres.request("user:find", handle)
      encodedHandle = encodeURIComponent(handle)
      return encodedHandle unless user
      "<span data-user-handle=\"#{encodedHandle}\" class=\"user #{Utils.resolveColor user.get("rating")}\">#{encodedHandle}</span>"


    @durationAsMinutes: (from, to)->
      Moment = require("moment/min/moment.min.js")
      duration = Moment(to).diff Moment(from)
      min = parseInt(Moment.duration(duration).asMinutes(), 10)
      "#{min} min."


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

