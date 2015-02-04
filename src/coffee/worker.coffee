class Player

  constructor: ->
    addEventListener "message", (event)=>
      data = event.data
      if data.type == "command"
        if data.command == "start"
          @startTime = Date.parse(data.start)
          @hacks = JSON.parse(data.hacks)
          @startTimer()
          @duration = data.duration
        else if data.command == "stop"
          @stop = true

  startTimer: ->
    startTime = @startTime
    timeToHackFunc = (obj, hack)->
      hackTime = Date.parse(hack.time)
      dateTime = ( hackTime - startTime ) / 1000
      obj[dateTime] ||= []
      obj[dateTime].push hack
      obj
    timeToHack = @hacks.reduce timeToHackFunc, {}

    curTime = 0
    speed = 60 * 5
    @stop = false

    func = =>
      @stop = true if curTime >= @duration
      return if @stop
      for i in [1..speed]
        unless timeToHack[curTime] instanceof Array
          curTime += 1
          continue
        timeToHack[curTime].forEach (hack)->
          postMessage
            type: "hack"
            hack: hack
        curTime += 1
      setTimeout func, 1000
    setTimeout func, 1000

# create instance
player = new Player
