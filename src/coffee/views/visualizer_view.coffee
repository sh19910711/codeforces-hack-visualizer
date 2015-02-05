define ["marionette", "d3"], (Marionette, d3)->

  class VisualizerView extends Marionette.ItemView

    template: "#template-visualizer-view"

    collectionEvents:
      "add": "addNode"

    ui: ->
      svg: "svg"

    initialize: ->
      @on "show", ->
        svgElement = @ui.svg.get(0)
        @svg = d3.select(svgElement)
        @users = []

    addNode: (hack)->
      hacker = hack.get("defender")
      @users.push hacker
      @svg.selectAll("circle")
        .data @users
        .enter()
        .append "circle"
        .attr "fill", "rgba(255, 255, 255, 0.9)"
        .attr "stroke": "rgba(255, 0, 0, 1)"
        .attr "cx", 0
        .attr "cy", 0
        .attr "r", "12px"


