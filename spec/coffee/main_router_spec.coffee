Namespace = require("namespace")
Backbone = require("backbone")

describe "MainRouter", ->

  prepareFakeServer()

  context "prepare controller", ->
    before ->
      @controller = new Namespace::Controllers::MainController
      @spyShowHome = sinon.spy(@controller, "showHome")
      @spyShowContest = sinon.spy(@controller, "showContest")

    context "prepare router", ->
      before ->
        @router = new Namespace::Routers::MainRouter
          controller: @controller

      context "GET /", ->
        before ->
          Backbone.history.loadUrl "/"

        it "should called once", ->
          expect(@spyShowHome.calledOnce).to.be.true

        it "should called with no args", ->
          expect(@spyShowHome.calledWith()).to.be.true

      context "GET /contests/-/123", ->
        before ->
          Backbone.history.loadUrl "/contests/-/123"

        it "should called once", ->
          expect(@spyShowContest.calledOnce).to.be.true

        it "should called with 123", ->
          expect(@spyShowContest.calledWith "123").to.be.true

