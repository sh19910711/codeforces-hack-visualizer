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


  sendMessage: (message)->
    postMessage type: "message", message: message

  reportTime: (time)->
    postMessage type: "time", time: time


  startTimer: ->
    startTime = @startTime
    timeToHackFunc = (obj, hack)->
      obj[hack.time] ||= []
      obj[hack.time].push hack
      obj
    timeToHack = @hacks.reduce timeToHackFunc, {}

    curTime = 0
    speed = 60
    @stop = false

    callNext = =>
      @reportTime curTime
      setTimeout func, 1000

    func = =>
      return if @stop
      for i in [1..speed]
        break if @stop
        unless timeToHack[curTime] instanceof Array
          curTime += 1
          continue
        timeToHack[curTime].forEach (hack)->
          postMessage
            type: "hack"
            hack: hack
        curTime += 1
        if curTime >= @duration
          curTime = @duration
          @sendMessage "Contest is finished."
          @stop = true
      callNext()
    @sendMessage "Contest is started..."
    setTimeout func, 100

# create instance
player = new Player
