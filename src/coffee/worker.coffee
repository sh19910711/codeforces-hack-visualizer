class Player

  constructor: ->
    @curTime = 0
    @speed = 60
    @stop = true
    @flagStart = false
    @flagFinish = false

    addEventListener "message", (event)=>
      data = event.data
      if data.type == "command"
        if data.command == "start"
          @stop = false
          @startTimer()
        else if data.command == "stop"
          @stop = true
      else if data.type == "set:hacks"
        @hacks = JSON.parse(data.hacks)
      else if data.type == "set:contest"
        @startTime = Date.parse(data.start)
        @duration = data.duration
      else if data.type == "timer:start"
        @stop = false
        @startTimer()
      else if data.type == "timer:stop"
        @stop = true
      else
        throw new Error("ERROR: unknown query: #{data.type || data}")


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

    callNext = =>
      @duration = @curTime if @curTime > @duration
      @reportTime @curTime
      if @curTime < @duration
        setTimeout func, 1000

    func = =>
      return if @stop
      for i in [1..@speed]
        break if @stop
        unless timeToHack[@curTime] instanceof Array
          @curTime += 1
          continue
        timeToHack[@curTime].forEach (hack)->
          postMessage
            type: "hack"
            hack: hack
        @curTime += 1
        if @curTime >= @duration
          @curTime = @duration
          @sendMessage "Contest is finished."
          @stop = true
      callNext()

    unless @flagStart
      @flagStart = true
      @sendMessage "Contest is started..."
    setTimeout func, 100


# create instance
player = new Player
