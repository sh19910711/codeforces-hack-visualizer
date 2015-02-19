define ["marionette", "backbone", "d3", "jquery"], (Marionette, Backbone, d3, jQuery)->

  class VisualizerView extends Marionette.ItemView

    DEFAULT_WIDTH   = 400
    DEFAULT_HEIGHT  = 300

    channel = Backbone.Wreqr.radio.channel("global")

    template: "#template-visualizer-view"

    collectionEvents:
      "add": "addNode"

    events:
      "dblclick @ui.svg": "fullScreen"

    ui: ->
      svg: "svg"

    initialize: ->
      @enableFullScreen = false
      @enableForce = true
      channel.vent.on "user:change", @loadParticipants
      channel.vent.on "player:start", @startForce
      channel.vent.on "player:stop", @stopForce
      channel.vent.on "player:fullScreen", @fullScreen

      @on "show", ->
        svgElement = @ui.svg.get(0)
        @svg = d3.select(svgElement)
        @svg.attr "viewBox", "-100 -100 800 800"
        @linkLayer = @svg.append("g").attr("class", "links")
        @nodeLayer = @svg.append("g").attr("class", "nodes")
        @force = d3.layout.force()
          .size [DEFAULT_WIDTH, DEFAULT_HEIGHT]
          .linkStrength 0.12
          .friction 0.9
          .linkDistance 25
          .charge -30
          .gravity 0.1
          .on "tick", @tick
        @nodes = @force.nodes()
        @links = @force.links()


    fullScreen: =>
      if @enableFullScreen
        jQuery("body").removeClass "full-screen"
        @svg.attr "class", ""
        @enableFullScreen = false
      else
        jQuery("body").addClass "full-screen"
        @svg.attr "class", "full-screen"
        @enableFullScreen = true

    startForce: =>
      @enableForce = true
      @redraw()

    stopForce: =>
      @enableForce = false
      @redraw()

    loadParticipants: =>
      participants = channel.reqres.request "user:all"
      @handleToIndex = {}
      participants.each (user, index)=>
        userHandleName = user.get("handle")
        user =
          handle: userHandleName
          rating: user.get("rating")
        @handleToIndex[userHandleName] = user
        @nodes.push user
      @redraw()

    addNode: (hack)->
      hacker = hack.get("defender")
      defender = hack.get("hacker")
      link =
        source: @handleToIndex[hacker]
        target: @handleToIndex[defender]
        verdict: hack.get("verdict")
      @links.push link
      @redraw()

    resetForce: ->
      @force
        .nodes(@nodes)
        .links(@links)
        .start()

    tick: (e)=>
      offset = 100

      @selectLink
        .attr "x1", (link)-> link.source.x + offset
        .attr "y1", (link)-> link.source.y + offset
        .attr "x2", (link)-> link.target.x + offset
        .attr "y2", (link)-> link.target.y + offset

      @selectNode
        .attr "cx", (node)-> node.x + offset
        .attr "cy", (node)-> node.y + offset

    redraw: ->
      Utils = require("utils")

      @selectNode = @nodeLayer.selectAll(".node").data(@nodes)
      @selectLink = @linkLayer.selectAll(".link").data(@links)

      @selectNode
        .enter()
        .append "circle"
        .attr "r", "3px"
        .attr "cx", (node)-> node.x
        .attr "cy", (node)-> node.y
        .attr "handle", (node)-> node.handle
        .attr "class", (node)-> "node " + Utils.resolveColor(node.rating)
        .call @force.drag

      @selectLink
        .enter()
        .append "line"
        .attr "class", "link"
        .attr "x1", (node)-> node.source.x
        .attr "y1", (node)-> node.source.y
        .attr "x2", (node)-> node.target.x
        .attr "y2", (node)-> node.target.y
        .attr "marker-end", (node)->
          if node.verdict
            "url(#arrow-ok)"
          else
            "url(#arrow-ng)"

      @selectNode.classed "fixed", (node)=> node.fixed = not @enableForce

      @resetForce()

