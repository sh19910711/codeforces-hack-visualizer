templates = document.createElement("div")
templates.id = "templates"
jQuery("body").append templates
jQuery("#templates").html __html__["tmp/html/template.html"]

global.prepareFakeServer = ->
  before ->
    webServer = sinon.fakeServer.create()
    responseHeader = {
      "Content-Type": "application/json"
    }

    webServer.respondWith(
      "GET"
      "/api/contests"
      [
        200
        responseHeader
        JSON.stringify []
      ]
    )
