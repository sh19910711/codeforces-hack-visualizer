define ["marionette"], (Marionette)->

  class HackHistoryView extends Marionette.ItemView

    className: "small"

    template: "#template-hack-history-view"

    templateHelpers: ->
      Utils = require("utils")
      encodedHackStatus: ->
        if @verdict
          "#{Utils.hackerHandleHTML(@defender)} is <span class=\"text-success\">successful</span> hacking attempt of #{Utils.hackerHandleHTML(@hacker)}'s solution"
        else
          "#{Utils.hackerHandleHTML(@defender)} is <span class=\"text-danger\">unsuccessful</span> hacking attempt of #{Utils.hackerHandleHTML(@hacker)}'s solution"

