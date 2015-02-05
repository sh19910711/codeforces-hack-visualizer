define ["marionette", "backbone", "d3"], (Marionette, Backbone, d3)->

  class VisualizerView extends Marionette.ItemView

    channel = Backbone.Wreqr.radio.channel("global")

    template: "#template-visualizer-view"

    collectionEvents:
      "add": "addNode"

    ui: ->
      svg: "svg"

    initialize: ->
      channel.vent.on "user:change", @loadParticipants

      @on "show", ->
        svgElement = @ui.svg.get(0)
        @svg = d3.select(svgElement)
        @nodes = []
        @links = []
        @force = d3.layout.force()
          .nodes(@nodes)
          .links(@links)
          .size [400, 300]
          .linkStrength 0.1
          .friction 0.9
          .linkDistance 20
          .charge -30
          .gravity 0.1
          .on "tick", @tick

    loadParticipants: =>
      participants = channel.reqres.request "user:all"
      @handleToIndex = {}
      @nodes = participants.map (user, index)=>
        userHandleName = user.get("handle")
        user =
          handle: userHandleName
        @handleToIndex[userHandleName] = user
        user
      @resetForce()
      @redraw()

    addNode: (hack)->
      hacker = hack.get("defender")
      defender = hack.get("hacker")
      link =
        source: @handleToIndex[hacker]
        target: @handleToIndex[defender]
      @links.push link
      @redraw()

    resetForce: ->
      @force
        .nodes(@nodes)
        .links(@links)
        .start()

    tick: (e)=>
      k = 4 * e.alpha

      @nodes.forEach (node)->
        node.x += k
        node.y += k

      @selectNode
        .attr "cx", (node)-> node.x
        .attr "cy", (node)-> node.y

      @selectLink
        .attr "x1", (link)-> link.source.x
        .attr "y1", (link)-> link.source.y
        .attr "x2", (link)-> link.target.x
        .attr "y2", (link)-> link.target.y

    redraw: ->
      @selectNode = @svg.selectAll(".node")
        .data @nodes
        .enter()
        .append "circle"
        .attr "class", "node"
        .attr "r", "6px"
        .attr "cx", (node)-> node.x
        .attr "cy", (node)-> node.y
        .style "fill", "rgba(255, 0, 0, 0.5)"
        .style "stroke", "#000000"
        .style "stroke-width", "1px"

      @selectLink = @svg.selectAll(".link")
        .data @links
        .enter()
        .append "line"
        .attr "class", "link"
        .attr "x1", (node)-> node.source.x
        .attr "y1", (node)-> node.source.y
        .attr "x2", (node)-> node.target.x
        .attr "y2", (node)-> node.target.y
        .style "stroke", "#ffffff"
        .style "stroke-width", "1px"

